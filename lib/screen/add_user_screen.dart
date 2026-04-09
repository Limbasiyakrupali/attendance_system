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
  String? selectedRole;
  final roles = ["ADMIN", "HR", "EMPLOYEE", "TRAINEE", "FREELANCER"];

  DateTime selectedDate = DateTime.now();
  File? imageFile;
  late final bool isEdit;
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
  /// Date Picker
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
  /// Submit
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

}