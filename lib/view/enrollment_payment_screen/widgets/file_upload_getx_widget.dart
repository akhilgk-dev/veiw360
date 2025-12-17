import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';

class FileUploadFielMethod extends StatelessWidget {
  const FileUploadFielMethod({
    super.key,
    required this.label,
    required this.ontap,
    required this.fileName,
  });

  final String label;
  final VoidCallback ontap;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0), // Consistent padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12), // Adjusted spacing
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600, // Slightly bolder font
              color: Colors.black87, // Darker text color for better contrast
            ),
          ),
          const SizedBox(height: 6), // Adjusted spacing
          Container(
            height: 50, // Slightly taller for better usability
            decoration: BoxDecoration(
              color: Colors.grey[200], // Softer background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Subtle shadow
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppStyle.secondColor, // Vibrant button color
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: ontap,
                    icon: const Icon(
                      CupertinoIcons.cloud_upload,
                      size: 18,
                      color: Colors.white, // White icon for better contrast
                    ),
                    label: Text(
                      "Select File".tr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white, // White text for better contrast
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // Adjusted spacing
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          Colors.black87, // Darker text for better readability
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12), // Adjusted spacing
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppStyle.lightGray, // Vibrant preview color
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, // Subtle shadow
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(CupertinoIcons.doc, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Adjusted spacing
        ],
      ),
    );
  }
}
