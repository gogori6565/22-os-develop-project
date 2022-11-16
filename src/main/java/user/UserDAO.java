package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//실질적으로 DB에서 회원정보를 불러오거나 넣고자 할 떄 사용
public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	/*실제로 DB에서 데이터를 가져오거나 넣는 역할을 하는 함수 - 데이터 접근 객체*/
	public UserDAO() {
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
	
	/*계정에 대한 로그인 시도 함수*/
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?"; //user table에서 사용자의 패스워드를 가져올 수 있도록 함
		//userID를 입력받아(매개변수) table에서 실제 패스워드가 존재하는지 -> 존재한다면 비밀번호는 뭔지 db에서 가져옴
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery(); //실행결과를 객체에 담음
			if(rs.next()) { //결과가 존재한다면
				if(rs.getString(1).equals(userPassword)) {
					return 1; //로그인 성공
				}
				else
					return 0; //비밀번호 틀림
			}
			return -1; //아이디가 없음
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -2; //데이터베이스 오류
	}
	
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL); //SQL 문에서 받아오기
			//? 에서 받은 데이터 하나씩 넣기
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 - INSERT 문장 실행 시 반드시 0이상의 값이 반환됨(성공)
	}
}
