// from mzadcom home, Listing clients and projects

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/mzadcom/client_list/client_list.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class EnrolledListingScreen extends StatefulWidget {
  const EnrolledListingScreen({super.key, this.title = 'Enrolled Listings'});
  final String? title;

  @override
  State<EnrolledListingScreen> createState() => _EnrolledListingScreenState();
}

class _EnrolledListingScreenState extends State<EnrolledListingScreen> {
  final clientListController = Get.put(ClientList());
  @override
  void initState() {
    clientListController.fetchClientList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: widget.title!),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                if (clientListController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (clientListController.clientData.isEmpty) {
                  return Center(child: Text('No enrolled listings found.'));
                }
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: clientListController.clientData.map((client) {
                    return Container(
                      width: 120.0,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 40.0,
                            backgroundImage: NetworkImage(
                              client.organizationImageUrl,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            client.organizationName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(
                  20,
                  (index) => Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Enrolled Item ${index + 1}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
