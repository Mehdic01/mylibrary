import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/data/entity/kitaplar.dart';
import 'package:mylibrary/ui/views/detay_sayfa.dart';
import '../cubit/favori_sayfa_cubit.dart';

class FavoriSayfa extends StatefulWidget {
  const FavoriSayfa({Key? key}) : super(key: key);

  @override
  State<FavoriSayfa> createState() => _FavoriSayfaState();
}

class _FavoriSayfaState extends State<FavoriSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<FavorilerCubit>().favorileriYukle(); // Favorileri yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAVORİ KİTAPLAR",
          style: GoogleFonts.rubik(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: BlocBuilder<FavorilerCubit, List<Kitaplar>>(
          builder: (context, favoriListesi) {
            if (favoriListesi.isEmpty) {
              return const Center(
                child: Text(
                  "Henüz favorilere eklenmiş bir kitap yok.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: favoriListesi.length,
              itemBuilder: (context, indeks) {
                var kitap = favoriListesi[indeks];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfa(kitap: kitap),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey.shade900,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          // Kitap Resmi
                          kitap.imagePath.isNotEmpty
                              ? Image.file(
                            File(kitap.imagePath),
                            width: 80,
                            height: 80,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
