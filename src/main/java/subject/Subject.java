package subject;

public class Subject {
   private int subID;
   private String subName;
   private String professor;
   
   public int getSubID() {
      return subID;
   }
   public void setSubID(int subID) {
      this.subID = subID;
   }
   public String getSubName() {
      return subName;
   }
   public void setSubName(String subName) {
      this.subName = subName;
   }
   public String getProfessor() {
      return professor;
   }
   public void setProfessor(String professor) {
      this.professor = professor;
   }
   public int getGrade() {
      return grade;
   }
   public void setGrade(int grade) {
      this.grade = grade;
   }
   private int grade;
}