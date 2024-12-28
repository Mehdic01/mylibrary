import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/data/entity/kitaplar.dart';
import 'package:mylibrary/data/repo/kitaplar_repository.dart';

class FavorilerCubit extends Cubit<List<Kitaplar>> {
  FavorilerCubit() : super([]);

  var krepo = KitaplarRepository();

  Future<void> favorileriYukle() async {
    var liste = await krepo.favoriKitaplariGetir(); // Favori kitapları getir
    emit(liste);
  }

  // Favori durumunu güncelle ve listeyi yeniden yükle
  Future<void> favoriDurumunuGuncelle(int id, int isFavorite) async {
    await krepo.updateFavoriteStatus(id, isFavorite); // Veritabanını güncelle
    await favorileriYukle(); // Favori listesini yeniden yükle
  }

}
