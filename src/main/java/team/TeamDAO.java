package team;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class TeamDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public TeamDAO() {
		//예외처리
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?useSSL=false&user=root&password=1234"; //포트: 내 컴퓨터에 설치된 mysql 서버, BBS란 데이터 베이스에 접속하겠다. 
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword); //dbURL에 dbID로 dbPassword를 이용해서 접속하겠다. -> 완료 시, conn 객체 안에 접속 정보가 담김
		} catch (Exception e) {
			e.printStackTrace(); //오류가 뭔지 출력
		}
	}
	
	//팀 신청하기 누르면 DB 세팅되는 값 넣기
	public int setTeam(int bbsID, String userID, int teamCheck) {
        String SQL = "INSERT INTO team VALUES (?, ?, ?)";
        try {
           PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
           pstmt.setInt(1, bbsID);
           pstmt.setString(2, userID);
           pstmt.setInt(3, teamCheck);
           
           return pstmt.executeUpdate(); //0 이상의 결과 반환
           
        } catch(Exception e) {
           e.printStackTrace();
        }
        return -1; //데이터베이스 오류 - 게시글 번호로 -1 은 적절치 않음
     }
	
	public ArrayList<Team> getList() {
	      String SQL = "SELECT *FROM TEAM";
	      ArrayList<Team> sublist = new ArrayList<Team>();
	      try {
	         PreparedStatement pstmt = conn.prepareStatement(SQL);
	         rs = pstmt.executeQuery();
	         while(rs.next()) {
	            Team team = new Team();
	            team.setBbsID(rs.getInt(1));
	            team.setUserID(rs.getString(2));
	            team.setTeamcheck(rs.getInt(3));
	            sublist.add(team);
	         }
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return sublist;
	   }
	
	public int teamUpdate(int bbsID, String userID, int teamCheck) { //글 번호, 글 제목, 글 내용 수정
		String SQL = "UPDATE TEAM SET teamCheck=? WHERE bbsID=? AND userID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			
			pstmt.setInt(1, teamCheck); 
			pstmt.setInt(2, bbsID); 
			pstmt.setString(3, userID); 
			
			int suc=pstmt.executeUpdate(); //성공 시, 0 이상의 결과 반환
			
			if(suc!=0) { //성공 시,
				SQL = "UPDATE BBS SET CurrentPeople=CurrentPeople+1 WHERE bbsID = ?"; //특정한 아이디에 해당하는 제목과 내용을 바꿔주겠다.
				try {
					pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
					pstmt.setInt(1, bbsID);
					
					return pstmt.executeUpdate(); //성공 시, 0 이상의 결과 반환
					
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 - 게시글 번호로 -1 은 적절치 않음
	}

	
	
}
