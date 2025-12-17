import 'dart:io';
import 'package:get/get.dart';

class FilesUploadGetX extends GetxController {
  final Rx<File?> attachAuthorityID = Rx<File?>(null);
  final Rx<File?> attachIDNumber = Rx<File?>(null);
  final Rx<File?> attachCRNumber = Rx<File?>(null);
  final Rx<File?> attachVATNumber = Rx<File?>(null);

  final Rx<File?> attachIDFront = Rx<File?>(null);

  final Rx<File?> uploadRecieptforBankTransfer = Rx<File?>(null);
  final Rx<File?> uploadRecieptforWalletAddFund = Rx<File?>(null);
  // final Rx<File?> identificationPDF = Rx<File?>(null);
  // RxList<XFile> identificationMorePDF = RxList<XFile>();
  //   RxList<XFile> certificateMorePDF = RxList<XFile>();
}
