class PhoneUtils {
  static String formatPhoneNumber(String phoneNumber,
      {String countryCode = '+82'}) {
    // 전화번호에서 특수문자 제거
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // 국가 코드 뒤에는 0으로 시작하지 않아야 함 (E.164 규칙)
    final trimmedNumber = cleanedNumber.startsWith('0')
        ? cleanedNumber.substring(1)
        : cleanedNumber;

    // 국가 코드가 이미 포함된 경우 반환
    if (trimmedNumber.startsWith(countryCode.replaceAll('+', ''))) {
      return '+$trimmedNumber';
    }

    // 국가 코드를 붙여 반환
    return '$countryCode$trimmedNumber';
  }
}
