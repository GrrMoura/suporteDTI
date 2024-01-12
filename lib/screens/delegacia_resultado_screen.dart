import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/screens/widgets/indicator.dart';
import 'package:suporte_dti/screens/widgets/widget_gridview_itens.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class ResultDelegacia extends StatefulWidget {
  ResultDelegacia({super.key});

  @override
  State<StatefulWidget> createState() => ResultDelegaciaState();
}

class ResultDelegaciaState extends State {
  final List<Map> myProducts2 = List.generate(
      10,
      (index) => {
            "id": index,
            "name": "Produto $index",
          }).toList();

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CAPELA",
              style: Styles()
                  .titleStyle()
                  .copyWith(color: AppColors.cWhiteColor, fontSize: 22.sp)),
          centerTitle: true,
          backgroundColor: AppColors.cSecondaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Indicator(
                        color: AppColors.contentColorBlue,
                        text: 'Monitor',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: AppColors.contentColorYellow,
                        text: 'CPU',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: AppColors.contentColorPurple,
                        text: 'Impressora',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: AppColors.contentColorGreen,
                        text: 'Webcam',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: AppColors.contentColorCyan,
                        text: 'Nobreak',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: AppColors.contentColorPink,
                        text: 'CPU/Servidor',
                        isSquare: true,
                      ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      // Indicator(
                      //   color: AppColors.contentColorRed,
                      //   text: 'Estabilizador',
                      //   isSquare: true,
                      // ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      // Indicator(
                      //   color: AppColors.contentColorBlack,
                      //   text: 'Switch',
                      //   isSquare: true,
                      // ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      // Indicator(
                      //   color: AppColors.contentColorOrange,
                      //   text: 'Scanner',
                      //   isSquare: true,
                      // ),
                      // SizedBox(
                    ],
                  ),
                  const SizedBox(width: 28),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ítens",
                      style:
                          Styles().titleStyle().copyWith(color: Colors.black),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_alt,
                          size: 25.sp,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              GridviewEquipamentos(
                myProducts: myProducts2,
                widget: const CardItensDelegacia(
                  marcaModelo: "HP/Z220 Work Station",
                  lotacao: "Sala do Diretor",
                  patrimonio: "172671",
                ),
              ),
            ],
          ),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            //CPU
            color: AppColors.contentColorYellow,
            value: 6,
            title: '6',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            //MONITOR
            color: AppColors.contentColorBlue,
            value: 5,
            title: '5',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: 1,
            title: '1',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: 5,
            title: '5',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: AppColors.contentColorCyan,
            value: 6,
            title: '6',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: AppColors.contentColorPink,
            value: 1,
            title: '1',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 6:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 7:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        // case 0:
        //   return PieChartSectionData(
        //     color: AppColors.contentColorBlue,
        //     value: 40,
        //     title: '40%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: AppColors.mainTextColor1,
        //       shadows: shadows,
        //     ),
        //   );
        // case 0:
        //   return PieChartSectionData(
        //     color: AppColors.contentColorBlue,
        //     value: 40,
        //     title: '40%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: AppColors.mainTextColor1,
        //       shadows: shadows,
        //     ),
        //   );
        default:
          throw Error();
      }
    });
  }
}

class CardItensDelegacia extends StatefulWidget {
  const CardItensDelegacia(
      {this.lotacao, this.patrimonio, this.marcaModelo, Key? key})
      : super(key: key);

  final String? patrimonio, lotacao, marcaModelo;

  @override
  State<CardItensDelegacia> createState() => _CardItensDelegaciaState();
}

class _CardItensDelegaciaState extends State<CardItensDelegacia> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: widget.patrimonio!));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "copiado para area de transferencia",
              style: Styles().mediumTextStyle(),
            )));
        // copied successfully
      },
      child: Material(
        color: AppColors.cWhiteColor,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.marcaModelo!, style: Styles().smallTextStyle()),
            Image.asset("assets/images/impressora.png", height: 70.h),
            Text(widget.patrimonio!, style: Styles().smallTextStyle()),
            Text(widget.lotacao!, style: Styles().hintTextStyle()),
          ],
        ),
      ),
    );
  }
}
