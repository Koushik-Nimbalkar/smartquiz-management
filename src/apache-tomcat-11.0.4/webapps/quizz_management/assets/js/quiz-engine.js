/**
 * SmartQuiz Quiz Engine
 * Manages countdown timer, auto-submit, and question palette.
 */

class QuizEngine {
    constructor(durationMinutes, endTimeStr) {
        this.durationSeconds = durationMinutes * 60;
        this.endTime = new Date(endTimeStr).getTime();
        this.timerInterval = null;
        
        this.init();
    }

    init() {
        this.updateTimerDisplay();
        this.startTimer();
        
        // Question Palette click handlers
        document.querySelectorAll('.palette-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const qNum = e.target.dataset.question;
                this.scrollToQuestion(qNum);
            });
        });

        // Mark for review handlers
        document.querySelectorAll('.mark-review').forEach(checkbox => {
            checkbox.addEventListener('change', (e) => {
                const qNum = e.target.dataset.question;
                const paletteBtn = document.querySelector(`.palette-btn[data-question="${qNum}"]`);
                if (e.target.checked) {
                    paletteBtn.classList.add('bg-warning', 'text-dark');
                    paletteBtn.classList.remove('btn-outline-secondary');
                } else {
                    paletteBtn.classList.remove('bg-warning', 'text-dark');
                    // Check if answered
                    this.updatePaletteState(qNum);
                }
            });
        });

        // Answer selection handlers (radios/checkboxes)
        document.querySelectorAll('.question-option input').forEach(input => {
            input.addEventListener('change', (e) => {
                const qNum = e.target.closest('.question-card').dataset.question;
                this.updatePaletteState(qNum);
                // Trigger auto-save
                this.autoSave();
            });
        });
    }

    startTimer() {
        this.timerInterval = setInterval(() => {
            const now = new Date().getTime();
            const distance = this.endTime - now;

            if (distance <= 0) {
                clearInterval(this.timerInterval);
                document.getElementById('timerDisplay').innerHTML = "00:00:00";
                this.autoSubmit("Time's up! Your quiz is being submitted automatically.");
            } else {
                const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                const display = 
                    (hours > 0 ? (hours < 10 ? "0" + hours + ":" : hours + ":") : "") +
                    (minutes < 10 ? "0" + minutes : minutes) + ":" + 
                    (seconds < 10 ? "0" + seconds : seconds);
                
                document.getElementById('timerDisplay').innerHTML = display;

                // Warning when less than 5 minutes
                if (distance < 5 * 60 * 1000) {
                    document.getElementById('timerBadge').classList.remove('bg-primary');
                    document.getElementById('timerBadge').classList.add('bg-danger', 'animate-pulse');
                }
            }
        }, 1000);
    }

    updateTimerDisplay() {
        // Initial setup handled by startTimer
    }

    scrollToQuestion(qNum) {
        const el = document.querySelector(`.question-card[data-question="${qNum}"]`);
        if (el) {
            el.scrollIntoView({ behavior: 'smooth', block: 'center' });
            // Highlight briefly
            el.classList.add('border-primary');
            setTimeout(() => el.classList.remove('border-primary'), 1000);
        }
    }

    updatePaletteState(qNum) {
        const card = document.querySelector(`.question-card[data-question="${qNum}"]`);
        const isReviewed = card.querySelector('.mark-review').checked;
        const isAnswered = card.querySelectorAll('input:checked').length > 0 || 
                           (card.querySelector('textarea') && card.querySelector('textarea').value.trim() !== '');

        const paletteBtn = document.querySelector(`.palette-btn[data-question="${qNum}"]`);
        
        if (isReviewed) return; // Handled by checkbox listener

        if (isAnswered) {
            paletteBtn.classList.add('bg-success', 'text-white');
            paletteBtn.classList.remove('btn-outline-secondary');
        } else {
            paletteBtn.classList.remove('bg-success', 'text-white');
            paletteBtn.classList.add('btn-outline-secondary');
        }
    }

    autoSave() {
        // In a real app, this would use fetch API to save answers to the server
        console.log("Answers auto-saved to server.");
        const savingIndicator = document.getElementById('savingIndicator');
        if (savingIndicator) {
            savingIndicator.style.opacity = '1';
            setTimeout(() => {
                savingIndicator.style.opacity = '0';
            }, 2000);
        }
    }

    autoSubmit(message) {
        alert(message);
        document.getElementById('quizForm').submit();
    }
}

// Add a pulse animation to style
const style = document.createElement('style');
style.innerHTML = `
@keyframes pulse-red {
    0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7); }
    50% { transform: scale(1.05); box-shadow: 0 0 0 10px rgba(220, 53, 69, 0); }
    100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(220, 53, 69, 0); }
}
.animate-pulse {
    animation: pulse-red 1.5s infinite;
}
`;
document.head.appendChild(style);
