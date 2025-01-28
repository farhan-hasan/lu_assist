import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/bus_list/data/model/bus_model.dart';
import 'package:lu_assist/src/features/bus_list/presentation/view_model/bus_controller.dart';

import '../../../../core/global/global_variables.dart';
import '../../../../core/network/firebase/firebase_storage_directory_name.dart';
import '../../../../core/styles/theme/app_theme.dart';
import '../../../../core/utils/logger/logger.dart';

class EditBusScreen extends ConsumerStatefulWidget {
  EditBusScreen({super.key, required this.onEdit, required this.bus});

  static const route = '/edit_bus_screen';
  final Function(bool isSuccess) onEdit;
  final BusModel bus;
  static setRoute() => '/edit_bus_screen';

  @override
  ConsumerState<EditBusScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends ConsumerState<EditBusScreen> {
  ValueNotifier<List<BusModel>> busListListener = ValueNotifier([]);
  List<String> typeNames = ["Select Option", "Large", "Medium", "Small"];
  final TextEditingController busNumberController = TextEditingController();
  final TextEditingController busTypeController = TextEditingController();
  ValueNotifier<File?> image = ValueNotifier(null);
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();

  get sharedPreferenceManager => null;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      busListListener.value =
          await ref.read(busProvider.notifier).getAllBuses();
      busNumberController.text = widget.bus.number ?? "";
      busTypeController.text = widget.bus.type ?? "";
    });
    super.initState();
  }

  Widget filesOption({
    required String title,
    String subtitle = "",
    required Function() onTap,
    required IconData icon,
  }) =>
      ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: Icon(icon),
          // backgroundColor: primary.withOpacity(0.5),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      );

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            filesOption(
              title: "Camera",
              subtitle: "Click a photo",
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  image.value = File(pickedFile.path);
                }
                context.pop();
              },
              icon: Icons.camera,
            ),
            filesOption(
              title: "Gallery",
              subtitle: "Choose from gallery",
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  image.value = File(pickedFile.path);
                }
                debug(image!.value);
                context.pop();
              },
              icon: Icons.image,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final busController = ref.watch(busProvider);
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Edit Bus")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Wrap(
                runSpacing: 10,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bus number';
                      }
                      return null; // Input is valid
                    },
                    controller: busNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Bus Number',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: (widget.bus.type ?? "Select Option") == ""
                        ? "Select Option"
                        : widget.bus.type ?? "Select Option",
                    validator: (value) {
                      if (value == "Select Option" || value == null) {
                        return "Please select a type";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Bus Type",
                    ),
                    dropdownColor: Colors.white,
                    // Set dropdown background color
                    items: typeNames
                        .map((route) => DropdownMenuItem<String>(
                              value: route,
                              child: Text(route),
                            ))
                        .toList(),
                    onChanged: (value) {
                      busTypeController.text = value ?? "";
                    },
                  ),
                  Center(
                    child: ValueListenableBuilder(
                      valueListenable: image,
                      builder: (context, value, child) {
                        return value == null ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: context.height*.12,
                          width: context.width*.25,
                          imageUrl:
                          (widget.bus.image ??
                              dummyBusImage) == "" ? dummyBusImage : widget.bus.image ??
                              dummyUserImage,
                          // placeholder: (context, url) =>
                          //     CircularProgressIndicator(color: Colors.white,),
                        ) :  Container(
                          width: context.width*.5,
                          height: context.height*.25,
                          color: Colors.grey[300],
                          child:value == null ? Image.asset("assets/images/no_image.png", fit: BoxFit.cover) : Image.file(
                                  value,
                                  fit: BoxFit.cover,
                                )
                        );
                      }
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: context.width*.5,
                      child: ElevatedButton(onPressed: () {
                        _showOptions(context);
                      }, style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ), child: const Text("Choose Image"),),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        List<BusModel> existingBuses = busController.busList ?? [];
                        bool exists = existingBuses.any((bus) => bus.number == busNumberController.text);
                        if(exists) {
                          BotToast.showText(text: "Bus already exists");
                          return;
                        }

                        if (formKey.currentState!.validate()) {

                          String imageLink = "";

                          if(image.value  != null) {
                            imageLink = await ref.read(busProvider.notifier).uploadBusImage(
                                file: image.value!,
                                directory: FirebaseStorageDirectoryName.BUS_IMAGE_DIRECTORY,
                                fileName: busNumberController.text);
                          }


                          BusModel busModel = BusModel();
                          busModel.number = busNumberController.text;
                          busModel.type = busTypeController.text;
                          busModel.image = imageLink;
                          busModel.allocated = false;

                          bool isSuccess = await ref
                              .read(busProvider.notifier)
                              .updateBus(busModel: busModel, oldBusModel: widget.bus);
                          if(isSuccess) {
                            widget.onEdit(isSuccess);
                          }
                          if (mounted) {
                            context.pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: busController.isLoading
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            )
                          : const Text(
                              'Update bus',
                              style: TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
