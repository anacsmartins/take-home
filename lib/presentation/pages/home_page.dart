import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_shortener/presentation/cubit/shortener_cubit.dart';
import 'package:url_shortener/presentation/cubit/shortener_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('URL Shortener')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: const Key('kInputUrl'),
              controller: controller,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('kButtonShorten'),
              onPressed: () {
                context.read<ShortenerCubit>().shorten(controller.text.trim());
              },
              child: const Text('Encurtar'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<ShortenerCubit, ShortenerState>(
                builder: (context, state) {
                  if (state is ShortenerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ShortenerError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ShortenerSuccess) {
                    return ListView.builder(
                      key: const Key('kListShortened'),
                      itemCount: state.list.length,
                      itemBuilder: (_, i) {
                        final item = state.list[i];
                        return ListTile(
                          key: Key('kShortItem-$i'),
                          title: Text(item.shortUrl),
                          subtitle: Text(item.originalUrl),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
