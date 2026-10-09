import '../models/assignment.dart';
import '../models/calendar_event.dart';
import '../models/course.dart';
import '../models/exam.dart';
import '../models/hackathon.dart';
import '../models/internship.dart';
import '../models/interview.dart';
import '../models/job.dart';
import '../models/note.dart';
import '../models/notification.dart';
import '../models/resume.dart';
import '../models/skill.dart';
import '../models/study_plan.dart';
import '../models/subject.dart';
import '../models/task.dart';
import '../models/timetable.dart';
import '../models/user.dart';

class MockDataService {
  static bool _initialized = false;

  // In-memory data store
  static User currentUser = User(
    id: 'user-demo-1',
    email: 'student@demo.com',
    role: 'STUDENT',
    profile: Profile(
      id: 'profile-demo-1',
      userId: 'user-demo-1',
      fullName: 'Aarav Sharma',
      avatarUrl: null,
      college: 'National Institute of Technology',
      department: 'Computer Science & Engineering',
      year: 3,
      rollNumber: '21BCSE088',
      gpa: 8.7,
      careerScore: 78,
      studyHoursTotal: 24.5,
      bio: 'Passionate about distributed systems, Flutter mobile architecture, and Machine Learning.',
      phone: '+91 98765 43210',
    ),
  );

  static List<Subject> subjects = [
    Subject(id: 'sub-1', userId: 'user-demo-1', name: 'Machine Learning', code: 'CS601', credits: 4, faculty: 'Dr. Johnson', color: '#4F46E5', totalClasses: 28, attendedClasses: 25),
    Subject(id: 'sub-2', userId: 'user-demo-1', name: 'Cloud Computing & DevOps', code: 'CS602', credits: 3, faculty: 'Prof. Miller', color: '#06B6D4', totalClasses: 24, attendedClasses: 21),
    Subject(id: 'sub-3', userId: 'user-demo-1', name: 'Compiler Design', code: 'CS603', credits: 4, faculty: 'Dr. Aris', color: '#F59E0B', totalClasses: 26, attendedClasses: 18),
    Subject(id: 'sub-4', userId: 'user-demo-1', name: 'Mobile Application Engineering', code: 'CS604', credits: 3, faculty: 'Prof. Sarah', color: '#10B981', totalClasses: 30, attendedClasses: 28),
    Subject(id: 'sub-5', userId: 'user-demo-1', name: 'Information Security', code: 'CS605', credits: 3, faculty: 'Dr. Zhang', color: '#EF4444', totalClasses: 22, attendedClasses: 16),
    Subject(id: 'sub-6', userId: 'user-demo-1', name: 'Software Project Management', code: 'CS606', credits: 2, faculty: 'Prof. David', color: '#8B5CF6', totalClasses: 20, attendedClasses: 19),
  ];

  static Map<String, List<TimetableSlot>> timetable = {
    'Monday': [
      TimetableSlot(id: 'tt-1', subjectId: 'sub-1', subjectName: 'Machine Learning', subjectCode: 'CS601', startTime: '09:00 AM', endTime: '10:00 AM', room: 'Room 301', faculty: 'Dr. Johnson', color: '#4F46E5'),
      TimetableSlot(id: 'tt-2', subjectId: 'sub-2', subjectName: 'Cloud Computing', subjectCode: 'CS602', startTime: '10:15 AM', endTime: '11:15 AM', room: 'Lab 2', faculty: 'Prof. Miller', color: '#06B6D4'),
      TimetableSlot(id: 'tt-3', subjectId: 'sub-4', subjectName: 'Mobile App Eng', subjectCode: 'CS604', startTime: '01:30 PM', endTime: '03:30 PM', room: 'Mobile Lab', faculty: 'Prof. Sarah', color: '#10B981'),
    ],
    'Tuesday': [
      TimetableSlot(id: 'tt-4', subjectId: 'sub-3', subjectName: 'Compiler Design', subjectCode: 'CS603', startTime: '09:00 AM', endTime: '10:00 AM', room: 'Room 204', faculty: 'Dr. Aris', color: '#F59E0B'),
      TimetableSlot(id: 'tt-5', subjectId: 'sub-5', subjectName: 'Info Security', subjectCode: 'CS605', startTime: '11:30 AM', endTime: '12:30 PM', room: 'Room 105', faculty: 'Dr. Zhang', color: '#EF4444'),
      TimetableSlot(id: 'tt-6', subjectId: 'sub-1', subjectName: 'Machine Learning Lab', subjectCode: 'CS601', startTime: '02:00 PM', endTime: '04:00 PM', room: 'AI Lab 1', faculty: 'Dr. Johnson', color: '#4F46E5'),
    ],
    'Wednesday': [
      TimetableSlot(id: 'tt-7', subjectId: 'sub-2', subjectName: 'Cloud Computing', subjectCode: 'CS602', startTime: '09:00 AM', endTime: '10:00 AM', room: 'Lab 2', faculty: 'Prof. Miller', color: '#06B6D4'),
      TimetableSlot(id: 'tt-8', subjectId: 'sub-6', subjectName: 'Project Management', subjectCode: 'CS606', startTime: '10:15 AM', endTime: '11:15 AM', room: 'Seminar Hall', faculty: 'Prof. David', color: '#8B5CF6'),
    ],
    'Thursday': [
      TimetableSlot(id: 'tt-9', subjectId: 'sub-4', subjectName: 'Mobile App Eng', subjectCode: 'CS604', startTime: '09:00 AM', endTime: '10:00 AM', room: 'Mobile Lab', faculty: 'Prof. Sarah', color: '#10B981'),
      TimetableSlot(id: 'tt-10', subjectId: 'sub-5', subjectName: 'Info Security', subjectCode: 'CS605', startTime: '10:15 AM', endTime: '11:15 AM', room: 'Room 105', faculty: 'Dr. Zhang', color: '#EF4444'),
      TimetableSlot(id: 'tt-11', subjectId: 'sub-3', subjectName: 'Compiler Design Lab', subjectCode: 'CS603', startTime: '01:30 PM', endTime: '03:30 PM', room: 'Systems Lab', faculty: 'Dr. Aris', color: '#F59E0B'),
    ],
    'Friday': [
      TimetableSlot(id: 'tt-12', subjectId: 'sub-1', subjectName: 'Machine Learning', subjectCode: 'CS601', startTime: '09:00 AM', endTime: '10:00 AM', room: 'Room 301', faculty: 'Dr. Johnson', color: '#4F46E5'),
      TimetableSlot(id: 'tt-13', subjectId: 'sub-6', subjectName: 'Project Review', subjectCode: 'CS606', startTime: '11:30 AM', endTime: '01:00 PM', room: 'Seminar Hall', faculty: 'Prof. David', color: '#8B5CF6'),
    ],
    'Saturday': [
      TimetableSlot(id: 'tt-14', subjectId: 'sub-4', subjectName: 'Hackathon & Open Lab', subjectCode: 'CS604', startTime: '10:00 AM', endTime: '01:00 PM', room: 'Innovation Hub', faculty: 'Industry Mentors', color: '#10B981'),
    ],
  };

  static List<Assignment> assignments = [
    Assignment(id: 'asgn-1', userId: 'user-demo-1', title: 'CNN Architecture Optimization for CIFAR-10', description: 'Implement ResNet-18 variant and achieve >88% validation accuracy with TensorBoard logs.', dueDate: DateTime.now().add(const Duration(days: 2)), priority: 'HIGH', status: 'PENDING', maxMarks: 100, subject: subjects[0]),
    Assignment(id: 'asgn-2', userId: 'user-demo-1', title: 'Kubernetes Cluster Deployment on AWS', description: 'Containerize microservices and deploy with auto-scaling ReplicaSets and Ingress.', dueDate: DateTime.now().add(const Duration(days: 4)), priority: 'MEDIUM', status: 'IN_PROGRESS', maxMarks: 100, subject: subjects[1]),
    Assignment(id: 'asgn-3', userId: 'user-demo-1', title: 'LR(1) Parser Implementation in C/C++', description: 'Construct canonical collection of LR(1) items and parse input tokens.', dueDate: DateTime.now().add(const Duration(days: 7)), priority: 'HIGH', status: 'PENDING', maxMarks: 100, subject: subjects[2]),
    Assignment(id: 'asgn-4', userId: 'user-demo-1', title: 'Flutter State Management Benchmark', description: 'Compare Provider, Bloc, and Riverpod on high-frequency rendering lists.', dueDate: DateTime.now().add(const Duration(days: 10)), priority: 'MEDIUM', status: 'COMPLETED', maxMarks: 100, subject: subjects[3]),
    Assignment(id: 'asgn-5', userId: 'user-demo-1', title: 'RSA & AES Hybrid Encryption Scheme', description: 'Implement cryptographic key exchange with digital signatures.', dueDate: DateTime.now().subtract(const Duration(days: 1)), priority: 'HIGH', status: 'OVERDUE', maxMarks: 100, subject: subjects[4]),
    Assignment(id: 'asgn-6', userId: 'user-demo-1', title: 'Agile Sprint Retrospective Report', description: 'Document user stories, velocity charts, and burndown telemetry.', dueDate: DateTime.now().add(const Duration(days: 14)), priority: 'LOW', status: 'PENDING', maxMarks: 50, subject: subjects[5]),
  ];

  static List<Exam> exams = [
    Exam(id: 'exam-1', userId: 'user-demo-1', subjectName: 'Machine Learning', type: 'INTERNAL', date: DateTime.now().add(const Duration(days: 3)), startTime: '09:30 AM', endTime: '11:00 AM', room: 'Hall 201', syllabus: 'Supervised Learning, Loss Functions, Gradient Descent, Decision Trees, Backpropagation, CNNs', maxMarks: 50),
    Exam(id: 'exam-2', userId: 'user-demo-1', subjectName: 'Compiler Design', type: 'INTERNAL', date: DateTime.now().add(const Duration(days: 8)), startTime: '09:30 AM', endTime: '11:00 AM', room: 'Hall 204', syllabus: 'Lexical Analysis, DFA minimization, LL(1), SLR(1), LALR(1), Intermediate Code Generation', maxMarks: 50),
    Exam(id: 'exam-3', userId: 'user-demo-1', subjectName: 'Mobile Application Lab Exam', type: 'LAB', date: DateTime.now().add(const Duration(days: 15)), startTime: '01:30 PM', endTime: '04:30 PM', room: 'Mobile Lab', syllabus: 'State Management, REST Integration, SQLite caching, Animations, Custom Painters', maxMarks: 100),
    Exam(id: 'exam-4', userId: 'user-demo-1', subjectName: 'Cloud Computing & DevOps', type: 'SEMESTER', date: DateTime.now().add(const Duration(days: 28)), startTime: '09:30 AM', endTime: '12:30 PM', room: 'Main Examination Center', syllabus: 'Full University Syllabus (Units 1 to 5)', maxMarks: 100),
  ];

  static List<Note> notes = [
    Note(id: 'note-1', userId: 'user-demo-1', title: 'Transformer Self-Attention Formulation', content: 'Attention(Q, K, V) = softmax(Q * K^T / sqrt(d_k)) * V.\n\nMulti-Head Attention projects Q, K, V into h distinct subspaces to capture syntactic & semantic relations simultaneously.', tags: 'ML,DeepLearning,Formula', isPinned: true, color: '#4F46E5', updatedAt: DateTime.now()),
    Note(id: 'note-2', userId: 'user-demo-1', title: 'CAP Theorem & Distributed Databases', content: 'Consistency, Availability, Partition Tolerance — distributed datastores can guarantee at most 2 out of 3 under network partitions.\n- CP: MongoDB, HBase\n- AP: Cassandra, DynamoDB', tags: 'Cloud,DevOps,SystemDesign', isPinned: true, color: '#06B6D4', updatedAt: DateTime.now()),
    Note(id: 'note-3', userId: 'user-demo-1', title: 'Flutter Performance & Widget Rebuild Tips', content: '1. Use const constructors wherever possible.\n2. Isolate rebuild scope using Consumer / Selector.\n3. Cache Expensive CustomPainters with RepaintBoundary.', tags: 'Flutter,Dart,Mobile', isPinned: false, color: '#10B981', updatedAt: DateTime.now()),
    Note(id: 'note-4', userId: 'user-demo-1', title: 'Compiler Intermediate Code: 3-Address Code', content: 'Quadruples (op, arg1, arg2, result) vs Triples (op, arg1, arg2).\nSSA (Static Single Assignment) simplifies dead code elimination and constant propagation.', tags: 'Compilers,Theory', isPinned: false, color: '#F59E0B', updatedAt: DateTime.now()),
  ];

  static List<Task> tasks = [
    Task(id: 'task-1', userId: 'user-demo-1', title: 'Solve LeetCode Daily Challenge (Graph BFS/DFS)', category: 'CAREER', priority: 'HIGH', isCompleted: false, dueDate: DateTime.now(), createdAt: DateTime.now()),
    Task(id: 'task-2', userId: 'user-demo-1', title: 'Submit Machine Learning Project Milestone 2', category: 'ACADEMIC', priority: 'HIGH', isCompleted: false, dueDate: DateTime.now(), createdAt: DateTime.now()),
    Task(id: 'task-3', userId: 'user-demo-1', title: 'Review Smart India Hackathon Problem Statements', category: 'PROJECT', priority: 'MEDIUM', isCompleted: false, dueDate: DateTime.now().add(const Duration(days: 2)), createdAt: DateTime.now()),
    Task(id: 'task-4', userId: 'user-demo-1', title: 'Update LinkedIn & GitHub profiles with ATTENT-IN', category: 'CAREER', priority: 'MEDIUM', isCompleted: true, completedAt: DateTime.now(), dueDate: DateTime.now(), createdAt: DateTime.now().subtract(const Duration(days: 1))),
    Task(id: 'task-5', userId: 'user-demo-1', title: 'Complete AWS Cloud Practitioner Practice Exam', category: 'PERSONAL', priority: 'LOW', isCompleted: false, dueDate: DateTime.now().add(const Duration(days: 5)), createdAt: DateTime.now()),
  ];

  static List<CalendarEventModel> calendarEvents = [
    CalendarEventModel(id: 'cal-1', userId: 'user-demo-1', title: 'Machine Learning Class Lecture', startTime: DateTime.now().copyWith(hour: 9, minute: 0), endTime: DateTime.now().copyWith(hour: 10, minute: 0), location: 'Room 301', category: 'CLASS'),
    CalendarEventModel(id: 'cal-2', userId: 'user-demo-1', title: 'Cloud Computing Lab', startTime: DateTime.now().copyWith(hour: 10, minute: 15), endTime: DateTime.now().copyWith(hour: 11, minute: 15), location: 'Lab 2', category: 'CLASS'),
    CalendarEventModel(id: 'cal-3', userId: 'user-demo-1', title: 'CNN Assignment Due', startTime: DateTime.now().add(const Duration(days: 2)), endTime: DateTime.now().add(const Duration(days: 2, hours: 2)), category: 'ASSIGNMENT'),
    CalendarEventModel(id: 'cal-4', userId: 'user-demo-1', title: 'ML Mid-Term Internal Exam', startTime: DateTime.now().add(const Duration(days: 3)), endTime: DateTime.now().add(const Duration(days: 3, hours: 2)), location: 'Hall 201', category: 'EXAM'),
    CalendarEventModel(id: 'cal-5', userId: 'user-demo-1', title: 'HackNIT 2026 Opening Ceremony', startTime: DateTime.now().add(const Duration(days: 6)), endTime: DateTime.now().add(const Duration(days: 6, hours: 3)), location: 'Auditorium', category: 'HACKATHON'),
  ];

  static List<Hackathon> hackathons = [
    Hackathon(id: 'hack-1', name: 'Smart India Hackathon 2026', organizer: 'Ministry of Education & AICTE', date: 'Sept 15 - 17, 2026', mode: 'Hybrid', prize: '₹1,00,000 / team', deadline: DateTime.now().add(const Duration(days: 25)), skills: 'AI, Web, Mobile, IoT, Cloud', category: 'AI', description: 'National level hackathon solving real-world government and institutional challenges.', websiteUrl: 'https://sih.gov.in'),
    Hackathon(id: 'hack-2', name: 'Global AI Agentic Buildathon', organizer: 'DeepMind & Google Cloud', date: 'Oct 02 - 04, 2026', mode: 'Online', prize: '\$50,000 Total Pool', deadline: DateTime.now().add(const Duration(days: 40)), skills: 'Gemini, Python, Dart, LangChain', category: 'AI', description: 'Build autonomous coding assistants and personalized AI copilot tools.', websiteUrl: 'https://buildathon.dev'),
    Hackathon(id: 'hack-3', name: 'HackNIT Calicut 8.0', organizer: 'NITC Computer Science Club', date: 'Oct 20 - 22, 2026', mode: 'On-site', prize: '₹2,50,000', deadline: DateTime.now().add(const Duration(days: 60)), skills: 'Full-Stack, Blockchain, Web3', category: 'Web', description: 'South India premier student-run 36-hour hackathon.', websiteUrl: 'https://hacknitc.com'),
    Hackathon(id: 'hack-4', name: 'Flutter Forward World Hackathon', organizer: 'Flutter Community', date: 'Nov 12 - 14, 2026', mode: 'Online', prize: '\$20,000', deadline: DateTime.now().add(const Duration(days: 80)), skills: 'Flutter, Dart, Firebase, WASM', category: 'Mobile', description: 'Showcase cross-platform UI design and desktop/mobile applications.', websiteUrl: 'https://flutter.dev'),
  ];

  static List<Internship> internships = [
    Internship(id: 'int-1', role: 'Software Engineering Intern', company: 'Google', location: 'Bangalore / Hyderabad', mode: 'Hybrid', stipend: '₹1,20,000 / mo', duration: '6 Months (Jan - June)', deadline: DateTime.now().add(const Duration(days: 30)), skills: 'Data Structures, Algorithms, C++, Java, Python', description: 'Work alongside production teams building cloud services and planetary scale infrastructure.', applyUrl: 'https://careers.google.com'),
    Internship(id: 'int-2', role: 'Flutter Mobile Developer Intern', company: 'Linear / RemoteHQ', location: 'Remote', mode: 'Remote', stipend: '\$2,500 / mo', duration: '3 Months', deadline: DateTime.now().add(const Duration(days: 45)), skills: 'Flutter, Dart, State Management, GraphQL', description: 'Architect high performance mobile client interfaces with smooth 60fps animations.', applyUrl: 'https://linear.app/careers'),
    Internship(id: 'int-3', role: 'Machine Learning Research Intern', company: 'Microsoft Research', location: 'Bangalore', mode: 'Hybrid', stipend: '₹1,00,000 / mo', duration: '4 Months', deadline: DateTime.now().add(const Duration(days: 20)), skills: 'PyTorch, Transformers, LLMs, Mathematics', description: 'Contribute to foundational research in multimodality and small language models.', applyUrl: 'https://microsoft.com/research'),
    Internship(id: 'int-4', role: 'Full Stack Engineer Intern', company: 'Razorpay', location: 'Bangalore', mode: 'On-site', stipend: '₹60,000 / mo', duration: '6 Months', deadline: DateTime.now().add(const Duration(days: 15)), skills: 'Node.js, TypeScript, Go, React, PostgreSQL', description: 'Scale high-throughput payment gateways and developer APIs.', applyUrl: 'https://razorpay.com/jobs'),
  ];

  static List<Job> jobs = [
    Job(id: 'job-1', position: 'Associate Software Engineer', company: 'Goldman Sachs', location: 'Bangalore', salary: '₹24 - 28 LPA', experience: 'Freshers (2026 Batch)', deadline: DateTime.now().add(const Duration(days: 30)), skills: 'Java, Python, C++, Distributed Systems', description: 'Engineer ultra-low-latency financial platforms and global trading systems.', applyUrl: 'https://goldmansachs.com/careers'),
    Job(id: 'job-2', position: 'Software Engineer - Mobile', company: 'Uber', location: 'Hyderabad', salary: '₹32 - 38 LPA', experience: '0-1 Years', deadline: DateTime.now().add(const Duration(days: 40)), skills: 'Flutter, Kotlin, Swift, Architecture', description: 'Build rider and driver experiences consumed by millions globally.', applyUrl: 'https://uber.com/careers'),
    Job(id: 'job-3', position: 'Backend Platform Engineer', company: 'Atlassian', location: 'Remote / Bangalore', salary: '₹30 - 35 LPA', experience: 'Freshers', deadline: DateTime.now().add(const Duration(days: 25)), skills: 'Java, Kotlin, Microservices, AWS, Docker', description: 'Power team collaboration tools including Jira, Confluence, and Loom.', applyUrl: 'https://atlassian.com/careers'),
  ];

  static List<Course> courses = [
    Course(id: 'crs-1', name: 'Machine Learning Specialization', provider: 'DeepLearning.AI & Andrew Ng', level: 'Intermediate', duration: '12 Weeks', rating: 4.9, skills: 'Supervised Learning, Neural Networks, PyTorch', description: 'Master foundational modern machine learning concepts and mathematical principles.', url: 'https://coursera.org'),
    Course(id: 'crs-2', name: 'Flutter & Dart - The Complete Guide', provider: 'Academind', level: 'Beginner to Advanced', duration: '45 Hours', rating: 4.8, skills: 'Flutter, Dart, Animations, State Management', description: 'Build real-world iOS, Android, and Web apps from scratch.', url: 'https://udemy.com'),
    Course(id: 'crs-3', name: 'System Design Interview Bootcamp', provider: 'ByteByteGo (Alex Xu)', level: 'Advanced', duration: '8 Weeks', rating: 4.9, skills: 'Distributed Caching, Load Balancers, Sharding', description: 'Comprehensive roadmap for cracking FAANG/Tier-1 software architecture rounds.', url: 'https://bytebytego.com'),
  ];

  static List<Skill> skills = [
    Skill(id: 'sk-1', userId: 'user-demo-1', name: 'Python & PyTorch', proficiency: 90, category: 'TECHNICAL'),
    Skill(id: 'sk-2', userId: 'user-demo-1', name: 'Flutter & Dart', proficiency: 85, category: 'TECHNICAL'),
    Skill(id: 'sk-3', userId: 'user-demo-1', name: 'Data Structures & Algorithms', proficiency: 88, category: 'TECHNICAL'),
    Skill(id: 'sk-4', userId: 'user-demo-1', name: 'Node.js & Express API', proficiency: 80, category: 'TECHNICAL'),
    Skill(id: 'sk-5', userId: 'user-demo-1', name: 'PostgreSQL & SQLite', proficiency: 82, category: 'TECHNICAL'),
    Skill(id: 'sk-6', userId: 'user-demo-1', name: 'Docker & Kubernetes', proficiency: 72, category: 'TOOL'),
    Skill(id: 'sk-7', userId: 'user-demo-1', name: 'System Design & Architecture', proficiency: 75, category: 'TECHNICAL'),
    Skill(id: 'sk-8', userId: 'user-demo-1', name: 'Technical Communication', proficiency: 92, category: 'SOFT'),
  ];

  static Resume resume = Resume(
    id: 'res-demo-1',
    userId: 'user-demo-1',
    title: 'Aarav Sharma - Software & ML Engineer',
    objective: 'Final-year Computer Science undergraduate passionate about high-performance mobile systems, distributed backend infrastructure, and Applied Machine Learning. Seeking full-time software engineering roles.',
    education: [
      ResumeEducation(degree: 'B.Tech in Computer Science and Engineering', institution: 'National Institute of Technology', year: '2022 - 2026', gpa: '8.7 / 10.0'),
      ResumeEducation(degree: 'Higher Secondary School Certificate (Class XII)', institution: 'Delhi Public School', year: '2020 - 2022', gpa: '96.4%'),
    ],
    experience: [
      ResumeExperience(role: 'Mobile Engineering Intern', company: 'FinTech Labs', duration: 'Summer 2025 (3 Mos)', description: 'Engineered modular Flutter dashboard with offline SQLite caching, cutting API latency by 45%.'),
      ResumeExperience(role: 'Undergraduate ML Research Assistant', company: 'College AI Research Lab', duration: '2024 - 2025', description: 'Fine-tuned Transformer models on domain-specific datasets with PyTorch.'),
    ],
    projects: [
      ResumeProject(title: 'ATTENT-IN', tech: 'Flutter, Dart, Material 3, SQLite', description: 'All-in-one college student platform with attendance calculators, timetable, assignment managers, and AI study copilot.'),
      ResumeProject(title: 'Distributed File Cluster', tech: 'Go, Raft Consensus, gRPC, Docker', description: 'Fault-tolerant distributed key-value store with leader election and log replication.'),
    ],
    skills: 'Languages: Dart, Python, C++, Java, JavaScript, SQL\nFrameworks: Flutter, Node.js, Express, PyTorch, FastAPI\nTools & Cloud: Git, Docker, Kubernetes, AWS, Linux',
    certifications: [
      'AWS Certified Cloud Practitioner (2025)',
      'DeepLearning.AI Machine Learning Specialization (2024)',
    ],
    achievements: [
      'Winner, National Smart India Hackathon (₹1,00,000 Grand Prize)',
      'LeetCode Top 5% Rating (Knight Tier - 1980+ Rating)',
    ],
    languages: 'English (Fluent), Hindi (Native)',
  );

  static List<Interview> interviews = [
    Interview(
      id: 'intv-1',
      userId: 'user-demo-1',
      role: 'Flutter Developer',
      difficulty: 'Medium',
      type: 'Technical',
      score: 88,
      strengths: 'Clear articulation of the Widget tree lifecycle, state management trade-offs, and micro-optimization strategies.',
      weaknesses: 'Consider explaining Isolates and Compute functions in deeper detail for CPU-intensive background parsing.',
      suggestions: 'Review dart:ffi and custom platform channels for native hardware interop.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      questions: [
        InterviewQuestion(id: 'q-1', interviewId: 'intv-1', question: 'Explain the difference between StatefulWidget lifecycle methods initState, didUpdateWidget, and dispose.', userAnswer: 'initState runs once when the widget is inserted into the tree. didUpdateWidget is called when the parent rebuilds with new configurations. dispose cleans up controllers and streams before destruction.', score: 90, feedback: 'Accurate and comprehensive response.'),
        InterviewQuestion(id: 'q-2', interviewId: 'intv-1', question: 'How do you optimize list rendering in Flutter for 10,000+ items?', userAnswer: 'Use ListView.builder for on-demand lazy instantiation, specify itemExtent for fixed heights, and avoid heavy computation inside the builder closure.', score: 86, feedback: 'Solid grasp of virtualization principles.'),
      ],
    ),
  ];

  static List<AppNotification> notifications = [
    AppNotification(id: 'notif-1', userId: 'user-demo-1', title: 'Attendance Alert: Compiler Design', message: 'Your attendance in Compiler Design is 69.2% (Below 75%). Attend the next 3 consecutive classes to restore eligibility.', type: 'ATTENDANCE', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    AppNotification(id: 'notif-2', userId: 'user-demo-1', title: 'Upcoming Deadline: CNN Assignment', message: 'Machine Learning assignment submission is due in 48 hours.', type: 'ASSIGNMENT', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    AppNotification(id: 'notif-3', userId: 'user-demo-1', title: 'Internal Exam Countdown', message: 'Machine Learning Internal Exam scheduled in 3 days (Room 201).', type: 'EXAM', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 1))),
    AppNotification(id: 'notif-4', userId: 'user-demo-1', title: 'New Opportunity: Google SWE Internship', message: 'Applications opened for 2026 Batch Software Engineering Internships.', type: 'CAREER', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 2))),
  ];

  static StudyPlan studyPlan = StudyPlan(
    id: 'sp-1',
    userId: 'user-demo-1',
    title: 'Finals Acceleration Strategy',
    targetDate: DateTime.now().add(const Duration(days: 30)),
    availableHoursDaily: 3.5,
    weakSubjects: 'Compiler Design, Information Security',
    preferredTime: 'EVENING',
    sessions: [
      StudySession(id: 'sess-1', studyPlanId: 'sp-1', subject: 'Compiler Design', durationMinutes: 60, date: DateTime.now(), isCompleted: true, notes: 'Revise LR(1) parsing tables & shift-reduce conflict resolution'),
      StudySession(id: 'sess-2', studyPlanId: 'sp-1', subject: 'Machine Learning', durationMinutes: 60, date: DateTime.now(), isCompleted: false, notes: 'Practice Backpropagation derivations and CNN kernel math'),
      StudySession(id: 'sess-3', studyPlanId: 'sp-1', subject: 'Information Security', durationMinutes: 45, date: DateTime.now().add(const Duration(days: 1)), isCompleted: false, notes: 'AES S-box substitutions and Diffie-Hellman discrete log attacks'),
      StudySession(id: 'sess-4', studyPlanId: 'sp-1', subject: 'Cloud Computing', durationMinutes: 45, date: DateTime.now().add(const Duration(days: 1)), isCompleted: false, notes: 'Kubernetes ingress controller architectures & service meshes'),
    ],
  );

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }
}
