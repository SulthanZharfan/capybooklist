class Book {
  int? id;
  String title;
  String? author;
  String filePath;
  int? fileSize;
  String? fileType;
  String? addedAt;
  String? lastOpenedAt;
  String? description;

  Book({
    this.id,
    required this.title,
    required this.filePath,
    this.author,
    this.fileSize,
    this.fileType,
    this.addedAt,
    this.lastOpenedAt,
    this.description,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      filePath: map['file_path'],
      author: map['author'],
      fileSize: map['file_size'],
      fileType: map['file_type'],
      addedAt: map['added_at'],
      lastOpenedAt: map['last_opened_at'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'file_path': filePath,
      'author': author,
      'file_size': fileSize,
      'file_type': fileType,
      'added_at': addedAt,
      'last_opened_at': lastOpenedAt,
      'description': description,
    };
  }
}
