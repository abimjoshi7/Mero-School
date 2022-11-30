class SystemSettingsResponse {
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  SystemSettingsResponse({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SystemSettingsResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

/// language : "english"
/// system_name : "Mero School"
/// system_title : "Mero School"
/// system_email : "info@mero.school"
/// address : "Tripureshwore, Kathmandu\r\nNepal"
/// phone : "977 1 4101043"
/// youtube_api_key : "AIzaSyBVWn-3qYGmcNRYujIeHlhDS7ePAc4T5SU"
/// vimeo_api_key : "c9a467f1335b7d5662078a3d05795549"
/// slogan : "Education for all."
/// website_description : "Mero School is a online learning platform targeted for Nepalese curriculum.\r\n\r\nA merolagani initiative."
/// version : "4.0"
/// thumbnail : "http://192.168.2.61/meroschool/uploads/system/logo-dark.png"
/// favicon : "http://192.168.2.61/meroschool/uploads/system/favicon.png"

///"hide_smart_gateway": "false",
// "hide_bank_payement": "false",
// "hide_ncell_payment_ios": "false",
// "hide_smart_gateway_andriod": "false",
// "hide_bank_deposite_payment_android": "false",
// "hide_ncell_payment_android": "false",

class Data {
  String? _language;
  String? _systemName;
  String? _systemTitle;
  String? _systemEmail;
  String? _address;
  String? _phone;
  String? _alternatePhone;

  String? _youtubeApiKey;
  String? _vimeoApiKey;
  String? _slogan;
  String? _websiteDescription;
  String? _version;
  String? _thumbnail;
  String? _favicon;

  String? _hidePayment;

  String? _hideSmartGatewayIos;
  String? _hideSmartGatewayAndriod;

  String? _hideBankPaymentIos;
  String? _hideBankPaymentAndroid;

  String? _hideNcellPaymentIos;
  String? _hideNcellPaymentAndroid;

  String? _ios_pay;

  String? _og_url;

  String? _hideCoupon = "true";

  String? _byPassCache = "false";

  String? _paymentMethod;
  String? _hideAffiliate;
  String? _hidePayText;
  String? _youtube;

  String? get hideBankPaymentAndroid => _hideBankPaymentAndroid;

  set hideBankPaymentAndroid(String? value) {
    _hideBankPaymentAndroid = value;
  }

  String? get hidePayment => _hidePayment;

  String? get hideSmartGatewayIos => _hideSmartGatewayIos;

  String? get language => _language;
  String? get systemName => _systemName;
  String? get systemTitle => _systemTitle;
  String? get systemEmail => _systemEmail;
  String? get address => _address;
  String? get phone => _phone;

  String? get alternatePhone => _alternatePhone;

  String? get youtubeApiKey => _youtubeApiKey;
  String? get vimeoApiKey => _vimeoApiKey;
  String? get slogan => _slogan;
  String? get websiteDescription => _websiteDescription;
  String? get version => _version;
  String? get thumbnail => _thumbnail;
  String? get favicon => _favicon;
  String? get iosPay => _ios_pay;

  String? get hideSmartGatewayAndriod => _hideSmartGatewayAndriod;

  String? get hideBankPaymentIos => _hideBankPaymentIos;

  String? get hideBankDepositPaymentAndroid => _hideBankPaymentAndroid;

  String? get hideNcellPaymentIos => _hideNcellPaymentIos;

  String? get hideNcellPaymentAndroid => _hideNcellPaymentAndroid;

  String? get hideCoupon => _hideCoupon;

  String? get byPassCache => _byPassCache;

  String? get paymentMethod => _paymentMethod;

  String? get hideAffiliate => _hideAffiliate;

  String? get hidePayText => _hidePayText;

  String? get youtube => _youtube;

  set hideCoupon(String? value) {
    _hideCoupon = value;
  }

  set byPassCache(String? value) {
    _byPassCache = value;
  }

  Data(
      {String? language,
      String? systemName,
      String? systemTitle,
      String? systemEmail,
      String? address,
      String? phone,
      String? youtubeApiKey,
      String? vimeoApiKey,
      String? slogan,
      String? websiteDescription,
      String? version,
      String? thumbnail,
      String? favicon,
      String? hidePayment,
      String? hideNcellPaymentIos,
      String? hideNcellPaymentAndroid,
      String? hideSmartGatewayIos,
      String? hideSmartGatewayAndroid,
      String? hideBankPaymentIos,
      String? hideBankPaymentAndroid,
      String? iosPay,
      String? hideCoupon,
      String? byPassCache,
      String? paymentMethod,
      String? hideAffiliate,
      String? hidePayText,
      String? hideYoutubeLink}) {
    _language = language;
    _systemName = systemName;
    _systemTitle = systemTitle;
    _systemEmail = systemEmail;
    _address = address;
    _phone = phone;
    _youtubeApiKey = youtubeApiKey;
    _vimeoApiKey = vimeoApiKey;
    _slogan = slogan;
    _websiteDescription = websiteDescription;
    _version = version;
    _thumbnail = thumbnail;
    _favicon = favicon;
    _hidePayment = hidePayment;
    _hideNcellPaymentIos = hideNcellPaymentIos;
    _hideNcellPaymentAndroid = hideNcellPaymentAndroid;
    _hideBankPaymentIos = hideBankPaymentIos;
    _hideBankPaymentAndroid = hideBankPaymentAndroid;
    _hideSmartGatewayIos = hideSmartGatewayIos;
    _hideSmartGatewayAndriod = hideSmartGatewayAndroid;
    _ios_pay = iosPay;
    _hideCoupon = hideCoupon;
    _byPassCache = byPassCache;
    _paymentMethod = paymentMethod;
    _hideAffiliate = hideAffiliate;
    _hidePayText = hidePayText;
    _youtube = hideYoutubeLink;
  }

/////"hide_smart_gateway": "false",
// // "hide_bank_payement": "false",
// // "hide_ncell_payment_ios": "false",
// // "hide_smart_gateway_andriod": "false",
// // "hide_bank_deposite_payment_android": "false",
// // "hide_ncell_payment_android": "false",

  Data.fromJson(dynamic json) {
    _language = json["language"];
    _systemName = json["system_name"];
    _systemTitle = json["system_title"];
    _systemEmail = json["system_email"];
    _address = json["address"];

    _phone = json["phone"];
    _alternatePhone = json["alternate_phone"];

    _youtubeApiKey = json["youtube_api_key"];
    _vimeoApiKey = json["vimeo_api_key"];
    _slogan = json["slogan"];
    _websiteDescription = json["website_description"];
    _version = json["version"];
    _thumbnail = json["thumbnail"];
    _favicon = json["favicon"];
    _hidePayment = json["hide_payment"];
    _hideSmartGatewayIos = json["hide_smart_gateway"];
    _hideSmartGatewayAndriod = json["hide_smart_gateway_andriod"];
    _hideBankPaymentIos = json["hide_bank_payement"];
    _hideBankPaymentAndroid = json["hide_bank_deposite_payment_android"];
    _hideNcellPaymentIos = json["hide_ncell_payment_ios"];
    _hideNcellPaymentAndroid = json["hide_ncell_payment_android"];
    _ios_pay = json["ios_pay"];
    _og_url = json["og_url"];
    _hideCoupon = json["hide_coupon"];
    _byPassCache = json["bypass_cache"];
    _paymentMethod = json["payment_method"];
    _hideAffiliate = json["hide_become_an_affiliate"];
    _hidePayText = json["how_to_pay_text"];
    _youtube = json["how_to_pay_link"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["language"] = _language;
    map["system_name"] = _systemName;
    map["system_title"] = _systemTitle;
    map["system_email"] = _systemEmail;
    map["address"] = _address;

    map["phone"] = _phone;
    map["alternate_phone"] = _alternatePhone;

    map["youtube_api_key"] = _youtubeApiKey;
    map["vimeo_api_key"] = _vimeoApiKey;
    map["slogan"] = _slogan;
    map["website_description"] = _websiteDescription;
    map["version"] = _version;
    map["thumbnail"] = _thumbnail;
    map["favicon"] = _favicon;
    map["hide_payment"] = _hidePayment;
    map["hide_smart_gateway"] = _hideSmartGatewayIos;
    map["hide_smart_gateway_andriod"] = _hideSmartGatewayAndriod;
    map["hide_bank_deposite_payment_android"] = _hideBankPaymentAndroid;
    map["hide_bank_payement"] = _hideNcellPaymentIos;
    map["hide_ncell_payment_ios"] = _hideNcellPaymentAndroid;
    map["hide_ncell_payment_android"] = _hideNcellPaymentAndroid;
    map["ios_pay"] = _ios_pay;
    map["og_url"] = _og_url;
    map["hide_coupon"] = _hideCoupon;
    map["bypass_cache"] = _byPassCache;
    map["payment_method"] = _paymentMethod;
    map["hide_become_an_affiliate"] = _hideAffiliate;
    map["how_to_pay_text"] = _hidePayText;
    map["how_to_pay_link"] = _youtube;

    return map;
  }

  String? get ios_pay => _ios_pay;

  set ios_pay(String? value) {
    _ios_pay = value;
  }

  String? get og_url => _og_url;

  set og_url(String? value) {
    _og_url = value;
  }
}
