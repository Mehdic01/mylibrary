import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/data/repo/kitaplar_repository.dart';

class ProfilSayfaCubit extends Cubit<Map<String, dynamic>> {
  ProfilSayfaCubit() : super({});

  final KitaplarRepository krepo = KitaplarRepository();

  // Profil istatistiklerini yükle
  Future<void> istatistikleriYukle() async {
    var toplamKitap = await krepo.toplamKitapSayisi();
    var durumlaraGoreKitaplar = await krepo.okumaDurumunaGoreKitapSayilari();
    var favoriKitapSayisi = await krepo.favoriKitapSayisi();
    var turDagilimi = await krepo.turDagilimi();
    var enCokOkunanTur = await krepo.enCokOkunanTur();
    var okumaOrani = await krepo.kitapOkumaOrani();

    emit({
      "toplamKitap": toplamKitap,
      "durumlaraGoreKitaplar": durumlaraGoreKitaplar,
      "favoriKitapSayisi": favoriKitapSayisi,
      "turDagilimi": turDagilimi,
      "enCokOkunanTur": enCokOkunanTur,
      "okumaOrani": okumaOrani,
    });
  }
}
