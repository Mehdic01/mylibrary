import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylibrary/ui/cubit/ana_sayfa_cubit.dart';
import 'package:mylibrary/ui/cubit/detay_sayfa_cubit.dart';
import 'package:mylibrary/ui/cubit/ekleme_sayfa_cubit.dart';
import 'package:mylibrary/ui/cubit/favori_sayfa_cubit.dart';
import 'package:mylibrary/ui/cubit/profil_sayfa_cubit.dart';
import 'package:mylibrary/ui/views/bottom_navigation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //kullandığımız cubitleri altta ekliyoruz.
      providers: [
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => DetaySayfaCubit()),
        BlocProvider(create: (context) => EklemeSayfaCubit()),
        BlocProvider(create: (context) => FavorilerCubit()),
        BlocProvider(create: (context) => ProfilSayfaCubit()),

      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.highContrastDark(onPrimary: Colors.white),
          useMaterial3: true,
        ),
        home: const BottomNavigation(),
      ),
    );
  }
}


