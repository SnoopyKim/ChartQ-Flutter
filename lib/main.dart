import 'package:chart_q/constants/style.dart';
import 'package:chart_q/shared/providers/scaffold_messenger_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final scaffoldMessengerKey = ref.watch(scaffoldMessengerKeyProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ChartQ',
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.main,
          surface: AppColor.white,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      supportedLocales: [
        Locale('en'),
        Locale('ko'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CountryLocalizations.delegate,
      ],
    );
  }
}
