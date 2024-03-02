import 'package:chatty/pages/frames/sign_in/index.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  // Dependency injection
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      () => SignInController(),
    );
  }
}
