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
import 'package:attendance_system/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_string.dart';
import '../core/constant/app_typography.dart';
import '../core/widget/custom_textfield.dart';
import '../provider/user_provider.dart';
import '../../../core/widget/common_widget.dart';
import '../../../core/constant/app_color.dart';

class AddUserScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const AddUserScreen({super.key, this.userData});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  final _formKey = GlobalKey<FormState>();
  bool showPassword = true;
  /// Role Dropdown
  String? selectedRole;
  final roles = ["ADMIN", "HR", "EMPLOYEE", "TRAINEE", "FREELANCER"];

  DateTime selectedDate = DateTime.now();
  /// Image Preview (local only)
  File? imageFile;
  late final bool isEdit;

  /// Controllers
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController empCode = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController department = TextEditingController();

  final TextEditingController doj = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController bloodGroup = TextEditingController();

  final TextEditingController mobile = TextEditingController();
  final TextEditingController emergency = TextEditingController();
  final TextEditingController companyEmail = TextEditingController();
  final TextEditingController employeeAddress = TextEditingController();
  final TextEditingController personalEmail = TextEditingController();
  final TextEditingController personalNumber = TextEditingController();
  final TextEditingController tShirtSize = TextEditingController();

  final TextEditingController imageUrlController = TextEditingController();

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
  //   final imageUrl = imageUrlController.text.trim();
  //
  //   if (imageUrl.isEmpty) {
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
  //     "fullName": name.text.trim(),
  //     "email": email.text.trim(),
  //     "password": password.text.trim(),
  //     "role": selectedRole,
  //
  //     "employeeCode": empCode.text.trim(),
  //     "designation": designation.text.trim(),
  //     "department": department.text.trim(),
  //
  //     "dateOfJoin": doj.text,
  //     "dob": dob.text,
  //     "bloodGroup": bloodGroup.text,
  //
  //     "companyMobile": mobile.text,
  //     "emergencyNumber": emergency.text,
  //     "companyEmail": companyEmail.text,
  //     "employeeAddress": employeeAddress.text,
  //     "personalEmail": personalEmail.text,
  //     "personalNumber": personalNumber.text,
  //     "tShirtSize": tShirtSize.text,
  //
  //     "photograph": convertDriveLink(imageUrl),
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
  //     Navigator.pushNamed(context, 'dashboard');
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to create user")),
  //     );
  //   }
  // }
  // Future<void> submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   final provider = context.read<UserProvider>();
  //   final isEdit = widget.userData != null;
  //
  //   if (selectedRole == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Select Role")),
  //     );
  //     return;
  //   }
  //
  //   final imageUrl = imageUrlController.text.trim();
  //
  //   if (imageUrl.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Enter Image URL")),
  //     );
  //     return;
  //   }
  //
  //   /// ✅ SAME FULL BODY (no changes)
  //   final body = {
  //     "name": name.text.trim(),
  //     "fullName": name.text.trim(),
  //     "email": email.text.trim(),
  //     "password": password.text.trim(),
  //     "role": selectedRole,
  //
  //     "employeeCode": empCode.text.trim(),
  //     "designation": designation.text.trim(),
  //     "department": department.text.trim(),
  //
  //     "dateOfJoin": doj.text,
  //     "dob": dob.text,
  //     "bloodGroup": bloodGroup.text,
  //
  //     "companyMobile": mobile.text,
  //     "emergencyNumber": emergency.text,
  //     "companyEmail": companyEmail.text,
  //     "employeeAddress": employeeAddress.text,
  //     "personalEmail": personalEmail.text,
  //     "personalNumber": personalNumber.text,
  //     "tShirtSize": tShirtSize.text,
  //
  //     "photograph": convertDriveLink(imageUrl),
  //   };
  //
  //   bool success = false;
  //
  //   if (isEdit) {
  //     /// ✅ UPDATE USER (FULL BODY)
  //     final userId = widget.userData!["id"]; // or "_id"
  //
  //     log(body.toString(), name: "UPDATE USER");
  //
  //     success = await provider.updateUser(userId, body);
  //
  //   } else {
  //     /// ✅ CREATE USER
  //     log(body.toString(), name: "CREATE USER");
  //
  //     success = await provider.createUser(body);
  //   }
  //
  //   /// ✅ Response
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(isEdit
  //             ? "User Updated Successfully"
  //             : "User Created Successfully"),
  //       ),
  //     );
  //
  //     Navigator.pop(context);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Something went wrong")),
  //     );
  //   }
  // }
  // Future<void> submit() async {
  //   final isEdit = widget.userData != null;
  //   final provider = context.read<UserProvider>();
  //
  //   // ✅ Only validate required fields when creating
  //   if (!isEdit && !_formKey.currentState!.validate()) return;
  //
  //   final imageUrl = imageUrlController.text.trim();
  //
  //   // ✅ Only check role & image URL for create
  //   if (!isEdit) {
  //     if (selectedRole == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Select Role")),
  //       );
  //       return;
  //     }
  //
  //     if (imageUrl.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Enter Image URL")),
  //       );
  //       return;
  //     }
  //   }
  //
  //   // ✅ Build request body
  //   final Map<String, dynamic> body = {};
  //
  //   // Add fields only if non-empty (important for edit)
  //   if (name.text.trim().isNotEmpty) body["name"] = name.text.trim();
  //   if (name.text.trim().isNotEmpty) body["fullName"] = name.text.trim();
  //   if (email.text.trim().isNotEmpty) body["email"] = email.text.trim();
  //   if (password.text.trim().isNotEmpty) body["password"] = password.text.trim();
  //   if (selectedRole != null) body["role"] = selectedRole;
  //
  //   if (empCode.text.trim().isNotEmpty) body["employeeCode"] = empCode.text.trim();
  //   if (designation.text.trim().isNotEmpty) body["designation"] = designation.text.trim();
  //   if (department.text.trim().isNotEmpty) body["department"] = department.text.trim();
  //
  //   if (doj.text.trim().isNotEmpty) body["dateOfJoin"] = doj.text.trim();
  //   if (dob.text.trim().isNotEmpty) body["dob"] = dob.text.trim();
  //   if (bloodGroup.text.trim().isNotEmpty) body["bloodGroup"] = bloodGroup.text.trim();
  //
  //   if (mobile.text.trim().isNotEmpty) body["companyMobile"] = mobile.text.trim();
  //   if (emergency.text.trim().isNotEmpty) body["emergencyNumber"] = emergency.text.trim();
  //   if (companyEmail.text.trim().isNotEmpty) body["companyEmail"] = companyEmail.text.trim();
  //   if (employeeAddress.text.trim().isNotEmpty) body["employeeAddress"] = employeeAddress.text.trim();
  //   if (personalEmail.text.trim().isNotEmpty) body["personalEmail"] = personalEmail.text.trim();
  //   if (personalNumber.text.trim().isNotEmpty) body["personalNumber"] = personalNumber.text.trim();
  //   if (tShirtSize.text.trim().isNotEmpty) body["tShirtSize"] = tShirtSize.text.trim();
  //   if (imageUrl.isNotEmpty) body["photograph"] = convertDriveLink(imageUrl);
  //
  //   bool success = false;
  //
  //   if (isEdit) {
  //     // ✅ UPDATE USER
  //     final userId = widget.userData!["id"];
  //     log(body.toString(), name: "UPDATE USER");
  //
  //     final response = await provider.updateUser(userId, body);
  //
  //     log(response.toString(), name: "UPDATE USER responseresponseresponse");
  //     if (response != null && response["message"] == "User updated successfully") {
  //       success = true;
  //
  //       // Optionally update local provider/user data
  //       final updatedUser = response["user"];
  //       provider.updateLocalUser(updatedUser); // Implement in your provider
  //     }
  //   } else {
  //     // ✅ CREATE USER
  //     log(body.toString(), name: "CREATE USER");
  //     success = await provider.createUser(body);
  //   }
  //
  //   // ✅ Show SnackBar and navigate
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(isEdit ? "User Updated Successfully" : "User Created Successfully"),
  //       ),
  //     );
  //     Navigator.pop(context);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Something went wrong")),
  //     );
  //   }
  // }
  Future<void> submitUser() async {
    final isEdit = widget.userData != null;
    final provider = context.read<UserProvider>();

    // Only validate required fields when creating
    if (!isEdit && !_formKey.currentState!.validate()) return;

    final imageUrl = imageUrlController.text.trim();

    // Validate role and image for create
    if (!isEdit) {
      if (selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select Role")),
        );
        return;
      }

      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter Image URL")),
        );
        return;
      }
    }

    // Build request body dynamically
    final Map<String, dynamic> body = {};

    void addIfNotEmpty(String key, TextEditingController controller) {
      if (controller.text.trim().isNotEmpty) {
        body[key] = controller.text.trim();
      }
    }

    addIfNotEmpty("name", name);
    addIfNotEmpty("fullName", name);
    addIfNotEmpty("email", email);
    // Only include password if creating a new user
    if (!isEdit) addIfNotEmpty("password", password);

    if (selectedRole != null) body["role"] = selectedRole;

    addIfNotEmpty("employeeCode", empCode);
    addIfNotEmpty("designation", designation);
    addIfNotEmpty("department", department);
    addIfNotEmpty("dateOfJoin", doj);
    addIfNotEmpty("dob", dob);
    addIfNotEmpty("bloodGroup", bloodGroup);
    addIfNotEmpty("companyMobile", mobile);
    addIfNotEmpty("emergencyNumber", emergency);
    addIfNotEmpty("companyEmail", companyEmail);
    addIfNotEmpty("employeeAddress", employeeAddress);
    addIfNotEmpty("personalEmail", personalEmail);
    addIfNotEmpty("personalNumber", personalNumber);
    addIfNotEmpty("tShirtSize", tShirtSize);

    if (imageUrl.isNotEmpty) {
      body["photograph"] = convertDriveLink(imageUrl);
    }

    bool success = false;

    if (isEdit) {
      // UPDATE USER via PATCH
      final userId = widget.userData!["userId"];
      // debugPrint("UPDATE USER ${body.toString()}");

      final response = await provider.updateUser(userId, body);

      if (response != null && response["message"] == "User updated successfully") {
        success = true;
        // Update local user data in provider
        provider.updateLocalUser(response["user"]);
      } else {
        // debugPrint("Update Failed: ${response?["message"] ?? "No response"} UPDATE USER");
      }
    } else {
      // CREATE USER via POST
      // debugPrint( "CREATE USER ${body.toString()}");
      success = await provider.createUser(body);
    }

    // Show SnackBar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (isEdit ? "User Updated Successfully" : "User Created Successfully")
              : "Something went wrong",
        ),
      ),
    );

    if (success) Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();

    isEdit = widget.userData != null;

    if (isEdit) {
      final data = widget.userData!;

      name.text = data["fullName"] ?? "";
      email.text = data["email"] ?? "";
      password.text = ""; // usually not prefilled

      selectedRole = data["role"];
      empCode.text = data["employeeCode"] ?? "";
      designation.text = data["designation"] ?? "";
      department.text = data["department"] ?? "";

      doj.text = formatToIST(data["dateOfJoin"]);
      dob.text = formatToIST(data["dob"]);
      bloodGroup.text = data["bloodGroup"] ?? "";

      mobile.text = data["companyMobile"] ?? "";
      emergency.text = data["emergencyNumber"] ?? "";
      companyEmail.text = data["companyEmail"] ?? "";
      employeeAddress.text = data["employeeAddress"] ?? "";
      personalEmail.text = data["personalEmail"] ?? "";
      personalNumber.text = data["personalNumber"] ?? "";
      tShirtSize.text = data["tShirtSize"] ?? "";

      imageUrlController.text = data["photograph"] ?? "";

    }
  }
  String formatToIST(String? utcDate) {
    if (utcDate == null || utcDate.isEmpty) return "";

    try {
      final utc = DateTime.parse(utcDate);

      // Convert to local (IST on Indian devices)
      final ist = utc.toLocal();

      return DateFormat("yyyy-MM-dd").format(ist);
    } catch (e) {
      return "";
    }
  }

  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.width >= 600;
    final provider = context.watch<UserProvider>();
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${provider.name} (${provider.role})"),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            width: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Text(
                                AppString.addUserTitle,
                                style: AppTypography.getTextTheme(context)
                                    .titleMedium
                                    ?.copyWith(
                                  fontSize: isTablet ? 20 : 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 5),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        CommonTextField(
                          title: "Name",
                          controller: name,
                          hint: "John Doe",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Email",
                          controller: email,
                          hint: "test@gmail.com",
                          validator: isEdit ? null : emailValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Password",
                          controller: password,
                          hint: "Jhon@123",
                          suffixIcon: showPassword ? Icons.visibility_off : Icons.visibility,
                          onSuffixTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          obscureText: showPassword,
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        /// ROLE
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text("Role", style: AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 15)),
                            ),
                          ],
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          items: roles.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => selectedRole = val),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary),borderRadius: BorderRadius.all(Radius.circular(8))),
                            labelText: "Select Role",
                            labelStyle: AppTypography.getTextTheme(context).labelMedium?.copyWith(fontWeight: FontWeight.w600,fontSize: 13),
                            visualDensity: VisualDensity(vertical: -1.8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                          ),
                          validator: (val) {
                            if (isEdit) return null;
                            if (val == null) return "Select Role";
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Employee Code",
                          controller: empCode,
                          hint: "EMP001",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Designation",
                          controller: designation,
                          hint: "Software Engineer",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Department",
                          controller: department,
                          hint: "Technology",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        /// DATE
                        GestureDetector(
                          onTap: () => pickDate(doj),
                          child: AbsorbPointer(
                            child: CommonTextField(
                              title: "Date Of Joining",
                              controller: doj,
                              hint: DateFormat.yMd().format(selectedDate),
                              suffixIcon: Icons.calendar_today,
                              validator: isEdit ? null : requiredValidator,
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
                              hint: DateFormat.yMd().format(selectedDate),
                              suffixIcon: Icons.calendar_today,
                              validator: isEdit ? null : requiredValidator,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Blood Group",
                          controller: bloodGroup,
                          hint: "O+",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Company Mobile",
                          controller: mobile,
                          hint: "+9876543210",
                          keyboardType: TextInputType.phone,
                          validator: isEdit ? null : phoneValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Emergency Number",
                          controller: emergency,
                          hint: "Emergency Number",
                          keyboardType: TextInputType.phone,
                          validator: isEdit ? null : phoneValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Company Email",
                          controller: companyEmail,
                          hint: "jhon.doe@company.com",
                          validator: isEdit ? null : emailValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Employee Address",
                          controller: employeeAddress,
                          hint: "123 Main St, Anytown",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Personal Email",
                          controller: personalEmail,
                          hint: "jhon.doe@personal.com",
                          validator: isEdit ? null : emailValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Personal Number",
                          controller: personalNumber,
                          hint: "+9876543210",
                          keyboardType: TextInputType.phone,
                          validator: isEdit ? null : phoneValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "T-Shirt Size",
                          controller: tShirtSize,
                          hint: "L",
                          validator: isEdit ? null : requiredValidator,
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          title: "Photograph URL",
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
                            if(isEdit){
                              return null;
                            }else{
                              if (val == null || val.isEmpty) return "Enter image URL";
                              if (!val.contains("http")) {
                                return "Invalid URL";
                              }
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        /// BUTTON
                        // CustomButton(text: "Add User",width: double.infinity, onPressed: submit,),
                        CustomButton(
                          text: widget.userData == null ? "Add User" : "Update User",
                          width: double.infinity,
                          onPressed: submitUser,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  ///image preview
  // Widget buildImagePreview() {
  //   final url = imageUrlController.text;
  //
  //   if (url.isEmpty) {
  //     return const Icon(Icons.person, size: 60);
  //   }
  //
  //   return Image.network(
  //     url,
  //     height: 80,
  //     width: 80,
  //     fit: BoxFit.cover,
  //     errorBuilder: (context, error, stackTrace) {
  //       return const Icon(Icons.broken_image, size: 60);
  //     },
  //   );
  // }
}