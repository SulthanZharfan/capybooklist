class Bookmark {
  int? id;
  int bookId;
  int pageNumber;
  String note;
  DateTime? createdAt;

  Bookmark({
    this.id,
    required this.bookId,
    required this.pageNumber,
    required this.note,
    this.createdAt,
  });

  // ✅ Inilah kunci: map field ke nama kolom DB yg benar!
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,      // pakai snake_case seperti di DB!
      'page_number': pageNumber,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as int?,
      bookId: map['book_id'] as int,
      pageNumber: map['page_number'] as int,
      note: map['note'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }
}
