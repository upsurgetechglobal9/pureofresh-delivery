import 'package:uuid/uuid.dart';

/// Generates a truncated integer from a UUID.
///
/// This function extracts the numeric part of a UUID, truncates it to 10 digits if necessary,
/// converts it to an integer, and ensures it does not exceed the maximum value for a signed 32-bit integer.
int generateSSID() {
  var uuid = Uuid();
  String numericPart = uuid.v4().replaceAll(RegExp(r'[^0-9]'), '');
  String truncatedNumericPart =
      numericPart.length > 10 ? numericPart.substring(0, 10) : numericPart;
  int ssidInt = int.tryParse(truncatedNumericPart) ?? 0;
  return ssidInt % 2147483647; // Ensure it fits within the 32-bit signed integer range
}
