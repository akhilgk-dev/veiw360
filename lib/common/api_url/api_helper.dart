// final baseUrl = 'https://rop.mzadcom.om/services/public/api';
// final baseUrlMini = 'https://rop.mzadcom.om';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BASE_URL']!;
//'https://mzadcom.om/services/public/api';
final baseUrlMini = 'https://mzadcom.om';
final thawaniAPIKey = dotenv.env['THAWANI_API_KEY']!;
final thawaniBaseUrl = dotenv.env['THAWANI_BASE_URL'];
final thawaniPublicKey = dotenv.env['THAWANI_PUBLIC_KEY']!;
//-----------------------------
//registration endpoints
final endpointInstitution = '/register';
final endpointIndividual = '/register';
final endpointForgotPassword = '/forgot_password';
final loginEndpoint = '/v2/auth/login';
final activeAuctionEndpoint = '/active/auctions';
final activeloggedAuction = '/logged_active/auctions';
final upcomingAuctionEndPoint = '/upcoming/auctions';
final pdoLogged = '/logged_direct/auctions';
final pdoUnlogged = '/direct/auctions';
//adding filter for debugg
final previousAuctionEndPoint = '/logged_previous/auctions';
final previousAuctions = '/previous/auctions?limit=25';
final favouriteAuctionEndPoint = '/auc_liked';
final endpointSendOtp = '/send/otp';
final endpointValidateOtp = '/validate/otp';
final allAuctionEndpoint = '/all_auctions?limit=50';
final categoryListEndPoint = '/active_categories?active=1';
final departmentListEndPoint = '/get_departments';
final locationEndpoint = '/get_locations';
final profileEndpoint = '/profile';
final walletEndpoint = '/wallet_transaction';
final emailOtpEndpoint = '/send_otp/email';
final emailValidateOtpEndpoint = '/verify_otp_creds';
final phonenumberVerificationSmsEndpoint = '/send_otp/sms';
final phonenumberVerificationOtpEndpoint = '/verify_otp_creds';
final typesAuctionCountEndpoint = '/auctions_chart_data/main';
final servertimeEndPoint = '/server-time';
final trackingEndPoint = '/auctions_tracking';
final whatchListEndpoint = '/auc_wishlisted';
final winnigListEndPoint = '/winning_list';
final myBidsEndPoint = '/v2/auctions/my-bids';
final enrolledAuctionEndPoint = '/enrolled/auctions?limit=50';
final signUpCommonEndPoint = '/v2/auth/register';
final mzadcomPayment = '/v2/auctions/winning';
final mzadWalletPayment = '/v2/auction-payment';
final auctionTracking = '/v2/auctions/tracking/';
final winningBidsEndpoint = '/v2/auctions/winning/';
final approvalPendingListEndpoint = '/v2/auction-payment';
final bannersEndpoint = '/banners';

//mzadcom dashboard
final mzadOverView = '/v2/management/auctions/overview';
final mzadProjectAndVAT = '/m-dashboard-summary';
final clientsList = "/organizations/list?";

//enroll------

final enrollBankTransferEndpoint = '/enroll_user';

//toglle like

final toggleLikeendpoint = '/toggle_like';

//top bidders

final topBiddersEndpoint = '/get_top_bidders';

//live bid

final userBidEndpoint = '/bid_now';

//uservalidity check

final userValidityCheckEndpoint = '/check_user_validity';

//update payment

final updatePaymentStatusEndpoint = '/update_payment';
