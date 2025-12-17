import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageGetX extends GetxController {
  final ImagePicker _picker = ImagePicker();

  //Galleryyy
  Future<void> pickImage(Rx<File?> selectedImage) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

//camera
  Future<void> pickCameraImage(Rx<File?> selectedImage) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  //Multiimage
  void pickMultipleImages(List<XFile>? imageFileList) async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
  }

//pick one pdf
  Future<void> pickPdf(Rx<File?> pdfDoc) async {
    final pickedFile = await _picker.pickMedia();
    if (pickedFile != null) {
      pdfDoc.value = File(pickedFile.path);
    }
  }

  //pick multiple pdf
  void pickMultiplePDF(List<XFile>? pdfFileList) async {
    final List<XFile> selectedImages = await _picker.pickMultipleMedia();
    if (selectedImages.isNotEmpty) {
      pdfFileList!.addAll(selectedImages);
    }
  }
}
