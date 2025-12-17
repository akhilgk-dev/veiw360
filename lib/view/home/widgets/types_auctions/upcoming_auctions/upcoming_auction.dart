import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:view360/api/bidding_list/bidding_list_api.dart';
import 'package:view360/api/upcoming_auctions/upcoming_auctions_api.dart';
import 'package:view360/common/text/text_static.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/model/upcoming_auctions/upcoming_auctions_model.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/enrollment_payment_screen/registration_for_bidders.dart';
import 'package:view360/view/bidding_list/bidding_list.dart';
import 'package:view360/view/home/home_page.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:view360/view/widgets/empty_message/empty_message_widget.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api/profile_details_api/profile_details_api.dart';
import '../../../../../common/utils/helpers/snackbar.dart';
import '../../../controller/count_down.dart';

class UpcomingAuction extends ConsumerWidget {
  UpcomingAuction({super.key});

  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    tokenCheckingState.checkToken();
    //  final favorites = ref.watch(favoritesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 600 ? 27.0 : 10.0;
    final AsyncValue<UpcomingAuctionResponse> activity = ref.watch(
      auctionResponseProviderUpcoming,
    );
    final profileData = ref.watch(auctionResponseProviderProfile);
    final LanguageController languageController = Get.find();

    return activity.when(
      loading: () => const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      ),
      error: (error, stackTrace) => Center(child: Image.asset(noInternetImage)),
      data: (auctionResponse) {
        final filteredAuctions = auctionResponse.auctionData!.where((auction) {
          final title = auction.groupName?.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();
          return title.contains(query);
        }).toList();

        if (filteredAuctions.isEmpty || filteredAuctions.isNotEmpty) {
          return EmptyMessageWidget(
            message: 'No Auctions Available right now'.tr,
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: auctionResponse.auctionData!.length,
          itemBuilder: (context, index) {
            //  final favorites = ref.watch(favoritesProvider);
            //  final isFavorite = favorites.contains(index);
            final auction = auctionResponse.auctionData![index];
            final regStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
              "${auction.regStartDateAr!.date} ${auction.regStartDateAr!.time}",
            );

            final regEnd = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
              "${auction.regEndDateAr!.date} ${auction.regEndDateAr!.time}",
            );

            final auctionStart = DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
              "${auction.startDateAr!.date} ${auction.startDateAr!.time}",
            );

            final auctionEnd = DateFormat(
              "dd/MM/yyyy hh:mm:ss a",
            ).parse("${auction.endDateAr!.date} ${auction.endDateAr!.time}");

            final countdown = ref.watch(
              countdownProvider((regStart, regEnd, auctionStart, auctionEnd)),
            );
            // final countdown = ref.watch(countdownProvider(
            //     DateFormat("dd/MM/yyyy hh:mm:ss a").parse(
            //         "${auction.regEndDateAr!.date} ${auction.regEndDateAr!.time}")));

            //
            final data = tokenCheckingState.token.value == ''
                ? ref.watch(
                    auctionResponseGroupGuest(auction.groupInfo?.id ?? 0),
                  )
                : ref.watch(auctionResponseGroup(auction.groupInfo?.id ?? 0));

            return Center(
              child: Card(
                elevation: 5,
                semanticContainer: true,
                shadowColor: Color(0x802196F3),
                borderOnForeground: true,
                child: Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Image Section
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: auction.isAGroup == true
                                  ? auction.groupImage.toString()
                                  : auction.mainImage.toString(),
                              width: screenWidth * 0.40,
                              height: screenWidth * 0.35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          // Positioned(
                          //     right: 10,
                          //     bottom: 10,
                          //     child: CircleAvatar(
                          //       backgroundColor: white,
                          //       radius: 15,
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(5),
                          //         child: CachedNetworkImage(
                          //             imageUrl:
                          //                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThHxSRSjwXZTqBVsEiZ4tLwMDAGA0yE8KKXQ&s'),
                          //       ),
                          //     )),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Text Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: auction.isAGroup == true
                                    ? auction.groupInfo!.groupName.toString()
                                    : auction.title.toString(),
                                style: TextStyle(
                                  color: darkBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: auction.auctionNumber,
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10, child: VerticalDivider()),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '${auction.groupInfo!.startAmount ?? 'N/A'} OMR',
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.timer, size: 12),
                                SizedBox(width: 3),
                                RichText(
                                  text: TextSpan(
                                    text: countdown,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            height05,
                            RichText(
                              text: TextSpan(
                                text:
                                    'Guarantee amount: ${auction.groupInfo!.visitAmount} OMR',
                                style: TextStyle(fontSize: 12, color: black),
                              ),
                            ),
                            height05,
                            // RichText(
                            //   text: TextSpan(
                            //     text: 'Visit/Amt: 500 OMR',
                            //     style: TextStyle(
                            //       fontSize: 12,
                            //       color: black,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 8),

                            //* enroll if it is a group or individual--------------
                            Row(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      final useridEmailverifiedAt = profileData
                                          .asData!
                                          .value
                                          .data
                                          .emailVerifiedAt;
                                      final useridphoneverifiedAt = profileData
                                          .asData!
                                          .value
                                          .data
                                          .mobileVerifiedAt;
                                      if (useridEmailverifiedAt == null ||
                                          useridphoneverifiedAt == null) {
                                        diologueBox();
                                        return;
                                      }

                                      if (auction.statusLabel!.status == 'A' ||
                                          auction.statusLabel!.status == 'U') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RegistrationForBidders(
                                              auctionNumber:
                                                  data.value['data'][index]['auction_number'] ??
                                                  'N/A',
                                              auctionName:
                                                  languageController
                                                          .selectedLanguage
                                                          .value ==
                                                      1
                                                  ? auction.titleAr
                                                  : data.value['data'][index]['title'] ??
                                                        'N/A',
                                              filePaymentterms:
                                                  auction.filePaymentTerms,
                                              auctionID: data
                                                  .value['data'][index]['id'],
                                              guranteeAmount:
                                                  data.value['data'][index]['payment_amount'] ??
                                                  0,
                                              paymentTypes: [
                                                data.value['data'][index]['group_info']?['can_online'] ??
                                                    true,
                                                data.value['data'][index]['group_info']?['can_wallet'] ??
                                                    true,
                                                data.value['data'][index]['group_info']?['can_offline'] ??
                                                    true,
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (auction.status == 'E') {
                                          SnackbarHelper.showSnackBar(
                                            context,
                                            'Auction is completed',
                                            color: Colors.red,
                                          );
                                        } else {
                                          SnackbarHelper.showSnackBar(
                                            context,
                                            'Registration closed',
                                            color: Colors.red,
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: yelloAccent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.menu,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Enroll',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                width05,
                                Expanded(
                                  flex: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      final token = prefs.getString('token');

                                      if (auction.isAGroup == true) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BiddingList(
                                              whichPage: 'upcoming',
                                              groupName: auction.groupName
                                                  .toString(),
                                              groupId: auction.groupInfo!.id
                                                  .toString(),
                                              check: 'true',
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AuctionDetailsPage(
                                                  index: index,
                                                  token: token ?? '',
                                                  auctionId: auction.id,
                                                  imageUrl:
                                                      auction.images ?? [],
                                                  mainImage:
                                                      auction.groupImage
                                                          ?.toString() ??
                                                      'N/A',
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            auction.isAGroup == true
                                                ? 'List Auctions'
                                                : 'View details',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            height10,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

//
