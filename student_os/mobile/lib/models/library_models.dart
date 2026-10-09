class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String subject;
  final String department;
  final String category;
  final bool isAvailable;
  final int totalCopies;
  final int availableCopies;
  final String description;
  final double rating;
  final String shelfLocation;
  final String coverGradient; // Hex colors representation

  LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.subject,
    required this.department,
    required this.category,
    required this.isAvailable,
    required this.totalCopies,
    required this.availableCopies,
    required this.description,
    required this.rating,
    required this.shelfLocation,
    this.coverGradient = '0xFF3B82F6,0xFF1D4ED8',
  });

  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    return LibraryBook(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      subject: json['subject'] ?? '',
      department: json['department'] ?? 'CSE',
      category: json['category'] ?? 'Reference',
      isAvailable: json['isAvailable'] ?? true,
      totalCopies: json['totalCopies'] is int ? json['totalCopies'] : 3,
      availableCopies: json['availableCopies'] is int ? json['availableCopies'] : 1,
      description: json['description'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      shelfLocation: json['shelfLocation'] ?? 'Aisle 4, Shelf B',
      coverGradient: json['coverGradient'] ?? '0xFF3B82F6,0xFF1D4ED8',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'subject': subject,
      'department': department,
      'category': category,
      'isAvailable': isAvailable,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
      'description': description,
      'rating': rating,
      'shelfLocation': shelfLocation,
      'coverGradient': coverGradient,
    };
  }
}

enum BorrowStatus {
  borrowed,
  dueSoon,
  overdue,
  returned,
}

extension BorrowStatusExt on BorrowStatus {
  String get displayName {
    switch (this) {
      case BorrowStatus.borrowed:
        return 'Active';
      case BorrowStatus.dueSoon:
        return 'Due Soon';
      case BorrowStatus.overdue:
        return 'Overdue';
      case BorrowStatus.returned:
        return 'Returned';
    }
  }
}

class BorrowedBook {
  final String id;
  final String bookId;
  final String bookTitle;
  final String author;
  final DateTime borrowedDate;
  final DateTime dueDate;
  final BorrowStatus status;
  final double fineAmount;

  BorrowedBook({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.borrowedDate,
    required this.dueDate,
    required this.status,
    this.fineAmount = 0.0,
  });

  int get daysRemaining {
    final diff = dueDate.difference(DateTime.now()).inDays;
    return diff;
  }

  bool get isDueSoon => daysRemaining >= 0 && daysRemaining <= 3;
  bool get isOverdue => daysRemaining < 0;

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      id: json['id'] ?? '',
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      author: json['author'] ?? '',
      borrowedDate: json['borrowedDate'] != null ? DateTime.parse(json['borrowedDate']) : DateTime.now(),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now().add(const Duration(days: 14)),
      status: json['status'] == 'OVERDUE'
          ? BorrowStatus.overdue
          : (json['status'] == 'DUE_SOON' ? BorrowStatus.dueSoon : BorrowStatus.borrowed),
      fineAmount: (json['fineAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'author': author,
      'borrowedDate': borrowedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.displayName,
      'fineAmount': fineAmount,
    };
  }
}

class DigitalResource {
  final String id;
  final String title;
  final String resourceType; // "PDF", "JOURNAL", "RESEARCH_PAPER", "LECTURE_NOTE"
  final String subject;
  final String fileSize;
  final String authorOrPublisher;
  final String year;

  DigitalResource({
    required this.id,
    required this.title,
    required this.resourceType,
    required this.subject,
    required this.fileSize,
    required this.authorOrPublisher,
    required this.year,
  });

  factory DigitalResource.fromJson(Map<String, dynamic> json) {
    return DigitalResource(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      resourceType: json['resourceType'] ?? 'PDF',
      subject: json['subject'] ?? '',
      fileSize: json['fileSize'] ?? '4.2 MB',
      authorOrPublisher: json['authorOrPublisher'] ?? 'Department Faculty',
      year: json['year'] ?? '2026',
    );
  }
}

class LibraryFine {
  final double currentFine;
  final double paidFine;
  final double pendingFine;

  LibraryFine({
    required this.currentFine,
    required this.paidFine,
    required this.pendingFine,
  });
}
