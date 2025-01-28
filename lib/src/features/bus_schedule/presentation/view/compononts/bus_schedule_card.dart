
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/edit_schedule_screen.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view_model/schedule_controller.dart';

import '../../../../../core/database/local/shared_preference/shared_preference_keys.dart';
import '../../../../../core/database/local/shared_preference/shared_preference_manager.dart';
import '../../../../../core/global/global_variables.dart';
import '../../../../../core/styles/theme/app_theme.dart';
import '../../../../../core/utils/constants/enum.dart';
import '../../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../../bus_list/data/model/bus_model.dart';

class BusScheduleCard extends ConsumerStatefulWidget {
  BusScheduleCard({
    super.key,
    required this.bus,
    required this.onDelete,
  });
  final BusModel bus;
  final Function(bool isSuccess) onDelete;
  @override
  ConsumerState<BusScheduleCard> createState() => _BusCardState();
}

class _BusCardState extends ConsumerState<BusScheduleCard> {
  SharedPreferenceManager sharedPreferenceManager = sl.get<SharedPreferenceManager>();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              height: 120,
              width: 120,
              imageUrl:
              (widget.bus.image ??
                  dummyBusImage) == "" ? dummyBusImage : widget.bus.image ??
                  dummyUserImage,
              // placeholder: (context, url) =>
              //     CircularProgressIndicator(color: Colors.white,),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bus number: ${widget.bus.number}"),
                SizedBox(height: 5,),
                Text("Bus type: ${widget.bus.type}"),
                SizedBox(height: 5,),
                (widget.bus.incoming ?? false) ? incomingBus() : outgoingBus()
              ],
            ),
            if(sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_ROLE) == Role.admin.name)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {

                    context.push(EditScheduleScreen.route, extra: {
                      "bus" : widget.bus,
                      "onEdit" :(bool isSuccess) => widget.onDelete(isSuccess)
                    });


                  } else if (value == 'delete') {
                    deleteSchedule(context);
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
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  void deleteSchedule(BuildContext context) {
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
                  "Are you sure you want to delete this schedule?",
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
                    .read(busScheduleProvider.notifier)
                    .deleteSchedule(busModel: widget.bus);
                if(isSuccess) {
                  await ref
                      .read(busScheduleProvider.notifier)
                      .toggleBusAllocation(busModel: widget.bus..allocated = false);
                  await widget.onDelete(isSuccess);

                }

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

  Widget incomingBus() {
    return const Row(
                children: [
                  Icon(CupertinoIcons.home, color: primaryColor,),
                  Icon(Icons.arrow_right_alt, color: primaryColor,),
                  Icon(Icons.arrow_right_alt, color: primaryColor,),
                  Icon(Icons.arrow_right_alt, color: primaryColor,),
                  Icon(Icons.apartment, color: primaryColor,)
                ],
              );
  }

  Widget outgoingBus() {
    return const Row(
      children: [
        Icon(Icons.apartment, color: primaryColor,),
        Icon(Icons.arrow_right_alt, color: primaryColor,),
        Icon(Icons.arrow_right_alt, color: primaryColor,),
        Icon(Icons.arrow_right_alt, color: primaryColor,),
        Icon(CupertinoIcons.home, color: primaryColor,)
      ],
    );
  }
}