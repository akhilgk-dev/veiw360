import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/vehicle_info_api.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/model/vehicle_info_model/vehicle_model_info.dart';

class SpecificationPage extends ConsumerWidget {
  final int auctionId;

  SpecificationPage({super.key, required this.auctionId});

  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(auctionId);
    final isArabic = languageController.selectedLanguage.value == 1;
    final data = ref.watch(auctionResponseProviderVehicle(auctionId));

    print("================$data");

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppbarWidget(title: 'Vehicle Details'.tr),
        body: data.when(
          data: (vehicleInfo) =>
              _buildVehicleInfoTable(vehicleInfo, context, isArabic),
          loading: () => const Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(color: darkBlue),
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              '${"Error:".tr} $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleInfoTable(
    VehicleInfoModel vehicleInfo,
    BuildContext context,
    bool isArabic,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return DataTable(
                columnSpacing: 20,
                dataRowMinHeight: 30,
                dataRowMaxHeight: 40,
                border: TableBorder(
                  verticalInside: const BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  horizontalInside: const BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Attribute'.tr,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Value'.tr,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                rows: [
                  _buildDataRow(
                    'Make'.tr,
                    vehicleInfo.make,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Model'.tr,
                    vehicleInfo.model,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Model (AR)'.tr,
                    vehicleInfo.modelAr,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Mileage'.tr,
                    vehicleInfo.mileage,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Mileage (AR)'.tr,
                    vehicleInfo.mileageAr,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Information Number'.tr,
                    vehicleInfo.informationNumber,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Transmission Type'.tr,
                    vehicleInfo.transmissionType,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Transmission Type (AR)'.tr,
                    vehicleInfo.transmissionTypeAr,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Extras'.tr,
                    vehicleInfo.extras,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Body Type'.tr,
                    vehicleInfo.bodyType,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Body Type (AR)'.tr,
                    vehicleInfo.bodyTypeAr,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Fuel Type'.tr,
                    vehicleInfo.fuelType,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Fuel Type (AR)'.tr,
                    vehicleInfo.fuelTypeAr,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Warranty'.tr,
                    vehicleInfo.warranty,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Color'.tr,
                    vehicleInfo.color,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Color (AR)'.tr,
                    vehicleInfo.colorAr,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Engine Size'.tr,
                    vehicleInfo.engineSize,
                    constraints,
                    isArabic,
                  ),
                  _buildDataRow(
                    'Number of Keys'.tr,
                    vehicleInfo.noOfKeys,
                    constraints,
                    isArabic,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    String attribute,
    String? value,
    BoxConstraints constraints,
    bool isArabic,
  ) {
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: constraints.maxWidth * 0.40,
            child: Text(
              attribute.tr,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(color: Colors.black, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: constraints.maxWidth * 0.40,
            child: Text(
              value ?? 'N/A',
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(color: Colors.black, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}
