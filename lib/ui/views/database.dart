import 'package:flutter/material.dart';
import 'package:mylibrary/sqlite/veritabani_yardimcisi.dart';

class DatabasePreviewPage extends StatefulWidget {
  const DatabasePreviewPage({Key? key}) : super(key: key);

  @override
  _DatabasePreviewPageState createState() => _DatabasePreviewPageState();
}

class _DatabasePreviewPageState extends State<DatabasePreviewPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var result = await db.rawQuery("SELECT * FROM book");
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veritabanı İçeriği")),
      body: data.isEmpty
          ? const Center(child: Text("Veritabanı boş."))
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var row = data[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("id: ${row["id"] ?? "Bilgi Yok"}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("name: ${row["name"] ?? "Bilgi Yok"}"),
                  Text("author: ${row["author"] ?? "Bilgi Yok"}"),
                  Text("type: ${row["type"] ?? "Bilgi Yok"}"),
                  Text("status: ${row["status"] ?? "Bilgi Yok"}"),
                  Text("note: ${row["note"] ?? "Bilgi Yok"}"),
                  Text("isFavorite: ${row["isFavorite"] == 1 ? "Evet" : "Hayır"}"),
                  Text("imagePath: ${row["imagePath"] ?? "Yok"}"),
                  Text("addedDate: ${row["addedDate"] ?? "Bilgi Yok"}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
