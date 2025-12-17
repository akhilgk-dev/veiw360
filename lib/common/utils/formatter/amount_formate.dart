import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

class AmountFormate {
  String currencyFormat(String amount) {
    final number = double.tryParse(amount) ?? 0;

    final formatter = NumberFormat("#,###");

    return formatter.format(number);
  }

  String withDecimal(String amount) {
    final number = double.tryParse(amount) ?? 0;

    final formatter = NumberFormat("#,##0.0");

    return formatter.format(number);
  }
}

DateTime parseBackendTime(String date) {
  // Pattern of backend date
  final format = intl.DateFormat("yyyy-MM-dd HH:mm:ss");

  // Parse without timezone (Flutter treats as local)
  final parsed = format.parse(date);

  // Convert parsed "local" time to a DateTime with Oman timezone (UTC+4)
  final omTime = DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour - 4, // <- adjust backend local time to UTC
    parsed.minute,
    parsed.second,
  );

  // Convert UTC → user's local time (correct for viewing)
  return omTime.toLocal();
}
