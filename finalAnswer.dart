void main()
{

  // add the output
  Department csDept = Department('Computer Science');

  Professor prof1 =
  Professor('Dr. Smith', 'smith@uni.edu', 'P001', 'AI');
  Professor prof2 =
  Professor('Dr. jones', 'h_smadi@uni.edu', 'P002', 'It support');

  csDept.addProfessor(prof1);
  csDept.addProfessor(prof2);

  Student student1 =
  Student ('Alice', 'alice@student.edu', 'S001');
  Student student2 =
  Student('ali', 'ali@student.edu', 'S002');

  csDept.addStudent(student1);
  csDept.addStudent(student2);


  Course course1 = Course('CS101', 'Introduction to Programming');
  Course course2 = Course('CS201', 'Computer Networks');

  csDept.addCourse(course1);
  csDept.addCourse(course2);

  course1.assignProfessor(prof1);
  course2.assignProfessor(prof2);

  course1.enrollStudent(student1);
  course2.enrollStudent(student2);

  course1.scheduleSession(DateTime(2024, 7, 2, 9, 0));
  course2.scheduleSession(DateTime(2024, 7, 3, 11, 0));

  prof1.AssignGrades(student1, course1, 95);
  prof2.AssignGrades(student1, course2, 90);

  List<User> users = [student1, student2, prof1, prof2];
  for (var user in users) {
    user.displayInfo();
  }

  print('\nSearching for course CS201:');
  Course? foundCourse = csDept.findCourseByCode('CS201');
  if (foundCourse != null) {
    print(
        '${foundCourse.courseCode}: ${foundCourse.title} (Professor: ${foundCourse.assignedProf?.name})');
  }

  print('\nTotal courses offered: ${Course.totalCourses}');

  print("Alice's GPA: ${student1.gpa}");
}
abstract class User
{
  String name ;
  String email;

  User(this.name,this.email);

  void displayInfo();



}

class Student extends User
{
  String studentID;
  List<Course> regesteredCourses=[];
  double _GPA=0.0;
  Student(String name ,String email, this.studentID):super(name ,email);

  Map <String , double> _grades={};

  void AddGrades(String courseCode,double Grade)
  {
    _grades[courseCode]=Grade;
  }

  void _CalculateGPA()
  {if(_grades.isEmpty)
  {
    _GPA=0.0;
    return;
  }
  _GPA=_grades.values.reduce((a,b)=>a+b)/_grades.length;

  }

  double get gpa
  {_CalculateGPA();
  if(_GPA>=90)
    return 4.0;
  else if (_GPA>=80 &&_GPA<90)
    return 3.5;
  else if (_GPA>=70 &&_GPA<80)
    return 3.0;
  else if (_GPA>=60 &&_GPA<70)
    return 2.5;
  else if (_GPA>=50 &&_GPA<60)
    return 2.0;
  else
    return 0.5;
  }

  void enroll(Course course)
  {
    regesteredCourses.add(course);
  }
  @override
  void displayInfo() {
    print('Student: $name, Email: $email, ID: $studentID, GPA: $gpa');
  }


}


class Professor extends User with Evaluatable
{
  String professorID;
  String specialty;
  List assignedCourses=[];

  Professor(String name ,String email ,this.professorID , this.specialty):super(name , email);

  @override
  void AssignGrades(Student student , Course course, double grades)
  {
    student.AddGrades(course.courseCode, grades);
  }

  @override
  void displayInfo() {
    print('professor: $name, Email: $email, ID: $professorID');
  }


}



class Course implements schedulable
{
  static int totalCourses =0;
  String courseCode;
  String title;
  Professor? assignedProf;
  DateTime? courseTime;
  List<Student> enrolledStudents=[];
  Course(this.courseCode,this.title)
  {totalCourses++;}

  @override
  void scheduleSession(DateTime dateTime)
  {
    courseTime=dateTime;
  }
  void assignProfessor(Professor professor) {
    assignedProf = professor;
    professor.assignedCourses.add(this);
  }

  void enrollStudent(Student student) {
    enrolledStudents.add(student);
    student.enroll(this);
    print('${student.name} enrolled in $courseCode');
  }

}


mixin Evaluatable
{
  void AssignGrades(Student student , Course course, double grades);
}
abstract class schedulable
{
  void scheduleSession(DateTime dateTime);
}

class Department
{
  String name;

  List<Student> students=[];
  List<Professor> professors=[];
  List <Course>courses=[];

  Department(this.name);

  void addStudent(Student student) => students.add(student);
  void addProfessor(Professor professor) => professors.add(professor);
  void addCourse(Course course) => courses.add(course);

  Student? findStudentById(String id) {
    for (var student in students) {
      if (student.studentID == id) {
        return student;
      }
    }
    return null;
  }


  Course? findCourseByCode(String code) {
    for (var course in courses) {
      if (course.courseCode == code) {
        return course;
      }

    }
    return null;
  }


  Professor? findProfessorById(String id) {
    for (var professor in professors) {
      if (professor.professorID == id) {
        return professor;
      }
    }
    return null;
  }
}

