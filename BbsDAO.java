package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext());
			pstmt.setString(2,  bbsTitle);
			pstmt.setString(3,  userID);
			pstmt.setString(4,  getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6,  1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT *FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
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
}
