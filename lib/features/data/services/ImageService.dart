import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> getImageFromCamera() async {
    XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  Future<String?> getImageFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  Future<String> convertTemporaryPathToPermanent(String tempPath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File tempFile = File(tempPath);
    final File newFile =
        await tempFile.copy('$path/${DateTime.now().toIso8601String()}.png');

    return newFile.path;
  }
}
