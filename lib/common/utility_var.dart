class UtilityVar {
  static String genCurrency = 'AED';

  static String genLanguage = 'ar';

  static String userToken = '';

  static final UtilityVar _inst = UtilityVar._internal();

  UtilityVar._internal();

  static String localizeCurrency({required String val}) {
    if (genLanguage.toLowerCase() == 'en') {
      return val;
    } else {
      switch (val.toLowerCase()) {
        case "aed":
          {
            return "درهم";
          }
        case "usd":
          {
            return "دولار";
          }
        case "sar":
          {
            return "ر.س";
          }
        case "eur":
          {
            return "يورو";
          }
        case "gbp":
          {
            return "ج.إ";
          }
        case "qar":
          {
            return "ر.ق";
          }
        case "kwd":
          {
            return "د.ك";
          }
        case "omr":
          {
            return "ر.ع";
          }
        case "inr":
          {
            return "روبيه";
          }
        default:
          {
            return val;
          }
      }
    }
  }

  factory UtilityVar() {
    return _inst;
  }
}
