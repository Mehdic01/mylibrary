import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylibrary/ui/cubit/ekleme_sayfa_cubit.dart';

class EklemeSayfa extends StatefulWidget {
  const EklemeSayfa({super.key});

  @override
  State<EklemeSayfa> createState() => _EklemeSayfaState();
}

class _EklemeSayfaState extends State<EklemeSayfa> {
  var tfKitapName = TextEditingController();
  var tfKitapAuthor = TextEditingController();
  var tfKitapNote = TextEditingController();
  String? selectedType;
  String? selectedStatus;
  File? selectedImage;

  final List<String> types = [
    "Bilim",
    "Biyografi",
    "Çizgi Roman",
    "Edebiyat",
    "Eğitim",
    "Felsefe",
    "Hikaye",
    "Kişisel Gelişim",
    "Mizah",
    "Psikoloji",
    "Roman",
    "Sanat",
    "Şiir",
    "Tarih"
  ];

  final List<String> statuses = ["Okunuyor", "Okunmuş", "Okunacak"];

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen gerekli tüm alanları doldurun!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Ekle",
          style: GoogleFonts.rubik(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),),
        backgroundColor: Colors.grey.shade900,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kitap Adı
              TextField(
                controller: tfKitapName,
                decoration: InputDecoration(
                  labelText: "Kitap Adı",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              // Yazar Adı
              TextField(
                controller: tfKitapAuthor,
                decoration: InputDecoration(
                  labelText: "Yazar Adı",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              // Kitap Türü Dropdown
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: "Kitap Türü",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: types
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Okuma Durumu Dropdown
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: "Okuma Durumu",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: statuses
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Not
              TextField(
                controller: tfKitapNote,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Not",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              // Resim Seçme ve Kamera ile Çekme
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900)),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    child: Text("Resim Seç",
                      style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    child: Icon(Icons.camera_alt,color: Colors.white,),
                  ),
                  const SizedBox(width: 10),
                  selectedImage != null
                      ? Stack(
                    children: [
                      Image.file(
                        selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      )
                    ],
                  )
                      : const Text("Seçilen resim yok!"),
                ],
              ),
              const SizedBox(height: 20),

              // Ekle Butonu
              ElevatedButton(
                onPressed: () {
                  if (tfKitapName.text.isEmpty ||
                      tfKitapAuthor.text.isEmpty ||
                      selectedType == null ||
                      selectedStatus == null) {
                    _showValidationError();
                    return;
                  }

                  final currentDate = DateTime.now().toIso8601String();
                  context.read<EklemeSayfaCubit>().ekle(
                    tfKitapName.text,
                    tfKitapAuthor.text,
                    selectedType!,
                    selectedStatus!,
                    tfKitapNote.text,
                    0, // Favori başlangıçta false (0)
                    selectedImage?.path ?? "", // Resim yolu
                    currentDate, // Şu anki tarih
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Kitap başarıyla eklendi!")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.grey.shade900,
                ),
                child: Text("Kitabı Ekle",
                    style: GoogleFonts.rubik(
                        fontSize: 18,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
