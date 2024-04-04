import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridviewEquipamentos extends StatelessWidget {
  const GridviewEquipamentos({
    super.key,
    required this.myProducts,
    required this.widget,
  });
  final Widget widget;

  final List<Map> myProducts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: 
      
      GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 220,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20),
          itemCount: myProducts.length,
          itemBuilder: (BuildContext ctx, index) {
            return widget;
          }),
    );
  }
}
