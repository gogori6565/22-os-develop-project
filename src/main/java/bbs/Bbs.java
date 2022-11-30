package bbs;

public class Bbs {

		private int bbsID;
		private String bbsTitle;
		private String userID;
		private String bbsDate;
		private String bbsContent;
		private int bbsAvailable;
		private int Subject;
		private String topic;
		private int currentpeople;
		private int totalpeople;
		
		//우클릭 -> source -> Generate Getters and Setters
		public int getBbsID() {
			return bbsID;
		}
		public void setBbsID(int bbsID) {
			this.bbsID = bbsID;
		}
		public String getBbsTitle() {
			return bbsTitle;
		}
		public void setBbsTitle(String bbsTitle) {
			this.bbsTitle = bbsTitle;
		}
		public String getUserID() {
			return userID;
		}
		public void setUserID(String userID) {
			this.userID = userID;
		}
		public String getBbsDate() {
			return bbsDate;
		}
		public void setBbsDate(String bbsDate) {
			this.bbsDate = bbsDate;
		}
		public String getBbsContent() {
			return bbsContent;
		}
		public void setBbsContent(String bbsContent) {
			this.bbsContent = bbsContent;
		}
		public int getBbsAvailable() {
			return bbsAvailable;
		}
		public void setBbsAvailable(int bbsAvailable) {
			this.bbsAvailable = bbsAvailable;
		}
		public int getSubject() {
			return Subject;
		}
		public void setSubject(int subject) {
			this.Subject = subject;
		}
		public String getTopic() {
			return topic;
		}
		public void setTopic(String topic) {
			this.topic = topic;
		}
		public int getCurrentpeople() {
			return currentpeople;
		}
		public void setCurrentpeople(int currentpeople) {
			this.currentpeople = currentpeople;
		}
		public int getTotalpeople() {
			return totalpeople;
		}
		public void setTotalpeople(int totalpeople) {
			this.totalpeople = totalpeople;
		}
		
}
