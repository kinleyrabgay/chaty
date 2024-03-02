import 'package:chatty/common/style/style.dart';
import 'package:chatty/pages/frames/welcome/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  Widget _buildPageHeadTitle(String title) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(Get.context!).size.height * 0.4,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 46.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryBackground,
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 1.0.w,
        height: MediaQuery.of(context).size.height * 1.0.h,
        child: _buildPageHeadTitle(controller.title),
      ),
    );
  }
}
