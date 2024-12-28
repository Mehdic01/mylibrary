class Kitaplar {
  int id;
  String name;
  String author;
  String type;
  String status;
  String note;
  int isFavorite;
  String imagePath;
  String addedDate;

  Kitaplar({
    required this.id,
    required this.name,
    required this.author,
    required this.type,
    required this.status,
    required this.note,
    required this.isFavorite,
    required this.imagePath,
    required this.addedDate
  });
}