import 'package:flutter/material.dart';
import '../models/library_models.dart';

class LibraryProvider extends ChangeNotifier {
  List<LibraryBook> _allBooks = [];
  List<BorrowedBook> _borrowedBooks = [];
  List<DigitalResource> _digitalResources = [];
  final LibraryFine _fines = LibraryFine(currentFine: 0.0, paidFine: 40.0, pendingFine: 0.0);
  String _searchQuery = '';
  String _selectedCategory = 'ALL';

  LibraryProvider() {
    _initMockData();
  }

  List<LibraryBook> get allBooks => _allBooks;
  List<BorrowedBook> get borrowedBooks => _borrowedBooks;
  List<DigitalResource> get digitalResources => _digitalResources;
  LibraryFine get fines => _fines;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<LibraryBook> get filteredBooks {
    return _allBooks.where((book) {
      final matchesSearch = _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.department.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.isbn.contains(_searchQuery);

      final matchesCategory = _selectedCategory == 'ALL' ||
          book.department.toUpperCase() == _selectedCategory.toUpperCase() ||
          book.category.toUpperCase() == _selectedCategory.toUpperCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<BorrowedBook> get activeBorrowed =>
      _borrowedBooks.where((b) => b.status != BorrowStatus.returned).toList();

  List<BorrowedBook> get dueSoonOrOverdue =>
      _borrowedBooks.where((b) => b.isDueSoon || b.isOverdue).toList();

  void setSearchQuery(String q) {
    _searchQuery = q.trim();
    notifyListeners();
  }

  void setSelectedCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void renewBook(String borrowedId) {
    final idx = _borrowedBooks.indexWhere((b) => b.id == borrowedId);
    if (idx != -1) {
      final current = _borrowedBooks[idx];
      _borrowedBooks[idx] = BorrowedBook(
        id: current.id,
        bookId: current.bookId,
        bookTitle: current.bookTitle,
        author: current.author,
        borrowedDate: current.borrowedDate,
        dueDate: current.dueDate.add(const Duration(days: 14)),
        status: BorrowStatus.borrowed,
      );
      notifyListeners();
    }
  }

  void borrowBook(LibraryBook book) {
    if (book.availableCopies <= 0) return;

    final newBorrow = BorrowedBook(
      id: 'bor-${DateTime.now().millisecondsSinceEpoch}',
      bookId: book.id,
      bookTitle: book.title,
      author: book.author,
      borrowedDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: BorrowStatus.borrowed,
    );

    _borrowedBooks.insert(0, newBorrow);
    notifyListeners();
  }

  void _initMockData() {
    _borrowedBooks = [
      BorrowedBook(
        id: 'bor-1',
        bookId: 'bk-1',
        bookTitle: 'Deep Learning with Python',
        author: 'François Chollet',
        borrowedDate: DateTime.now().subtract(const Duration(days: 9)),
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: BorrowStatus.dueSoon,
      ),
      BorrowedBook(
        id: 'bor-2',
        bookId: 'bk-3',
        bookTitle: 'Computer Networking: A Top-Down Approach',
        author: 'Jim Kurose & Keith Ross',
        borrowedDate: DateTime.now().subtract(const Duration(days: 4)),
        dueDate: DateTime.now().add(const Duration(days: 10)),
        status: BorrowStatus.borrowed,
      ),
    ];

    _allBooks = [
      LibraryBook(
        id: 'bk-1',
        title: 'Deep Learning with Python (2nd Edition)',
        author: 'François Chollet',
        isbn: '978-1617296864',
        subject: 'Machine Learning',
        department: 'CSE',
        category: 'Core AI',
        isAvailable: true,
        totalCopies: 4,
        availableCopies: 1,
        rating: 4.9,
        shelfLocation: 'Stack 3, Bay B (AI/ML)',
        description: 'Comprehensive guide to deep learning using Keras and TensorFlow by the creator of Keras.',
      ),
      LibraryBook(
        id: 'bk-2',
        title: 'Compilers: Principles, Techniques, & Tools (Dragon Book)',
        author: 'Alfred V. Aho, Monica S. Lam, Ravi Sethi, Jeffrey D. Ullman',
        isbn: '978-0321486813',
        subject: 'Compiler Design',
        department: 'CSE',
        category: 'Systems',
        isAvailable: true,
        totalCopies: 6,
        availableCopies: 3,
        rating: 4.8,
        shelfLocation: 'Stack 1, Bay A (Theory)',
        description: 'The definitive classic textbook on compiler design, lexing, parsing, and code generation.',
      ),
      LibraryBook(
        id: 'bk-3',
        title: 'Computer Networking: A Top-Down Approach',
        author: 'Jim Kurose & Keith Ross',
        isbn: '978-0136681557',
        subject: 'Computer Networks',
        department: 'CSE',
        category: 'Networks',
        isAvailable: true,
        totalCopies: 5,
        availableCopies: 2,
        rating: 4.9,
        shelfLocation: 'Stack 4, Bay C (Networks)',
        description: 'Top-down approach to Internet protocols, transport layer TCP/UDP, routing, and DNS.',
      ),
      LibraryBook(
        id: 'bk-4',
        title: 'Introduction to Algorithms (CLRS 4th Edition)',
        author: 'Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein',
        isbn: '978-0262046305',
        subject: 'Algorithms & Data Structures',
        department: 'CSE',
        category: 'Core Algorithms',
        isAvailable: true,
        totalCopies: 8,
        availableCopies: 4,
        rating: 5.0,
        shelfLocation: 'Stack 2, Bay A (Algorithms)',
        description: 'The gold standard reference textbook for algorithmic complexity, dynamic programming, and graph theory.',
      ),
      LibraryBook(
        id: 'bk-5',
        title: 'Designing Data-Intensive Applications',
        author: 'Martin Kleppmann',
        isbn: '978-1449373320',
        subject: 'Distributed Systems & Database Engineering',
        department: 'IT',
        category: 'Architecture',
        isAvailable: true,
        totalCopies: 3,
        availableCopies: 2,
        rating: 5.0,
        shelfLocation: 'Stack 5, Bay D (Cloud & Distributed)',
        description: 'A deep dive into consistency models, replication, partitioning, stream processing, and distributed consensus.',
      ),
      LibraryBook(
        id: 'bk-6',
        title: 'Computer Vision: Algorithms and Applications',
        author: 'Richard Szeliski',
        isbn: '978-3030343712',
        subject: 'Computer Vision & Image Processing',
        department: 'AIML',
        category: 'Vision AI',
        isAvailable: true,
        totalCopies: 3,
        availableCopies: 1,
        rating: 4.7,
        shelfLocation: 'Stack 3, Bay B (Vision)',
        description: 'State of the art textbook covering camera calibration, epipolar geometry, optical flow, and CNN vision models.',
      ),
    ];

    _digitalResources = [
      DigitalResource(
        id: 'dr-1',
        title: 'Attention Is All You Need — Transformer Architecture (Vaswani et al.)',
        resourceType: 'RESEARCH_PAPER',
        subject: 'Machine Learning',
        fileSize: '1.8 MB',
        authorOrPublisher: 'NeurIPS Proceedings',
        year: '2024 (Annotated)',
      ),
      DigitalResource(
        id: 'dr-2',
        title: 'Compiler Construction Complete Handout (Unit 1 to 5)',
        resourceType: 'LECTURE_NOTE',
        subject: 'Compiler Design',
        fileSize: '8.4 MB',
        authorOrPublisher: 'Dept. of CSE NIT',
        year: '2026',
      ),
      DigitalResource(
        id: 'dr-3',
        title: 'IEEE Journal on Distributed Ledger Systems & Smart Contracts',
        resourceType: 'JOURNAL',
        subject: 'Blockchain',
        fileSize: '3.2 MB',
        authorOrPublisher: 'IEEE Computer Society',
        year: '2025',
      ),
    ];
  }
}
