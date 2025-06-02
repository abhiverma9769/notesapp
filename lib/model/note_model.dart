class Note {
  final int? id;
  final String title;
  final String content;
  final String color;
  final String datetime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'datetime': datetime,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      datetime: map['datetime'],
    );
  }
}
