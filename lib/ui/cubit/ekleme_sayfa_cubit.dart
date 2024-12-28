import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/data/repo/kitaplar_repository.dart';

class EklemeSayfaCubit extends Cubit<bool> { // İşlem başarılı mı diye bool state döndürülebilir.
  EklemeSayfaCubit() : super(false);

  var krepo = KitaplarRepository();

  Future<void> ekle(
      String name,
      String author,
      String type,
      String status,
      String note,
      int isFavorite,
      String imagePath,
      String addedDate) async {
    try {
      await krepo.ekle(name, author, type, status, note, isFavorite, imagePath, addedDate);
      emit(true); // İşlem başarılı
    } catch (e) {
      print("Hata: $e");
      emit(false); // İşlem başarısız
    }
  }
}
