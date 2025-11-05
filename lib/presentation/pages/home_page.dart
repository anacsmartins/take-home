import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('kInputUrl'),
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'https://your.url',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                    ),
                    textInputAction: TextInputAction
                        .done, // faz o enter aparecer como "done"
                    onSubmitted: (value) {
                      context.read<ShortenerCubit>().shorten(value.trim());
                    },
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  child: IconButton(
                    key: const Key('kButtonShorten'),
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final value = controller.text.trim();
                      if (value.isEmpty) return;
                      context.read<ShortenerCubit>().shorten(value);
                      controller.clear();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recently shortened URLs',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<ShortenerCubit, ShortenerState>(
                builder: (context, state) {
                  if (state is ShortenerLoading) {
                    // shimmer mock loading skeleton
                    return ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        return ListTile(
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          title: Container(
                            height: 14,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Container(
                              height: 12,
                              width: MediaQuery.of(context).size.width * .6,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state is ShortenerError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is ShortenerSuccess) {
                    return ListView.separated(
                      key: const Key('kListShortened'),
                      itemCount: state.list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final item = state.list[i];
                        return ListTile(
                          key: Key('kShortItem-$i'),
                          title: Text(
                            item.shortUrl,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            item.originalUrl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: item.shortUrl),
                              );

                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied!')),
                              );
                            },
                          ),
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
