
import 'package:attendance_system/core/constant/app_color.dart';
import 'package:attendance_system/core/constant/app_typography.dart';
import 'package:attendance_system/provider/dashboard_provider.dart';
import 'package:attendance_system/screen/add_user_screen.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constant/app_string.dart';
import '../core/widget/common_widget.dart';
import '../provider/user_provider.dart';

class TotalUsersDetailScreens extends StatefulWidget {
  const TotalUsersDetailScreens({super.key});

  @override
  State<TotalUsersDetailScreens> createState() => _TotalUsersDetailScreensState();
}

class _TotalUsersDetailScreensState extends State<TotalUsersDetailScreens> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(()async{
      context.read<DashboardProvider>().getTotalUserDetail();
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      provider.initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final userProvider = context.read<UserProvider>();
    final dashBoardProvider = context.read<DashboardProvider>();
    final userList = dashBoardProvider.userDetailList;
      return Container(
        color: AppColors.primary,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                CommonWidget.commonAppBarWidget(context: context, title: "${AppString.loginUserText} ${userProvider.name} (${userProvider.role})"),
                SizedBox(height: 10,),
                IntrinsicHeight(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 14),
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
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Text(
                              AppString.totalEmployeeTitle,
                              style: AppTypography.getTextTheme(context).titleMedium?.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: userList.length,
                //     padding: const EdgeInsets.all(12),
                //     itemBuilder: (context, index) {
                //       final user = userList[index];
                //       return ProfileCard(userData: user);
                //     },
                //   ),
                // ),
                Consumer<DashboardProvider>(
                  builder: (context, provider, _) {
                    return Padding(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 16),
                      child: TextField(
                        onChanged: provider.searchUser,
                        decoration: InputDecoration(
                          hintText: "Search employees...",
                          hintStyle:  AppTypography.getTextTheme(context).bodyMedium?.copyWith(color: Colors.black,fontWeight: FontWeight.w600),
                          prefixIcon: Icon(FeatherIcons.search,size: 22,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        style: AppTypography.getTextTheme(context).bodyMedium?.copyWith(color: Colors.black,fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
                Consumer<DashboardProvider>(
                  builder: (context, provider, _) {
                    return SizedBox(
                      height: 45,
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final cat = provider.categories[index];
                          final isSelected =
                              provider.selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => provider.filterCategory(cat),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey.shade300)
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                cat,
                                style:AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 14,color: isSelected ? Colors.white : Colors.black,)
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 5),

                /// 🔹 List
                Expanded(
                  child: Consumer<DashboardProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(
                            child: CircularProgressIndicator(color: AppColors.primary,));
                      }
                      if (provider.filteredList.isEmpty) {
                        return const Center(
                            child: Text("No users found"));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.filteredList.length,
                        itemBuilder: (context, index) {
                          return ProfileCard(
                            userData: provider.filteredList[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Top Row
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (userData["photograph"] != null &&
                      userData["photograph"].toString().isNotEmpty)
                      ? NetworkImage(userData["photograph"])
                      : null,
                  child: (userData["photograph"] == null ||
                      userData["photograph"].toString().isEmpty)
                      ? const Icon(Icons.person, color: AppColors.primary)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData["fullName"] ?? "",
                          style: AppTypography.getTextTheme(context).titleSmall?.copyWith(fontSize: 16,fontWeight: FontWeight.w400)),
                      SizedBox(height: 5),
                      Text(userData["designation"] ?? "",
                          style: AppTypography.getTextTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddUserScreen(userData: userData),
                      ),
                    );
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      FeatherIcons.edit,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 12),
            /// Info Boxes
            Row(
              children: [
                Expanded(child: _infoBox("Email", userData["companyEmail"],context)),
                const SizedBox(width: 8),
                Expanded(child: _infoBox("Phone", userData["personalNumber"],context)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _infoBox("Department", userData["department"],context)),
                const SizedBox(width: 8),
                Expanded(child: _infoBox("Joined", formatDate(userData["dateOfJoin"]),context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty || date == "null") return "-";
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
    } catch (_) {
      return "-";
    }
  }

  Widget _infoBox(String title, String? value,BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.getTextTheme(context).bodyMedium?.copyWith(fontSize: 13,fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value ?? "-",
              overflow: TextOverflow.ellipsis,
              style:  AppTypography.getTextTheme(context).bodyLarge?.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}