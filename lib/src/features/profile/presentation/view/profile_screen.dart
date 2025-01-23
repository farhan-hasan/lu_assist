import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_keys.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_manager.dart';
import 'package:lu_assist/src/core/global/global_variables.dart';
import 'package:lu_assist/src/core/network/firebase/firebase_storage_directory_name.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/auth/presentation/logout/view_model/logout_controller.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_controller.dart';

import '../../../../core/utils/logger/logger.dart';
import '../../../../shared/dependency_injection/dependency_injection.dart';
import '../../../auth/data/model/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static const route = '/profile_screen';

  static setRoute() => '/profile_screen';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController routeController = TextEditingController();
  final SharedPreferenceManager sharedPreferenceManager =
      sl.get<SharedPreferenceManager>();
  final formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) async {
      UserModel? userModel = await ref.read(profileProvider.notifier).readProfile(sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID));
      debug("Hello");
      debug(userModel?.toJson());
      if (userModel != null) {
        nameController.text = userModel.name;
        idController.text =
            userModel.studentId == -1 ? "" : userModel.studentId.toString();
        batchController.text =
            userModel.batch == -1 ? "" : userModel.batch.toString();
        sectionController.text = userModel.section;
        departmentController.text = userModel.department;
        routeController.text =
            userModel.route == -1 ? "" : userModel.route.toString();
      }
    });
    super.initState();
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    String imageLink = "";
    XFile? getImage = await _picker.pickImage(
      source: source,
    );
    if (getImage != null) {
      _imageFile = File(getImage.path);
      imageLink = await ref.read(profileProvider.notifier).uploadProfileImage(
          file: _imageFile!,
          directory: FirebaseStorageDirectoryName.PROFILE_PICTURE_DIRECTORY,
          fileName: sharedPreferenceManager.getValue(key: SharedPreferenceKeys.USER_UID));

      UserModel? userModel = ref.read(profileProvider).userModel;
      if (userModel != null) {
        userModel.image = imageLink;
        ref.read(profileProvider.notifier).updateProfile(userModel);
      }
    }

    debug("Image link: $imageLink");
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
    showBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            filesOption(
              title: "Camera",
              subtitle: "Click a photo",
              onTap: () async {
                _pickAndUploadImage(ImageSource.camera);
                context.pop();
              },
              icon: Icons.camera,
            ),
            filesOption(
              title: "Gallery",
              subtitle: "Choose from gallery",
              onTap: () {
                _pickAndUploadImage(ImageSource.gallery);
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
    final screenSize = MediaQuery.of(context).size;
    final profileController = ref.watch(profileProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/LU_Assist__LOGO.png',
            height: screenSize.height * 0.20,
          ),
          actions: [
            IconButton(
                onPressed: () async {
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
                                "Are you sure you want to logout?",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Yes', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryColor),),
                            onPressed: () async {
                              await ref.read(logoutProvider.notifier).logout();
                              context.pop();
                            },
                          ),
                          TextButton(
                            child: Text('No', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryColor),),
                            onPressed: () async {
                              context.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                              child:
                              profileController.isProfilePictureLoading
                                  ? const CircularProgressIndicator(color: Colors.white,) :
                              CachedNetworkImage(
                                      fit: BoxFit.cover,
                                       height: 120,
                                      width: 120,
                                      imageUrl:
                                      (profileController.userModel?.image ??
                                          dummyUserImage) =="" ? dummyUserImage : profileController.userModel?.image ??
                                          dummyUserImage,
                                      // placeholder: (context, url) =>
                                      //     CircularProgressIndicator(color: Colors.white,),
                                    )
                              ),
                        ),
                        Container(
                          height: context.height*.05,
                          width: context.width*.11,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: primaryColor, // Border color
                              width: 2.0,         // Border width
                            ),
                            borderRadius: BorderRadius.circular(100.0), // Rounded corners (optional)
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              //backgroundColor: Colors.white,
                            ),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              _showOptions(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  //_buildLabel("Name"),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ID
                  // _buildLabel("ID"),
                  TextFormField(
                    validator: (value) {
                      // Regular expression: Matches exactly one uppercase letter (A-Z)
                      String pattern = r'^\d+$';
                      if (value != null && !RegExp(pattern).hasMatch(value)) {
                        return 'Invalid Student ID';
                      }
                      return null; // Input is valid
                    },
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Batch and Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //_buildLabel("Batch"),
                            TextFormField(
                              validator: (value) {
                                // Regular expression: Matches exactly one uppercase letter (A-Z)
                                String pattern = r'^\d+$';
                                if (value != null &&
                                    !RegExp(pattern).hasMatch(value)) {
                                  return 'Invalid Batch';
                                }
                                return null; // Input is valid
                              },
                              controller: batchController,
                              decoration: const InputDecoration(
                                labelText: 'Batch',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //_buildLabel("Section"),
                            TextFormField(
                              validator: (value) {
                                // Regular expression: Matches exactly one uppercase letter (A-Z)
                                String pattern = r'^[A-Z]$';
                                if (value != null &&
                                    !RegExp(pattern).hasMatch(value)) {
                                  return 'Invalid Section';
                                }
                                return null; // Input is valid
                              },
                              controller: sectionController,
                              decoration: const InputDecoration(
                                labelText: 'Section',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Department Dropdown
                  //_buildLabel("Department"),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if(value == "Select Option") {
                        return "Please select a department";
                      }
                      return null;
                    },
                    value: (profileController.userModel?.department ?? "Select department") == "" ? "Select department" : profileController.userModel?.department ?? "Select department",

                    decoration: const InputDecoration(
                      labelText:"Department",
                    ),
                    dropdownColor: Colors.white, // Set dropdown background color
                    items: const [
                      DropdownMenuItem(
                        value: 'Select Option',
                        child: Text('Select Option', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'CSE',
                        child: Text('CSE', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'EEE',
                        child: Text('EEE', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'BBA',
                        child: Text('BBA', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'Civil',
                        child: Text('Civil Engineering',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'Islamic Studies',
                        child: Text('Islamic Studies',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'Architecture',
                        child: Text('Architecture',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'English',
                        child: Text('English',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'Bangla',
                        child:
                            Text('Bangla', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'THM',
                        child: Text('THM', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'LAW',
                        child: Text('LAW', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    onChanged: (value) {
                      departmentController.text = value ?? "";
                    },
                  ),
                  const SizedBox(height: 12),

                  // Bus Route Dropdown
                  //_buildLabel("Bus Route"),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if(value == "Select Option") {
                        return "Please select a route";
                      }
                      return null;
                    },
                    value: (profileController.userModel?.route.toString() ?? "Select route") == "-1" ? "Select route" : profileController.userModel?.route.toString() ?? "Select route",
                    decoration: const InputDecoration(
                      labelText: "Bus Route",
                    ),
                    dropdownColor: Colors.white, // Set dropdown background color
                    items: const [
                      DropdownMenuItem(
                        value: 'Select Option',
                        child: Text('Select Option', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: '1',
                        child: Text('1', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        child: Text('2', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('3', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: '4',
                        child: Text('4', style: TextStyle(color: Colors.black)),
                      )
                    ],
                    onChanged: (value) {
                      routeController.text = value ?? "";
                    },
                  ),
                  const SizedBox(height: 12),

                  // Save Changes Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          UserModel? userModel =
                              ref.read(profileProvider).userModel;
                          if (userModel != null) {
                            userModel.name = nameController.text;
                            userModel.studentId =
                                int.tryParse(idController.text.trim())!;
                            userModel.batch =
                                int.tryParse(batchController.text.trim())!;
                            userModel.section = sectionController.text.trim();
                            userModel.department = departmentController.text.trim();
                            userModel.route =
                                int.tryParse(routeController.text.trim())!;

                            ref
                                .read(profileProvider.notifier)
                                .updateProfile(userModel);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: profileController.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Save changes',
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
  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    batchController.dispose();
    sectionController.dispose();
    departmentController.dispose();
    routeController.dispose();
    super.dispose();
  }

  // Reusable Label Widget
  // Widget _buildLabel(String text) {
  //   return Text(
  //     text,
  //     style: TextStyle(
  //       fontSize: 18.0,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

}
