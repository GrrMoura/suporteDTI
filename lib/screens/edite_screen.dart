import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class UpdateScreen extends StatelessWidget {
  UpdateScreen({super.key});

  TextEditingController? patrimonioCTRL,
      cotacaoCTRL,
      tagCTRL,
      modeloCTRL,
      equipamentoCTRL,
      convenioCTRL,
      lacreCTRL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cSecondaryColor,
        title: Text(
          "Atualizar",
          style: Styles().titleStyle().copyWith(
              color: AppColors.cWhiteColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            //TODO: FAZER AQUI
            SizedBox(height: 10),
            FormFieldsUpdateScreen(
                label: "Patrimônio", inputType: TextInputType.number),
            FormFieldsUpdateScreen(label: "TAG"),
            FormFieldsUpdateScreen(label: "Marca/Modelo"),
            FormFieldsUpdateScreen(label: "Equipamento"),
            FormFieldsUpdateScreen(label: "Convênio"),
            FormFieldsUpdateScreen(
                label: "Lacre", inputType: TextInputType.number),
            FormFieldsUpdateScreen(label: "Lotação"),
            FormFieldsUpdateScreen(label: "Setor"),
          ],
        ),
      ),
    );
  }
}

class FormFieldsUpdateScreen extends StatelessWidget {
  const FormFieldsUpdateScreen(
      {super.key, required this.label, this.formatter, this.inputType});

  final String label;
  final TextInputFormatter? formatter;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      child: TextFormField(
        onChanged: (newValue) {},
        style: TextStyle(fontSize: 15.sp),
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(0.1),
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          errorStyle: TextStyle(fontSize: 10.sp),
          label: Text(label),
          hintStyle: TextStyle(fontSize: 12.sp),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
