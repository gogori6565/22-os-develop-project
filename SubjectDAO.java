package subject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class SubjectDAO {

   private Connection conn;
   private ResultSet rs;
   
   public SubjectDAO() {
      try {
         String dbURL = "jdbc:mysql://localhost:3306/BBS?useSSL=false&user=root&password=root";
         String dbID = "root";
         String dbPassword = "root";
         Class.forName("com.mysql.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   public ArrayList<Subject> getList() {
      String SQL = "SELECT *FROM SUBJECT";
      ArrayList<Subject> sublist = new ArrayList<Subject>();
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         rs = pstmt.executeQuery();
         while(rs.next()) {
            Subject sub = new Subject();
            sub.setSubID(rs.getInt(1));
            sub.setSubName(rs.getString(2));
            sub.setProfessor(rs.getString(3));
            sub.setClassTime(rs.getString(4));
            sub.setGrade(rs.getInt(5));
            sublist.add(sub);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return sublist;
   }
   
   
}