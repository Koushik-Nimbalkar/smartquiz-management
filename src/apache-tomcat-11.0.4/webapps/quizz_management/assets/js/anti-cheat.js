/**
 * SmartQuiz Anti-Cheating Engine
 * Detects tab switching, right-clicks, copy-paste, and fullscreen exits.
 */

class AntiCheatEngine {
    constructor(maxTabSwitches = 3) {
        this.tabSwitches = 0;
        this.maxTabSwitches = maxTabSwitches;
        this.isExamActive = false;
        
        this.initEventListeners();
    }

    start() {
        this.isExamActive = true;
        this.requestFullscreen();
        console.log("Anti-Cheat Engine Activated.");
    }

    stop() {
        this.isExamActive = false;
    }

    initEventListeners() {
        // Prevent Right Click
        document.addEventListener('contextmenu', (e) => {
            if (this.isExamActive) {
                e.preventDefault();
                this.showAlert('Right-click is disabled during the exam.');
            }
        });

        // Prevent Copy, Cut, Paste
        ['copy', 'cut', 'paste'].forEach(eventName => {
            document.addEventListener(eventName, (e) => {
                if (this.isExamActive) {
                    e.preventDefault();
                    this.showAlert(`${eventName} is disabled during the exam.`);
                }
            });
        });

        // Detect Tab Switching or Window Blur
        document.addEventListener('visibilitychange', () => {
            if (this.isExamActive && document.visibilityState === 'hidden') {
                this.handleTabSwitch();
            }
        });

        window.addEventListener('blur', () => {
            if (this.isExamActive) {
                // Blur event could fire even if visibility is not hidden (e.g., clicking on another monitor)
                this.handleTabSwitch();
            }
        });

        // Detect Keyboard Shortcuts (Ctrl+C, Ctrl+V, PrintScreen, etc.)
        document.addEventListener('keydown', (e) => {
            if (!this.isExamActive) return;

            // F12 (DevTools)
            if (e.key === 'F12') {
                e.preventDefault();
            }
            
            // Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U
            if (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J') || (e.ctrlKey && e.key === 'U')) {
                e.preventDefault();
            }
            
            // PrintScreen
            if (e.key === 'PrintScreen') {
                navigator.clipboard.writeText(''); // Attempt to clear clipboard
                this.showAlert('Screenshots are not allowed.');
            }
        });

        // Detect Fullscreen Exit
        document.addEventListener('fullscreenchange', () => {
            if (this.isExamActive && !document.fullscreenElement) {
                this.showAlert('You exited fullscreen mode. Please return to fullscreen to continue.');
                // Optionally handle as a violation
            }
        });
    }

    handleTabSwitch() {
        this.tabSwitches++;
        const remaining = this.maxTabSwitches - this.tabSwitches;
        
        if (this.tabSwitches >= this.maxTabSwitches) {
            this.forceSubmit('Maximum tab switches exceeded. Exam auto-submitted.');
        } else {
            alert(`WARNING: You switched tabs or minimized the window. \n\nThis is violation ${this.tabSwitches} of ${this.maxTabSwitches}. \nYour exam will be auto-submitted if you do this ${remaining} more time(s).`);
            this.logViolation('TAB_SWITCH');
        }
    }

    requestFullscreen() {
        const elem = document.documentElement;
        if (elem.requestFullscreen) {
            elem.requestFullscreen().catch(err => {
                console.warn(`Error attempting to enable fullscreen: ${err.message}`);
            });
        }
    }

    showAlert(message) {
        // Create an attractive alert rather than using the basic browser alert
        const alertDiv = document.createElement('div');
        alertDiv.className = 'position-fixed top-0 start-50 translate-middle-x mt-4 p-3 bg-danger text-white rounded shadow-lg z-3';
        alertDiv.style.zIndex = '9999';
        alertDiv.innerHTML = `<i class="fa-solid fa-triangle-exclamation me-2"></i> ${message}`;
        document.body.appendChild(alertDiv);
        
        setTimeout(() => {
            alertDiv.remove();
        }, 3000);
    }

    logViolation(type) {
        // This would typically make an AJAX request to log the violation
        console.log(`Violation logged: ${type}`);
        // Fetch API to /api/log-violation
    }

    forceSubmit(reason) {
        alert(reason);
        // Find and submit the quiz form
        const form = document.getElementById('quizForm');
        if (form) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'auto_submit_reason';
            input.value = 'anti_cheat_violation';
            form.appendChild(input);
            form.submit();
        } else {
            window.location.href = 'dashboard.jsp?error=auto_submitted';
        }
    }
}

// Instantiate globally to be used on quiz pages
const antiCheat = new AntiCheatEngine();
