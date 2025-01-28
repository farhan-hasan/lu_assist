import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view/add_bus_screen.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view/components/bus_card.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view_model/bus_controller.dart';

import '../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../core/utils/constants/enum.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../bus_list/data/model/bus_model.dart';

class BusListScreen extends ConsumerStatefulWidget {
  const BusListScreen({super.key});

  static const route = '/bus_list_screen';

  static setRoute() => '/bus_list_screen';

  @override
  ConsumerState<BusListScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<BusListScreen>
    with TickerProviderStateMixin {
  SharedPreferenceManager sharedPreferenceManager =
  sl.get<SharedPreferenceManager>();
  ValueNotifier<List<BusModel>> busListener = ValueNotifier([]);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      busListener.value =
      await ref.read(busProvider.notifier).getAllBuses();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  refreshBus(bool isSuccess) async {
    if (isSuccess) {
      busListener.value =
      await ref.read(busProvider.notifier).getAllBuses();
    }
  }


  @override
  Widget build(BuildContext context) {
    final busController = ref.watch(busProvider);
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  const Text("Bus List"),
        ),
        floatingActionButton: sharedPreferenceManager.getValue(
            key: SharedPreferenceKeys.USER_ROLE) ==
            Role.admin.name
            ? FloatingActionButton(
          onPressed: () {
            context.push(AddBusScreen.route,
                extra: (bool isSuccess) => refreshBus(isSuccess));
          },
          child: const Icon(Icons.add),
        )
            : null,
        body: ValueListenableBuilder(
          builder: (context, busList, child) {
            return busController.isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : busList.isEmpty
                ? const Center(
              child: Text("No Buses found"),
            )
                : ListView.builder(
              itemCount: busList.length,
              itemBuilder: (context, index) {
                final bus = busList[index];
                return BusCard(
                  bus: bus,
                  onDelete: (bool isSuccess) =>
                      refreshBus(isSuccess),
                ); // Replace with your BusCard widget
              },
            );
          },
          valueListenable: busListener,
        ),
      ),
    );
  }
}
