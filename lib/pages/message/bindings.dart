import 'package:chatty/pages/message/controller.dart';
import 'package:get/get.dart';

class MessageBinding implements Bindings {
  // Dependency injection
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(
      () => MessageController(),
    );
  }
}
