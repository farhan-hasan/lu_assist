import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view/edit_bus_screen.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view_model/bus_controller.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view_model/schedule_controller.dart';

import '../../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../../core/global/global_variables.dart';
import '../../../../../core/styles/theme/app_theme.dart';
import '../../../../../core/utils/constants/enum.dart';
import '../../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../../bus_list/data/model/bus_model.dart';

class BusCard extends ConsumerStatefulWidget {
  BusCard({
    super.key,
    required this.bus,
    required this.onDelete,
  });

  final BusModel bus;
  final Function(bool isSuccess) onDelete;

  @override
  ConsumerState<BusCard> createState() => _BusCardState();
}

class _BusCardState extends ConsumerState<BusCard> {
  SharedPreferenceManager sharedPreferenceManager =
      sl.get<SharedPreferenceManager>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: context.height * .12,
                width: context.width * .25,
                imageUrl: (widget.bus.image ?? dummyBusImage) == ""
                    ? dummyBusImage
                    : widget.bus.image ?? dummyUserImage,
                // placeholder: (context, url) =>
                //     CircularProgressIndicator(color: Colors.white,),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.bus.number}", overflow: TextOverflow.ellipsis),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Bus type: ${widget.bus.type}"),
                ],
              ),
            ),
            if (sharedPreferenceManager.getValue(
                    key: SharedPreferenceKeys.USER_ROLE) ==
                Role.admin.name)
              Expanded(
                flex: 1,
                child: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      bool busExists = await checkBusInUse(context);
                      if (busExists) {
                        return;
                      }
                      context.push(EditBusScreen.route, extra: {
                        "bus": widget.bus,
                        "onEdit": (bool isSuccess) => widget.onDelete(isSuccess)
                      });
                    } else if (value == 'delete') {
                      bool busExists = await checkBusInUse(context);
                      if (busExists) {
                        return;
                      }
                      deleteBus(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('Edit',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Delete',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<bool> checkBusInUse(BuildContext context) async {
    List<BusModel>? existingSchedule =
        ref.read(busScheduleProvider).allBusSchedule;
    existingSchedule ??=
        await ref.read(busScheduleProvider.notifier).getAllBusSchedule();
    bool busExists =
        existingSchedule.any((bus) => bus.number == widget.bus.number);
    if (busExists) {
      BotToast.showText(text: "Bus in use");
    }
    return busExists;
  }

  void deleteBus(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.question_mark,
                  color: primaryColor,
                  size: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Are you sure you want to delete this bus?",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Yes',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
              onPressed: () async {
                context.pop();
                bool isSuccess = await ref
                    .read(busProvider.notifier)
                    .deleteBus(busModel: widget.bus);
                widget.onDelete(isSuccess);
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
