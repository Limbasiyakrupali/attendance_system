// import 'package:attendance_system/core/constant/app_color.dart';
// import 'package:flutter/material.dart';
//
// import '../core/constant/app_string.dart';
// import '../core/widget/common_widget.dart';
//
// class AddUserScreen extends StatefulWidget {
//   const AddUserScreen({super.key});
//
//   @override
//   State<AddUserScreen> createState() => _AddUserScreenState();
// }
//
// class _AddUserScreenState extends State<AddUserScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final Map<String,dynamic> user = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
//     return Container(
//       color: AppColors.primary,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: AppColors.white,
//           body: Column(
//             children: [
//               CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${user['user']['name']} (${user['user']['role']})"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/widget/custom_textfield.dart';
import '../provider/user_provider.dart';
import '../../../core/widget/common_widget.dart';
import '../../../core/constant/app_color.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  final _formKey = GlobalKey<FormState>();

  /// Controllers
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final empCode = TextEditingController();
  final fullName = TextEditingController();

  final doj = TextEditingController();
  final dob = TextEditingController();

  final mobile = TextEditingController();
  final emergency = TextEditingController();

  final imageUrlController = TextEditingController();

  /// Role Dropdown
  String? selectedRole;
  final roles = ["ADMIN", "HR", "EMPLOYEE", "TRAINEE", "FREELANCER"];

  /// Image Preview (local only)
  File? imageFile;

  /// 📅 Date Picker
  Future<void> pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
      _formKey.currentState?.validate();
    }
  }

  /// 📸 Pick Image (Preview Only)
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  /// 📸 Bottom Sheet
  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),

            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),

            if (imageFile != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Remove Image"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => imageFile = null);
                },
              ),
          ],
        );
      },
    );
  }

  /// 🚀 Submit
  // Future<void> submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   if (selectedRole == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Select Role")),
  //     );
  //     return;
  //   }
  //
  //   final provider = context.read<UserProvider>();
  //
  //   final body = {
  //     "name": name.text.trim(),
  //     "email": email.text.trim(),
  //     "password": password.text.trim(),
  //     "role": selectedRole,
  //
  //     "employeeCode": empCode.text.trim(),
  //     "fullName": fullName.text.trim(),
  //
  //     "dateOfJoin": doj.text,
  //     "dob": dob.text,
  //
  //     "companyMobile": mobile.text,
  //     "emergencyNumber": emergency.text,
  //
  //     /// ✅ URL ONLY (IMPORTANT)
  //     "photograph": imageUrlController.text.trim(),
  //   };
  //
  //   bool success = await provider.createUser(body);
  //
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("User Created Successfully")),
  //     );
  //     Navigator.pop(context);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to create user")),
  //     );
  //   }
  // }
  // Future<void> submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   if (selectedRole == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Select Role")),
  //     );
  //     return;
  //   }
  //
  //   if (imageUrlController.text.trim().isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Enter Image URL")),
  //     );
  //     return;
  //   }
  //
  //   final provider = context.read<UserProvider>();
  //
  //   final body = {
  //     "name": name.text.trim(),
  //     "email": email.text.trim(),
  //     "password": password.text.trim(),
  //     "role": selectedRole,
  //
  //     "employeeCode": empCode.text.trim(),
  //     "fullName": fullName.text.trim(),
  //
  //     "dateOfJoin": doj.text,
  //     "dob": dob.text,
  //
  //     "companyMobile": mobile.text,
  //     "emergencyNumber": emergency.text,
  //
  //     "photograph": convertDriveLink(imageUrlController.text.trim()),
  //   };
  //
  //   log(body.toString(), name: "CREATE USER");
  //
  //   bool success = await provider.createUser(body);
  //
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("User Created Successfully")),
  //     );
  //     Navigator.pushNamed(context, 'show_user');
  //
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to create user")),
  //     );
  //   }
  // }
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select Role")),
      );
      return;
    }

    final imageUrl = imageUrlController.text.trim();

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Image URL")),
      );
      return;
    }

    final provider = context.read<UserProvider>();

    final body = {
      "name": name.text.trim(),
      "email": email.text.trim(),
      "password": password.text.trim(),
      "role": selectedRole,

      "employeeCode": empCode.text.trim(),
      "fullName": fullName.text.trim(),

      "dateOfJoin": doj.text,
      "dob": dob.text,

      "companyMobile": mobile.text,
      "emergencyNumber": emergency.text,

      // 🔥 IMPORTANT
      "photograph": convertDriveLink(imageUrl),
    };

    log(body.toString(), name: "CREATE USER");

    bool success = await provider.createUser(body);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User Created Successfully")),
      );

      Navigator.pushNamed(context, 'show_user');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create user")),
      );
    }
  }
  /// Validators
  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Required";
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
      return "Invalid email";
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.length != 10) return "Enter valid number";
    return null;
  }

  String? urlValidator(String? value) {
    if (value == null || value.isEmpty) return "Enter image URL";
    if (!value.startsWith("http")) return "Invalid URL";
    return null;
  }

  String convertDriveLink(String input) {
    if (input.isEmpty) return input;

    input = input.trim();

    // Case 1: file/d/ID
    final fileRegex = RegExp(r'd/([a-zA-Z0-9_-]+)');
    final fileMatch = fileRegex.firstMatch(input);

    if (fileMatch != null) {
      return "https://drive.google.com/uc?export=view&id=${fileMatch.group(1)}";
    }

    // Case 2: open?id=ID
    final openRegex = RegExp(r'id=([a-zA-Z0-9_-]+)');
    final openMatch = openRegex.firstMatch(input);

    if (openMatch != null) {
      return "https://drive.google.com/uc?export=view&id=${openMatch.group(1)}";
    }

    // Case 3: already converted
    if (input.contains("uc?export=view")) {
      return input;
    }

    // Case 4: direct ID
    if (!input.startsWith("http")) {
      return "https://drive.google.com/uc?export=view&id=$input";
    }

    return input;
  }

  // String convertDriveLink(String url) {
  //   try {
  //     if (url.isEmpty) return "";
  //
  //     /// Already correct
  //     if (url.contains("uc?export=view&id=")) return url;
  //
  //     String? fileId;
  //
  //     /// Case 1: /file/d/
  //     final regExp1 = RegExp(r'/d/([a-zA-Z0-9_-]+)');
  //     final match1 = regExp1.firstMatch(url);
  //     if (match1 != null) {
  //       fileId = match1.group(1);
  //     }
  //
  //     /// Case 2: id=
  //     final regExp2 = RegExp(r'id=([a-zA-Z0-9_-]+)');
  //     final match2 = regExp2.firstMatch(url);
  //     if (match2 != null) {
  //       fileId ??= match2.group(1);
  //     }
  //
  //     if (fileId != null && fileId.isNotEmpty) {
  //       return "https://drive.google.com/uc?export=view&id=$fileId";
  //     }
  //
  //     return url;
  //   } catch (e) {
  //     return url;
  //   }
  // }

  Widget networkImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        height: 120,
        width: 120,
        fit: BoxFit.cover,

        /// 🔥 CRASH FIX
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 120,
            width: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 120,
            width: 120,
            child: Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Create User")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              /// IMAGE PREVIEW
              // GestureDetector(
              //   onTap: showImagePickerOptions,
              //   child: Container(
              //     height: 120,
              //     width: 120,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: AppColors.primary),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: imageFile == null
              //         ? const Icon(Icons.camera_alt)
              //         : ClipRRect(
              //       borderRadius: BorderRadius.circular(10),
              //       child: Image.file(imageFile!, fit: BoxFit.cover),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              /// IMAGE URL FIELD
              // CommonTextField(
              //   title: "Image URL",
              //   controller: imageUrlController,
              //   hint: "Paste Google Drive Image URL",
              //   validator: urlValidator,
              // ),
              // CommonTextField(
              //   title: "Image URL",
              //   controller: imageUrlController,
              //   hint: "Paste Google Drive link",
              //   onChange: (val) {
              //     if (isUpdating) return;
              //     final converted = convertDriveLink(val);
              //     if (val != converted) {
              //       isUpdating = true;
              //       imageUrlController.value = TextEditingValue(
              //         text: converted,
              //         selection: TextSelection.collapsed(offset: converted.length),
              //       );
              //       isUpdating = false;
              //     }
              //   },
              //
              //   validator: (val) {
              //     if (val == null || val.isEmpty) return "Enter image URL";
              //     if (!val.startsWith("http")) return "Invalid URL";
              //     return null;
              //   },
              // ),
              CommonTextField(
                title: "Image URL",
                controller: imageUrlController,
                hint: "Paste Google Drive link",

                onChange: (val) {
                  if (isUpdating) return;

                  final converted = convertDriveLink(val.trim());

                  if (val.trim() != converted) {
                    isUpdating = true;

                    imageUrlController.value = TextEditingValue(
                      text: converted,
                      selection: TextSelection.collapsed(offset: converted.length),
                    );

                    isUpdating = false;
                  }
                },

                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter image URL";

                  if (!val.contains("http")) {
                    return "Invalid URL";
                  }

                  return null;
                },
              ),
              // if (imageUrlController.text.isNotEmpty)
              //   networkImage(    /////////                1
              //     convertDriveLink(imageUrlController.text),
              //   ),
              const SizedBox(height: 10),

              CommonTextField(
                title: "Name",
                controller: name,
                hint: "Enter Name",
                validator: requiredValidator,
              ),

              const SizedBox(height: 10),

              CommonTextField(
                title: "Email",
                controller: email,
                hint: "Enter Email",
                validator: emailValidator,
              ),

              const SizedBox(height: 10),

              CommonTextField(
                title: "Password",
                controller: password,
                hint: "Enter Password",
                obscureText: true,
                validator: requiredValidator,
              ),

              const SizedBox(height: 10),

              /// ROLE
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedRole = val),
                decoration: const InputDecoration(
                  labelText: "Select Role",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null ? "Select Role" : null,
              ),

              const SizedBox(height: 10),

              CommonTextField(
                title: "Employee Code",
                controller: empCode,
                hint: "EMP001",
                validator: requiredValidator,
              ),

              const SizedBox(height: 10),

              CommonTextField(
                title: "Full Name",
                controller: fullName,
                hint: "Full Name",
                validator: requiredValidator,
              ),

              const SizedBox(height: 10),

              /// DATE
              GestureDetector(
                onTap: () => pickDate(doj),
                child: AbsorbPointer(
                  child: CommonTextField(
                    title: "Date Of Joining",
                    controller: doj,
                    hint: "Select Date",
                    prefixIcon: Icons.calendar_today,
                    validator: requiredValidator,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => pickDate(dob),
                child: AbsorbPointer(
                  child: CommonTextField(
                    title: "DOB",
                    controller: dob,
                    hint: "Select Date",
                    prefixIcon: Icons.calendar_today,
                    validator: requiredValidator,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CommonTextField(
                title: "Mobile",
                controller: mobile,
                hint: "9876543210",
                keyboardType: TextInputType.phone,
                validator: phoneValidator,
              ),

              const SizedBox(height: 10),

              CommonTextField(
                title: "Emergency",
                controller: emergency,
                hint: "Emergency Number",
                keyboardType: TextInputType.phone,
                validator: phoneValidator,
              ),

              // const SizedBox(height: 20),
              buildImagePreview(),
              const SizedBox(height: 20),
              /// BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: provider.isLoading ? null : submit,
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create User"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildImagePreview() {
    final url = imageUrlController.text;

    if (url.isEmpty) {
      return const Icon(Icons.person, size: 60);
    }

    return Image.network(
      url,
      height: 80,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 60);
      },
    );
  }
}