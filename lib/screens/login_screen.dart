import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/navegacao/app_screens_string.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController loginController = TextEditingController();

  TextEditingController passController = TextEditingController();

  var isShowPass = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppColors.cPrimaryColor,
        body: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  Positioned(
                      key: const Key("telaAzul"),
                      top: 0,
                      bottom: 370.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 250.h,
                        decoration: const BoxDecoration(
                            color: AppColors.cSecondaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(65),
                                bottomRight: Radius.circular(65))),
                      )),
                  Positioned(
                      top: 10.h,
                      bottom: 380.h,
                      left: 0,
                      right: 0,
                      key: const Key("logo"),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          "assets/images/logo_azul.png",
                          height: 350.h,
                        ),
                      )),
                  Positioned(
                      key: const Key("credenciais"),
                      top: 270.h,
                      bottom: 10.h,
                      left: 30.w,
                      right: 30.w,
                      child: ListView(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.cWhiteColor,
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                emailTextfield(),
                                passwordTextfield(),
                                recoverPassword()
                              ],
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                      key: const Key("botaoEntrar"),
                      top: 580.h,
                      bottom: 60.h,
                      left: 60.w,
                      right: 60.w,
                      child: bottonEnter(context)),
                ],
              ),
            ),
          ),
        ));
  }

  ElevatedButton bottonEnter(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        validateUserAndSenhaTextfield(
            loginController.text, passController.text);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cSecondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size(300.w, 50.h),
        elevation: 10,
        side: const BorderSide(),
      ),
      child: Text("Entrar",
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.cPrimaryColor,
          )),
    );
  }

  Padding recoverPassword() {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, top: 20.h, bottom: 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Recuperar senha?",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.cSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Column passwordTextfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 5.h),
          child: Text(
            "Senha",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        SizedBox(
          width: 230.w,
          child: TextFormField(
            onChanged: (newValue) {
              passController.text = newValue;
            },
            style: TextStyle(fontSize: 15.sp),
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              errorStyle: TextStyle(fontSize: 10.sp),
              suffixIcon: Icon(Icons.remove_red_eye, size: 18.sp),
              prefixIcon: Icon(
                Icons.lock,
                size: 18.sp,
              ),
              hintText: "********",
              hintStyle: TextStyle(fontSize: 12.sp),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column emailTextfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 20.h, bottom: 5.h),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        SizedBox(
          width: 230.w,
          child: TextFormField(
            style: TextStyle(fontSize: 14.sp),
            onChanged: (newValue) {
              loginController.text = newValue;
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.lock,
                size: 18.sp,
                color: Colors.transparent,
              ),
              hintText: "111.222.333-44",
              hintStyle: TextStyle(fontSize: 12.sp),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  validateUserAndSenhaTextfield(String loginController, String passController) {
    if (loginController.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              'O campo "Login" precisa ser preenchidoa',
              style: Styles().errorTextStyle(),
            ),
            backgroundColor: AppColors.cErrorColor),
      );
    }
    if (passController.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              'O campo "senha" precisa ser preenchido',
              style: Styles().errorTextStyle(),
            ),
            backgroundColor: AppColors.cErrorColor),
      );
    } else if (passController.length < 8) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'O campo "senha" está muito curto!',
            style: Styles().errorTextStyle(),
          ),
          backgroundColor: AppColors.cErrorColor));
    } else {
      context.go(AppRouterName.homeController);
    }
  }
}
