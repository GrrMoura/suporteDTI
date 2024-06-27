import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/utils/app_colors.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final BuildContext context;

  const GenericAppBar({super.key, this.bottom, required this.context});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.cSecondaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                context.pop("value");
              },
              icon: const Icon(Icons.arrow_back_ios)),
          const Text(""),
          IconButton(
              onPressed: () {
                context.push(AppRouterName.homeController);
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null
      ? kToolbarHeight
      : kToolbarHeight + bottom!.preferredSize.height);
}
