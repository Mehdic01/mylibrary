import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/ui/cubit/profil_sayfa_cubit.dart';

class ProfilSayfa extends StatefulWidget {
  const ProfilSayfa({Key? key}) : super(key: key);

  @override
  State<ProfilSayfa> createState() => _ProfilSayfaState();
}

class _ProfilSayfaState extends State<ProfilSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<ProfilSayfaCubit>().istatistikleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROFİL SAYFASI",
          style: GoogleFonts.rubik(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        //centerTitle: true,
        backgroundColor: Colors.grey.shade900,
      ),
      body: BlocBuilder<ProfilSayfaCubit, Map<String, dynamic>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final toplamKitap = state["toplamKitap"];
          final durumlaraGoreKitaplar = state["durumlaraGoreKitaplar"];
          final favoriKitapSayisi = state["favoriKitapSayisi"];
          final turDagilimi = state["turDagilimi"];
          final enCokOkunanTur = state["enCokOkunanTur"];
          final okumaOrani = state["okumaOrani"];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard("Toplam Kitap Sayısı", toplamKitap.toString(), Colors.teal),
                _buildCard("Favori Kitap Sayısı", favoriKitapSayisi.toString(), Colors.pink),
                _buildCard("Toplam Okuma Oranı", "${okumaOrani.toStringAsFixed(0)}%", Colors.blueAccent),
                _buildCard("En Çok Okunan Tür", enCokOkunanTur ?? "Veri Yok", Colors.amber),

                const SizedBox(height: 20),
                const Text("Okuma Durumları", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18,),

                // Okuma Durumları (Bar Chart)
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: _buildBarChartGroups(durumlaraGoreKitaplar),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final labels = durumlaraGoreKitaplar.keys.toList();
                              return Text(
                                labels[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1, // Sadece int değerleri göster
                            getTitlesWidget: (value, meta) {
                              if (value % 1 == 0) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            reservedSize: 25, // Sol taraftaki genişlik düzenlemesi
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        //horizontalInterval: 3, // Yatay çizgi aralığı sadece int değerler
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),



                const SizedBox(height: 30),
                const Text("Tür Dağılımı", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                // Tür Dağılımı (Pie Chart)
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _buildPieChartSections(turDagilimi),
                      centerSpaceRadius: 38,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bilgiler için Card Widget
  Widget _buildCard(String title, String value, Color color) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  // Bar Chart Grupları Oluştur
  List<BarChartGroupData> _buildBarChartGroups(Map<String, int> durumlar) {
    final colors = [Colors.green, Colors.orange, Colors.blue, Colors.purple];
    int index = 0;

    return durumlar.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: colors[index % colors.length],
            width: 17,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    }).toList();
  }

  // Pie Chart Bölümlerini Oluştur
  List<PieChartSectionData> _buildPieChartSections(Map<String, int> turDagilimi) {
    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent
    ];
    int index = 0;

    return turDagilimi.entries.map((entry) {
      return PieChartSectionData(
        color: colors[index++ % colors.length],
        value: entry.value.toDouble(),
        title: "${entry.key}\n${entry.value}",
        radius: 70,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
}
