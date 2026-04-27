class Note {
  String title;
  String content;
  dynamic updatedAt;
  final String id;
  Note({
    required this.title,
    required this.content,
    required this.id,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: (map['title'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
      id: (map['id'] ?? '').toString(),
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'content': content, 'updatedAt': updatedAt};
  }
}
