import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


//bu kodlamalar local veritabanimiza(sqlite) erisim saglar.
//local db kullanmazsak bağlantıyı kuran bir backend diline ihtiyaç olacak ama yine de bloc pattern kullanılabilir.
//şu an db app'in içinde yer alıyor.

class VeritabaniYardimcisi{

  //erisecegimiz veritabanin adi
  static final String veritabaniAdi = "mylibrary.sqlite";

  //amacımız bu fonku kullanmak
  static Future<Database> veritabaniErisim() async{

    String veritabaniYolu = join(await getDatabasesPath(),veritabaniAdi);


    if(await databaseExists(veritabaniYolu)){
      print("Veritabanı Durum : Veritabanı var, kopyalamaya gerek yok.");


    }else{
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes,flush: true);
      print("Veritabanı Durum : Veritabanı yok, kopyalandı.");
    }

    return openDatabase(veritabaniYolu);
  }

}