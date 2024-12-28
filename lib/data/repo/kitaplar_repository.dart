import 'package:mylibrary/data/entity/kitaplar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../sqlite/veritabani_yardimcisi.dart';

class KitaplarRepository {


  Future<List<Kitaplar>> kitaplariYukle() async {
    //veritabanına erişmek istediğimzde aşağıdaki kodlamayı yapiyoruz.
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    //veritabanindan kayitlar yani her satir bir map olarak geliyor.
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM book");

    return List.generate(maps.length, (i) {
      var satir = maps[i]; //satırları aldık
      int id = satir["id"];
      String name = satir["name"];
      String author = satir["author"];
      String type = satir["type"];
      String status = satir["status"];
      String note = satir["note"];
      int isFavorite = satir["isFavorite"];
      String imagePath = satir["imagePath"] ?? ""; // Varsayılan boş string.
      String addedDate = satir["addedDate"];


      return Kitaplar(id: id,
          name: name,
          author: author,
          type: type,
          status: status,
          note: note,
          isFavorite: isFavorite,
          imagePath: imagePath,
          addedDate: addedDate);
    });
  }

  Future<bool> ekle(String name,
      String author,
      String type,
      String status,
      String note,
      int isFavorite,
      String imagePath,
      String addedDate) async {
    if (name.isEmpty || author.isEmpty) {
      print("Kitap adı veya yazar adı boş olamaz!");
      return false; // Hatalı giriş
    }

    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var yeniKitap = {
      "name": name,
      "author": author,
      "type": type,
      "status": status,
      "note": note,
      "isFavorite": isFavorite,
      "imagePath": imagePath,
      "addedDate": addedDate,
    };

    await db.insert("book", yeniKitap);
    return true; // İşlem başarılı
  }


  Future<List<Kitaplar>> ara(String aramaKelimesi) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM book WHERE name LIKE '%$aramaKelimesi%'");

    return List.generate(maps.length, (i) {
      var satir = maps[i]; //satırları aldık
      int id = satir["id"];
      String name = satir["name"];
      String author = satir["author"];
      String type = satir["type"];
      String status = satir["status"];
      String note = satir["note"];
      int isFavorite = satir["isFavorite"];
      String imagePath = satir["imagePath"] ?? ""; // Varsayılan boş string.
      String addedDate = satir["addedDate"];

      return Kitaplar(id: id,
          name: name,
          author: author,
          type: type,
          status: status,
          note: note,
          isFavorite: isFavorite,
          imagePath: imagePath,
          addedDate: addedDate);
    });
  }


  // Favorilere eklenmiş kitapları getir
  Future<List<Kitaplar>> favoriKitaplariGetir() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String, dynamic>> maps =
    await db.rawQuery("SELECT * FROM book WHERE isFavorite = 1");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kitaplar(
        id: satir["id"],
        name: satir["name"],
        author: satir["author"],
        type: satir["type"],
        status: satir["status"],
        note: satir["note"],
        isFavorite: satir["isFavorite"],
        imagePath: satir["imagePath"] ?? "",
        addedDate: satir["addedDate"],
      );
    });
  }

  Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawUpdate(
      'UPDATE book SET isFavorite = ? WHERE id = ?',
      [isFavorite, id],
    );
  }

  // Kitabı güncelle
  Future<void> updateKitap(
      int id,
      String name,
      String author,
      String type,
      String status,
      String note,
      ) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawUpdate(
      'UPDATE book SET name = ?, author = ?, type = ?, status = ?, note = ? WHERE id = ?',
      [name, author, type, status, note, id],
    );
  }

  // Kitabı sil
  Future<void> kitapSil(int id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.rawDelete('DELETE FROM book WHERE id = ?', [id]);
  }



  //****************************PROFIL ICIN****************************
  Future<int> toplamKitapSayisi() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var result = await db.rawQuery("SELECT COUNT(*) as toplam FROM book");
    return result.first["toplam"] as int;
  }

  // Okuma durumuna göre kitap sayıları
  Future<Map<String, int>> okumaDurumunaGoreKitapSayilari() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var result = await db.rawQuery("""
      SELECT status, COUNT(*) as toplam 
      FROM book 
      GROUP BY status
    """);
    return {
      for (var row in result) row["status"] as String: row["toplam"] as int,
    };
  }

  // Favorilere eklenen kitap sayısı
  Future<int> favoriKitapSayisi() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var result = await db.rawQuery("SELECT COUNT(*) as toplam FROM book WHERE isFavorite = 1");
    return result.first["toplam"] as int;
  }

  // Türlere göre kitap dağılımı
  Future<Map<String, int>> turDagilimi() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var result = await db.rawQuery("""
      SELECT type, COUNT(*) as toplam 
      FROM book 
      GROUP BY type
    """);
    return {
      for (var row in result) row["type"] as String: row["toplam"] as int,
    };
  }

  // En çok okunan tür
  Future<String> enCokOkunanTur() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var result = await db.rawQuery("""
      SELECT type, COUNT(*) as toplam 
      FROM book 
      WHERE status = 'Okunmuş'
      GROUP BY type 
      ORDER BY toplam DESC 
      LIMIT 1
    """);
    return result.isNotEmpty ? result.first["type"] as String : "Veri Yok";
  }

  // Kitapların okuma oranı
  Future<double> kitapOkumaOrani() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var toplam = await toplamKitapSayisi();
    var okunmus = await db.rawQuery("SELECT COUNT(*) as toplam FROM book WHERE status = 'Okunmuş'");
    int okunmusSayi = okunmus.first["toplam"] as int;
    return toplam > 0 ? (okunmusSayi / toplam) * 100 : 0.0;
  }

  //**************************IMPLICIT INTENT KULLANIMI ICIN************************
  Future<void> whatsappPaylas(String kitapAdi, String yazar, String tur) async {
    String mesaj = "📚 Kitap Önerisi:\n\nKitap Adı: $kitapAdi\nYazar: $yazar\nTür: $tur";
    String whatsappUrl = "https://wa.me/?text=${Uri.encodeComponent(mesaj)}";

    final Uri url = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "WhatsApp'a yönlendirilemedi.";
    }
  }
}
