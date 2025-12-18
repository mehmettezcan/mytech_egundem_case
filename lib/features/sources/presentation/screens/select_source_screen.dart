import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';
import 'package:mytech_egundem_case/core/widgets/button.dart';
import 'package:mytech_egundem_case/features/sources/presentation/controllers/sources_controller.dart';
import 'package:mytech_egundem_case/routes.dart';

class SelectSourceScreen extends ConsumerWidget {
  const SelectSourceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sourcesControllerProvider);
    final ctrl = ref.read(sourcesControllerProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            'Select News Sources',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: Container(height: 1, color: Colors.white24),
          ),
        ),
        body: SafeArea(
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (st) {
              final grouped = ctrl.groupedFiltered();
          
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: ctrl.setSearch,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          gapPadding: 0.0,
                          borderSide: BorderSide.none,
                        ),
          
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search for a source...',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          grouped.entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    entry.key.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...entry.value.map((s) {
                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        s.imageUrl.isNotEmpty ? s.imageUrl : null,
                                        height: 40,
                                      ),
                                    ),
                                    title: Text(s.name),
                                    // subtitle: Text(
                                    //   s.description,
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                    trailing: _switch(
                                      value: st.followedIds.contains(s.id),
                                      onChanged: (val) {
                                        ctrl.toggleFollow(s.id);
                                      },
                                    ),
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: EgundemButton( onPressed:
                              st.isSaving
                                  ? null
                                  : () async {
                                    await ctrl.save();
                              
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        RouteGenerator.homeScreen,
                                      );
                                    }
                                  },
                          child:
                              st.isSaving
                                  ? const CircularProgressIndicator(strokeWidth: 2)
                                  : const Text('Save'),),
                  ),
                 
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _switch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey,
      padding: const EdgeInsets.all(0),
    );
  }
}
