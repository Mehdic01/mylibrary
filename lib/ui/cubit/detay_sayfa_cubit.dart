import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/data/repo/kitaplar_repository.dart';

class DetaySayfaCubit extends Cubit<void> {
  DetaySayfaCubit() : super(0);

  final KitaplarRepository krepo = KitaplarRepository();

  // Favori durumu güncelle
  Future<void> favoriDurumunuGuncelle(int id, int isFavorite) async {
    await krepo.updateFavoriteStatus(id, isFavorite);
  }

  // Kitabı güncelle
  Future<void> kitapGuncelle(
      int id,
      String name,
      String author,
      String type,
      String status,
      String note,
      ) async {
    await krepo.updateKitap(id, name, author, type, status, note);
  }

  // Kitabı sil
  Future<void> kitapSil(int id) async {
    await krepo.kitapSil(id);
  }

  Future<void> whatsappPaylas(String kitapAdi, String yazar, String tur) async {
    await krepo.whatsappPaylas(kitapAdi, yazar, tur);
  }
}
