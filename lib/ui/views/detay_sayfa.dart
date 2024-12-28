import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mylibrary/data/entity/kitaplar.dart';
import 'package:mylibrary/ui/cubit/detay_sayfa_cubit.dart';

class DetaySayfa extends StatefulWidget {
  final Kitaplar kitap;

  const DetaySayfa({Key? key, required this.kitap}) : super(key: key);

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  late bool isFavorite;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late String _selectedType;
  late String _selectedStatus;

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
    "Tarih",
  ];

  final List<String> statuses = ["Okunuyor", "Okunmuş", "Okunacak"];

  @override
  void initState() {
    super.initState();
    isFavorite = widget.kitap.isFavorite == 1;
    _nameController.text = widget.kitap.name;
    _authorController.text = widget.kitap.author;
    _noteController.text = widget.kitap.note;
    _selectedType = widget.kitap.type;
    _selectedStatus = widget.kitap.status;
  }

  String formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat('d MMMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return rawDate;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Kitabı Sil"),
          content: const Text("Silmek istediğinizden emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                await context.read<DetaySayfaCubit>().kitapSil(widget.kitap.id);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Evet, Sil"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kitap.name,
          style: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),),
        backgroundColor: Colors.grey.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 30),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kitap Resmi
              Center(
                child: widget.kitap.imagePath.isNotEmpty
                    ? Image.file(
                  File(widget.kitap.imagePath),
                  width: 130,
                  height: 200,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.book, size: 150, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Kitap Bilgileri Düzenleme Alanı
              _buildEditableField("Kitap Adı", _nameController),
              _buildEditableField("Yazar", _authorController),

              // Tür Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: "Tür",
                    border: OutlineInputBorder(),
                  ),
                  items: types
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
              ),

              // Okuma Durumu Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: "Okuma Durumu",
                    border: OutlineInputBorder(),
                  ),
                  items: statuses
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
              ),

              _buildEditableField("Not", _noteController),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900)),
                  onPressed: () async {
                    await context.read<DetaySayfaCubit>().kitapGuncelle(
                      widget.kitap.id,
                      _nameController.text,
                      _authorController.text,
                      _selectedType,
                      _selectedStatus,
                      _noteController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Kaydet",
                    style: GoogleFonts.rubik(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),),
                ),
              ),

              const SizedBox(height: 20),

              // Favorilere Ekle/Çıkar Butonu
              Center(
                child: ElevatedButton.icon(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900)),
                  onPressed: () async {
                    setState(() {
                      isFavorite = !isFavorite;
                      widget.kitap.isFavorite = isFavorite ? 1 : 0;
                    });
                    await context
                        .read<DetaySayfaCubit>()
                        .favoriDurumunuGuncelle(widget.kitap.id, widget.kitap.isFavorite);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  label: Text(isFavorite ? "Favorilerden Çıkar" : "Favorilere Ekle",
                    style: GoogleFonts.rubik(fontSize: 14,color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // WhatsApp Paylaş Butonu
              Center(
                child: ElevatedButton.icon(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade900)),
                  onPressed: () async {
                    await context.read<DetaySayfaCubit>().whatsappPaylas(
                      widget.kitap.name,
                      widget.kitap.author,
                      widget.kitap.type,
                    );
                  },
                  icon: Image.asset("assets/images/whatsapp-removebg-preview.png",width: 40,height: 40,),
                  label: Text("WhatsApp ile Paylaş",
                    style: GoogleFonts.rubik(fontSize: 15,color: Colors.white),),
                ),
              ),

              const SizedBox(height: 20),

              // Eklenme Tarihi
              Center(
                child: Text(
                  "Eklenme Tarihi: ${formatDate(widget.kitap.addedDate)}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
