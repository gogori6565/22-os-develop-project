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
         String dbURL = "jdbc:mysql://localhost:3306/BBS?useSSL=false&user=root&password=1234";
         String dbID = "root";
         String dbPassword = "1234";
         Class.forName("com.mysql.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   public ArrayList<Subject> getList() {
      String SQL = "SELECT *FROM SUBJECT ORDER BY SubID";
      ArrayList<Subject> list = new ArrayList<Subject>();
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         rs = pstmt.executeQuery();
         while(rs.next()) {
            Subject sub = new Subject();
            sub.setSubID(rs.getInt(1));
            sub.setSubName(rs.getString(2));
            sub.setProfessor(rs.getString(3));
            sub.setGrade(rs.getInt(4));
            sub.setClassTime(rs.getString(5));
            list.add(sub);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return list;
   }
   
   public Subject getSubject(int subID) {
      String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         pstmt.setInt(1, subID);
         rs = pstmt.executeQuery();
         if(rs.next()) {
            Subject sub = new Subject();
            sub.setSubID(rs.getInt(1));
            sub.setSubName(rs.getString(2));
            sub.setProfessor(rs.getString(3));
            sub.setGrade(rs.getInt(4));
            return sub;
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return null;
   }
   
   
}