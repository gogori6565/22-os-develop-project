package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

//DAO : 데이터 접근 객체 = 실제 DB에 접근해 어떤 데이터를 빼올 수 있는 클래스
public class BbsDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	/*실제로 DB에서 데이터를 가져오거나 넣는 역할을 하는 함수 - 데이터 접근 객체*/
	public BbsDAO() {
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
	
	/*현재 시간 가져오는 함수 - 게시판 글 작성 시 서버 시간 넣어줌*/
	public String getDate() { 
		String SQL = "SELECT NOW()"; //현재 시간 가져오는 MySQL 문장
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			rs = pstmt.executeQuery(); //실제 실행 시 나오는 결과 가져오기
			if (rs.next()) { //결과가 있는 경우
				return rs.getString(1); //현재 날짜 그대로 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	public int getNext() { 
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //마지막에 쓰인 글을 가져와서 그 글 번호에 +1 더한 값이 다음 글의 번호
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			rs = pstmt.executeQuery(); //실제 실행 시 나오는 결과 가져오기
			if (rs.next()) { //결과가 있는 경우
				return rs.getInt(1)+1; //현재 날짜 그대로 반환
			}
			return 1; //현재가 첫번째 게시물인 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 - 게시글 번호로 -1 은 적절치 않음
	}
	
	/*글 작성*/
	public int write(String bbsTitle, String userID, String bbsContent, int Subject, String topic, int currentPeople, int totalPeople) {
        String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; //마지막에 쓰인 글을 가져와서 그 글 번호에 +1 더한 값이 다음 글의 번호
        try {
           PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
           pstmt.setInt(1, getNext()); //다음 번에 쓰일 게시글 번호
           pstmt.setString(2, bbsTitle);
           pstmt.setString(3, userID);
           pstmt.setString(4, getDate());
           pstmt.setString(5, bbsContent);
           pstmt.setInt(6, 1); //처음 글 쓸 때는 보여지는 거니까(삭제가 안된 거니까) PRIMARY KEY = 1
           pstmt.setInt(7, Subject);
           pstmt.setString(8, topic);
           pstmt.setInt(9, currentPeople);
           pstmt.setInt(10, totalPeople);
           
           return pstmt.executeUpdate(); //0 이상의 결과 반환
           
        } catch(Exception e) {
           e.printStackTrace();
        }
        return -1; //데이터베이스 오류 - 게시글 번호로 -1 은 적절치 않음
     }
	
	/*특정 페이지 번호(pageNumber)에 맞는 게시글 리스트를 반환*/
	public ArrayList<Bbs> getList(int pageNumber){
		//BBS 테이블에서 bbsID가 ?(85번째 줄 pstmt에 담길 숫자) 보다 작을 경우 AND bbsAvailable이 1인(삭제가 되지 않은 게시글) 게시글만 가져오고 그걸 bbsID로 내림차순 정렬하여 위에서 10개까지만 가져오기
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC"; 
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			pstmt.setInt(1,  getNext() - (pageNumber - 1)*10); //getNext() : 다음으로 작성될 글의 번호
			rs = pstmt.executeQuery(); //실제 실행 시 나오는 결과 가져오기
			while (rs.next()) { //결과가 나올 때마다
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setSubject(rs.getInt(7));
				bbs.setTopic(rs.getString(8));
				bbs.setCurrentpeople(rs.getInt(9));
				bbs.setTotalpeople(rs.getInt(10));
				list.add(bbs);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list; //10개 뽑아온 게시글 리스트를 출력할 수 있게 반환
	}
	
	/*페이징 처리
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			pstmt.setInt(1,  getNext() - (pageNumber - 1)*10); //getNext() : 다음으로 작성될 글의 번호
			rs = pstmt.executeQuery(); //실제 실행 시 나오는 결과 가져오기
			if (rs.next()) { //결과가 존재한다면
				return true; //다음페이지로 넘어갈 수 있음
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false; //다음페이지로 못 넘어감
	}*/
	
	/*게시글 가져오기*/
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?"; //bbsID가 특정한 숫자(?)에 해당하는 게시글을 가져오기
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) { //결과가 존재한다면
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setSubject(rs.getInt(7));
				bbs.setTopic(rs.getString(8));
				bbs.setCurrentpeople(rs.getInt(9));
				bbs.setTotalpeople(rs.getInt(10));
				return bbs;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; //글이 존재하지 않는 경우
	}
	
	/*글 수정*/
	public int update(int bbsID, String bbsTitle, String bbsContent) { //글 번호, 글 제목, 글 내용 수정
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?"; //특정한 아이디에 해당하는 제목과 내용을 바꿔주겠다.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			pstmt.setString(1, bbsTitle); //다음 번에 쓰일 게시글 번호
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			
			return pstmt.executeUpdate(); //성공 시, 0 이상의 결과 반환
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 - 게시글 번호로 -1 은 적절치 않음
	}
	
	/*글 삭제*/
	public int delete(int bbsID) {
		String SQL = "DELETE FROM BBS WHERE bbsID = ?"; //글 삭제 해도 남아있도록 bbsAvailable 값만 0으로 바꿔줌
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			pstmt.setInt(1, bbsID);
			int suc = pstmt.executeUpdate();
			if(suc!=0) { //삭제 성공 시,
				
				//게시글 전체 개수 구하기
				SQL = "SELECT COUNT(*) FROM bbs";
				int count=0;
				try {
					pstmt = conn.prepareStatement(SQL);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						count=rs.getInt(1);
					}
					
					//뒷 게시글 bbsID -1씩 줄이기
					SQL = "UPDATE bbs SET bbsID = ? WHERE bbsID = ?";
					try {
						for(int i=bbsID+1; i<=count+1; i++) {
							pstmt = conn.prepareStatement(SQL);
							pstmt.setInt(1, i-1);
							pstmt.setInt(2, i);
							pstmt.executeUpdate();
						}
					} catch(Exception e){
						e.printStackTrace();
					}
					
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
			
			return suc; //성공 시, 0 이상의 결과 반환
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	/*팀 영입 시, CurrentPeople 값 +1 증가*/
	public int CPupdate(int bbsID) {
		String SQL = "UPDATE BBS SET CurrentPeople=CurrentPeople+1 WHERE bbsID = ?"; //특정한 아이디에 해당하는 제목과 내용을 바꿔주겠다.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //위 SQL문장을 실행 준비 단계로 만듦
			pstmt.setInt(1, bbsID);
			
			return pstmt.executeUpdate(); //성공 시, 0 이상의 결과 반환
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 - 게시글 번호로 -1 은 적절치 않음
	}
}
