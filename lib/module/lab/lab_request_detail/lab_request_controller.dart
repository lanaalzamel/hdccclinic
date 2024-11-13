import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class TypePickerController extends GetxController {
  var selectedType = <String>[].obs;
  var selectedImages = <XFile>[].obs;
  final List<String> requestType = [
    'Zircon',
    'Zirconium over the implant',
    'Veneer',
    'Metal core',
    'Whitening Sheets - Bite Lift',
    'Ceramic on metal',
    'Porcelain over implant',
    'Acrylic devices',
    'Vitalium',
  ];

  void addImage(XFile image) {
    selectedImages.add(image);
  }

  void removeImage(XFile image) {
    selectedImages.remove(image);
  }

  void clearImages() {
    selectedImages.clear();
  }
}
