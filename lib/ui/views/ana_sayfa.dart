import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/data/entity/kitaplar.dart';
import 'package:mylibrary/ui/cubit/ana_sayfa_cubit.dart';
import 'package:mylibrary/ui/cubit/detay_sayfa_cubit.dart';
import 'package:mylibrary/ui/views/ekleme_sayfa.dart';
import 'detay_sayfa.dart';
import 'package:google_fonts/google_fonts.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().kitaplariYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "KİTAPLAR",
          style: GoogleFonts.rubik(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.white,
          ),
        ),
        //backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                placeholder: "Ara",
                onChanged: (searchText) {
                  context.read<AnasayfaCubit>().ara(searchText);
                },
              ),
            ),
            BlocBuilder<AnasayfaCubit, List<Kitaplar>>(
              builder: (context, kitaplarListesi) {
                if (kitaplarListesi.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: kitaplarListesi.length,
                      itemBuilder: (context, indeks) {
                        var kitap = kitaplarListesi[indeks];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetaySayfa(kitap: kitap),
                              ),
                            ).then((value) {
                              context.read<AnasayfaCubit>().kitaplariYukle();
                            });
                          },
                          child: Card(
                            color: Colors.grey.shade900,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  // Kitap Resmi
                                  kitap.imagePath.isNotEmpty
                                      ? Image.file(
                                    File(kitap.imagePath),
                                    width: 70,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                      : const Icon(
                                    Icons.book,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),

                                  // Kitap Bilgileri
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kitap.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text("Yazar: ${kitap.author}"),
                                        Text("Tür: ${kitap.type}"),
                                        Text("Okuma Durumu: ${kitap.status}"),
                                      ],
                                    ),
                                  ),

                                  // Favori Butonu
                                  IconButton(
                                    icon: Icon(
                                      kitap.isFavorite == 1
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: kitap.isFavorite == 1
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      // Favori durumu güncelleniyor
                                      int yeniDurum =
                                      kitap.isFavorite == 1 ? 0 : 1;
                                      await context
                                          .read<DetaySayfaCubit>()
                                          .favoriDurumunuGuncelle(
                                          kitap.id, yeniDurum);
                                      context
                                          .read<AnasayfaCubit>()
                                          .kitaplariYukle();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Henüz eklenmiş bir kitap yok.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EklemeSayfa()),
          ).then((value) {
            context.read<AnasayfaCubit>().kitaplariYukle();
          });
        },
        child: const Icon(Icons.add,size: 30,),
      ),
    );
  }
}
