import com.smartquiz.config.DBConnection;
import java.sql.*;
public class CreateFaculty {
    public static void main(String[] args) throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT IGNORE INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, "Faculty Two");
                ps.setString(2, "faculty2@smartquiz.com");
                ps.setString(3, "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3");
                ps.setString(4, "FACULTY");
                ps.executeUpdate();
                System.out.println("Faculty Two created.");
            }
        }
    }
}
