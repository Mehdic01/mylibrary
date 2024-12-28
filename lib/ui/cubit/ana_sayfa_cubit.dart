import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/data/entity/kitaplar.dart';
import 'package:mylibrary/data/repo/kitaplar_repository.dart';


class AnasayfaCubit extends Cubit<List<Kitaplar>>{
  AnasayfaCubit():super(<Kitaplar>[]);

  var krepo = KitaplarRepository();



  Future<void> kitaplariYukle() async{
    var liste = await krepo.kitaplariYukle();
    emit(liste); //emit ile bu kitaplar listesini anasayfaya gonderiyoruz.
  }

  Future<void> ara(String aramaKelimesi) async{
    var liste = await krepo.ara(aramaKelimesi);
    emit(liste);
  }
  Future<void> kitapSil(int id) async {
    await krepo.kitapSil(id);
  }
}