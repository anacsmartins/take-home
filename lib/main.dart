import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection/injection.dart';
import 'presentation/cubit/shortener_cubit.dart';
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShortenerCubit>(),
      child: MaterialApp(
        title: 'URL Shortener',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const HomePage(),
      ),
    );
  }
}
