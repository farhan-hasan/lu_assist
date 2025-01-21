import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_keys.dart';
import 'package:lu_assist/src/core/database/local/shared_preference/shared_preference_manager.dart';
import 'package:lu_assist/src/core/network/firebase/firebase_storage_directory_name.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
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
    final logoutController = ref.watch(logoutProvider);
    final profileController = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF433878),
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
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        backgroundColor: primaryColor,
                        child: ClipOval(
                            child:
                            profileController.isProfilePictureLoading
                                ? const CircularProgressIndicator(color: Colors.white,) :
                            CachedNetworkImage(
                                    fit: BoxFit.cover,
                                     height: 120,
                                    width: 120,
                                    imageUrl:
                                        profileController.userModel?.image ??
                                            "",
                                    // placeholder: (context, url) =>
                                    //     CircularProgressIndicator(color: Colors.white,),
                                  )
                            ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _showOptions(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // Name
                //_buildLabel("Name"),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      // Border color when selected
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // ID
                // _buildLabel("ID"),
                TextFormField(
                  validator: (value) {
                    // Regular expression: Matches exactly one uppercase letter (A-Z)
                    String pattern = r'^\d+$';
                    if (value != null && !RegExp(pattern).hasMatch(value)) {
                      return 'Invalid Batch';
                    }
                    return null; // Input is valid
                  },
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      // Border color when selected
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(height: 16),

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
                            decoration: InputDecoration(
                              labelText: 'Batch',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                // Border color when selected
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
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
                            decoration: InputDecoration(
                              labelText: 'Section',
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                // Border color when selected
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Department Dropdown
                //_buildLabel("Department"),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: profileController.userModel?.department ?? "Department",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      // Border color when not selected
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      // Border color when selected
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white, // Set dropdown background color
                  items: const [
                    DropdownMenuItem(
                      child: Text('CSE', style: TextStyle(color: Colors.black)),
                      value: 'CSE',
                    ),
                    DropdownMenuItem(
                      child: Text('EEE', style: TextStyle(color: Colors.black)),
                      value: 'EEE',
                    ),
                    DropdownMenuItem(
                      child: Text('BBA', style: TextStyle(color: Colors.black)),
                      value: 'BBA',
                    ),
                    DropdownMenuItem(
                      child: Text('Civil Engineering',
                          style: TextStyle(color: Colors.black)),
                      value: 'Civil',
                    ),
                    DropdownMenuItem(
                      child: Text('Islamis Studies',
                          style: TextStyle(color: Colors.black)),
                      value: 'Islamis Studies',
                    ),
                    DropdownMenuItem(
                      child: Text('Architecture',
                          style: TextStyle(color: Colors.black)),
                      value: 'Architecture',
                    ),
                    DropdownMenuItem(
                      child: Text('English',
                          style: TextStyle(color: Colors.black)),
                      value: 'English',
                    ),
                    DropdownMenuItem(
                      child:
                          Text('Bangla', style: TextStyle(color: Colors.black)),
                      value: 'Bangla',
                    ),
                    DropdownMenuItem(
                      child: Text('THM', style: TextStyle(color: Colors.black)),
                      value: 'THM',
                    ),
                    DropdownMenuItem(
                      child: Text('LAW', style: TextStyle(color: Colors.black)),
                      value: 'LAW',
                    ),
                  ],
                  onChanged: (value) {
                    departmentController.text = value ?? "";
                  },
                ),
                SizedBox(height: 12),

                // Bus Route Dropdown
                //_buildLabel("Bus Route"),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: profileController.userModel?.route.toString() ?? "Bus Route",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      // Border color when not selected
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      // Border color when selected
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white, // Set dropdown background color
                  items: [
                    DropdownMenuItem(
                      child: Text('1', style: TextStyle(color: Colors.black)),
                      value: '1',
                    ),
                    DropdownMenuItem(
                      child: Text('2', style: TextStyle(color: Colors.black)),
                      value: '2',
                    ),
                    DropdownMenuItem(
                      child: Text('3', style: TextStyle(color: Colors.black)),
                      value: '3',
                    ),
                    DropdownMenuItem(
                      child: Text('4', style: TextStyle(color: Colors.black)),
                      value: '4',
                    )
                  ],
                  onChanged: (value) {
                    routeController.text = value ?? "";
                  },
                ),
                SizedBox(height: 12),

                // Save Changes Button
                ElevatedButton(
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
                    backgroundColor: Color(0xFF433878),
                    minimumSize: Size(double.infinity, 50),
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
              ],
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
