import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_to_the_throne/bloc/cubits/auth/auth_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/image_picker/image_picker_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/screens/splash.dart';
import 'bloc/cubits/teams/teams_cubit.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (c) => AuthCubit()),
        BlocProvider(create: (c) => ImagePickerCubit()),
        BlocProvider(create: (c) => PlayerCubit()),
        BlocProvider(create: (c) => TeamsCubit()),
        BlocProvider(create: (c) => MatchesCubit()),
        BlocProvider(create: (c) => LeaguesCubit()),
        BlocProvider(create: (c) => SimplePlayersCubit()),
      ],
      child: MaterialApp(
        title: 'RoadToTheThrone',
        theme: ThemeData(
            textTheme: GoogleFonts.offsideTextTheme(),
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme(
                error: Colors.red[300]!,
                background: Colors.white,
                secondary: AppColors.primaryColor,
                onError: Colors.red[300]!,
                onBackground: Colors.white,
                brightness: Brightness.light,
                onSecondary: AppColors.primaryColor,
                primary: AppColors.primaryColor,
                secondaryVariant: AppColors.primaryColor,
                primaryVariant: AppColors.primaryColor,
                onPrimary: AppColors.primaryColor,
                onSurface: Colors.white,
                surface: Colors.white),
            highlightColor: AppColors.primaryColor,
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.primaryColor),
            canvasColor: Colors.white,
            dividerColor: Colors.black,
            errorColor: Colors.red[300],
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.iOS: FadeThroughPageTransitionsBuilder()
              },
            ),
            tabBarTheme: TabBarTheme(
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily:
                        Theme.of(context).textTheme.headline6!.fontFamily)),
            appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                actionsIconTheme: const IconThemeData(color: Colors.white),
                color: AppColors.primaryColor,
                toolbarTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily:
                        Theme.of(context).textTheme.headline6!.fontFamily))),
        builder: (context, child) {
          return MediaQuery(
            child: child?? const SplashScreen(),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
