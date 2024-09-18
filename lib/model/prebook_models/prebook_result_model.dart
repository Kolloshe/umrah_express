//final prebookResultModel = prebookResultModelFromJson(jsonString);

import 'dart:convert';

PrebookResultModel prebookResultModelFromJson(String str) =>
    PrebookResultModel.fromJson(json.decode(str));

String prebookResultModelToJson(PrebookResultModel data) => json.encode(data.toJson());

class PrebookResultModel {
  final num? code;
  final bool? error;
  final String? message;
  final Data? data;

  PrebookResultModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory PrebookResultModel.fromJson(Map<String, dynamic> json) => PrebookResultModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final String? customizeId;
  Payment? payment;
  final UserCredits? userCredits;
  final DataDetails? details;
  final Holder? holder;
  final List<Map<String, String?>>? passengers;
  final SpecialRequest? specialRequest;
  final List<dynamic>? selectedSpecialRequests;
  final String? specialRequestComment;
  final bool? prebooked;
  final PrebookDetails? prebookDetails;

  Data({
    this.customizeId,
    this.payment,
    this.userCredits,
    this.details,
    this.holder,
    this.passengers,
    this.specialRequest,
    this.selectedSpecialRequests,
    this.specialRequestComment,
    this.prebooked,
    this.prebookDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        customizeId: json["customizeId"],
        payment: json["payment"] == null ? null : Payment.fromMap(json["payment"]),
        userCredits:
            json["user_credits"] == null ? null : UserCredits.fromMap(json["user_credits"]),
        details: json["details"] == null ? null : DataDetails.fromJson(json["details"]),
        holder: json["holder"] == null ? null : Holder.fromJson(json["holder"]),
        passengers: json["passengers"] == null
            ? []
            : List<Map<String, String?>>.from(json["passengers"]!
                .map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
        specialRequest:
            json["specialRequest"] == null ? null : SpecialRequest.fromJson(json["specialRequest"]),
        selectedSpecialRequests: json["selectedSpecialRequests"] == null
            ? []
            : List<dynamic>.from(json["selectedSpecialRequests"]!.map((x) => x)),
        specialRequestComment: json["specialRequestComment"],
        prebooked: json["prebooked"],
        prebookDetails: json["prebook_details"] == null
            ? null
            : PrebookDetails.fromJson(json["prebook_details"]),
      );

  Map<String, dynamic> toJson() => {
        "customizeId": customizeId,
        "payment": payment,
        "user_credits": userCredits,
        "details": details?.toJson(),
        "holder": holder?.toJson(),
        "passengers": passengers == null
            ? []
            : List<dynamic>.from(
                passengers!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "specialRequest": specialRequest?.toJson(),
        "selectedSpecialRequests": selectedSpecialRequests == null
            ? []
            : List<dynamic>.from(selectedSpecialRequests!.map((x) => x)),
        "specialRequestComment": specialRequestComment,
        "prebooked": prebooked,
        "prebook_details": prebookDetails?.toJson(),
      };
}

class UserCredits {
  UserCredits({
    required this.creditCurrency,
    required this.creditExisting,
    required this.creditCanBeUsed,
    required this.creditBalanceAfterUsage,
  });

  String creditCurrency;
  String creditExisting;
  String creditCanBeUsed;
  String creditBalanceAfterUsage;

  factory UserCredits.fromMap(Map<String, dynamic> json) => UserCredits(
        creditCurrency: json["credit_currency"],
        creditExisting: json["credit_existing"],
        creditCanBeUsed: json["credit_can_be_used"],
        creditBalanceAfterUsage: json["credit_balance_after_usage"],
      );

  Map<String, dynamic> toMap() => {
        "credit_currency": creditCurrency,
        "credit_existing": creditExisting,
        "credit_can_be_used": creditCanBeUsed,
        "credit_balance_after_usage": creditBalanceAfterUsage,
      };
}

class DataDetails {
  final String? packageName;
  final num? packageDays;
  final DateTime? packageStart;
  final DateTime? packageEnd;
  final Flight? flight;
  final num? totalAmount;
  final List<Hotel>? hotel;
  final List<Transfer>? transfer;
  final DetailsActivities? activities;
  final DetailsEsim? esim;
  final num? adultsCount;
  final num? childrenCount;
  final num? infantsCount;
  final bool? noFlights;
  final bool? noHotels;
  final bool? noTransfers;
  final bool? noActivities;
  final bool? noEsim;

  DataDetails({
    this.packageName,
    this.packageDays,
    this.packageStart,
    this.packageEnd,
    this.flight,
    this.totalAmount,
    this.hotel,
    this.transfer,
    this.activities,
    this.esim,
    this.adultsCount,
    this.childrenCount,
    this.infantsCount,
    this.noFlights,
    this.noHotels,
    this.noTransfers,
    this.noActivities,
    this.noEsim,
  });

  factory DataDetails.fromJson(Map<String, dynamic> json) => DataDetails(
        packageName: json["package_name"],
        packageDays: json["package_days"],
        packageStart: json["package_start"] == null ? null : DateTime.parse(json["package_start"]),
        packageEnd: json["package_end"] == null ? null : DateTime.parse(json["package_end"]),
        flight: json["flight"] == null ? null : Flight.fromJson(json["flight"]),
        totalAmount: json["total_amount"],
        hotel: json["hotel"] == null
            ? []
            : List<Hotel>.from(json["hotel"]!.map((x) => Hotel.fromJson(x))),
        transfer: json["transfer"] == null
            ? []
            : List<Transfer>.from(json["transfer"]!.map((x) => Transfer.fromJson(x))),
        activities:
            json["activities"] == null ? null : DetailsActivities.fromJson(json["activities"]),
        esim: json["esim"] == null ? null : DetailsEsim.fromJson(json["esim"]),
        adultsCount: json["adults_count"],
        childrenCount: json["children_count"],
        infantsCount: json["infants_count"],
        noFlights: json["no_flights"],
        noHotels: json["no_hotels"],
        noTransfers: json["no_transfers"],
        noActivities: json["no_activities"],
        noEsim: json["no_esim"],
      );

  Map<String, dynamic> toJson() => {
        "package_name": packageName,
        "package_days": packageDays,
        "package_start":
            "${packageStart!.year.toString().padLeft(4, '0')}-${packageStart!.month.toString().padLeft(2, '0')}-${packageStart!.day.toString().padLeft(2, '0')}",
        "package_end":
            "${packageEnd!.year.toString().padLeft(4, '0')}-${packageEnd!.month.toString().padLeft(2, '0')}-${packageEnd!.day.toString().padLeft(2, '0')}",
        "flight": flight?.toJson(),
        "total_amount": totalAmount,
        "hotel": hotel == null ? [] : List<dynamic>.from(hotel!.map((x) => x.toJson())),
        "transfer": transfer == null ? [] : List<dynamic>.from(transfer!.map((x) => x.toJson())),
        "activities": activities?.toJson(),
        "esim": esim?.toJson(),
        "adults_count": adultsCount,
        "children_count": childrenCount,
        "infants_count": infantsCount,
        "no_flights": noFlights,
        "no_hotels": noHotels,
        "no_transfers": noTransfers,
        "no_activities": noActivities,
        "no_esim": noEsim,
      };
}

class DetailsActivities {
  final List<String>? name;

  DetailsActivities({
    this.name,
  });

  factory DetailsActivities.fromJson(Map<String, dynamic> json) => DetailsActivities(
        name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
      };
}

class DetailsEsim {
  final String? name;
  final String? description;
  final num? dataAmount;
  final List<String>? speed;
  final bool? autostart;
  final String? imageUrl;
  final List<String>? group;
  final String? sellingCurrency;
  final String? supplierCurrency;
  final double? payableAmount;
  final num? sellingAmount;
  final String? duration;
  final CountryDetails? countryDetails;
  final dynamic roamingEnabled;

  DetailsEsim({
    this.name,
    this.description,
    this.dataAmount,
    this.speed,
    this.autostart,
    this.imageUrl,
    this.group,
    this.sellingCurrency,
    this.supplierCurrency,
    this.payableAmount,
    this.sellingAmount,
    this.duration,
    this.countryDetails,
    this.roamingEnabled,
  });

  factory DetailsEsim.fromJson(Map<String, dynamic> json) => DetailsEsim(
        name: json["name"],
        description: json["description"],
        dataAmount: json["dataAmount"],
        speed: json["speed"] == null ? [] : List<String>.from(json["speed"]!.map((x) => x)),
        autostart: json["autostart"],
        imageUrl: json["imageUrl"],
        group: json["group"] == null ? [] : List<String>.from(json["group"]!.map((x) => x)),
        sellingCurrency: json["sellingCurrency"],
        supplierCurrency: json["supplierCurrency"],
        payableAmount: json["payableAmount"]?.toDouble(),
        sellingAmount: json["sellingAmount"],
        duration: json["duration"],
        countryDetails:
            json["countryDetails"] == null ? null : CountryDetails.fromJson(json["countryDetails"]),
        roamingEnabled: json["roamingEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "dataAmount": dataAmount,
        "speed": speed == null ? [] : List<dynamic>.from(speed!.map((x) => x)),
        "autostart": autostart,
        "imageUrl": imageUrl,
        "group": group == null ? [] : List<dynamic>.from(group!.map((x) => x)),
        "sellingCurrency": sellingCurrency,
        "supplierCurrency": supplierCurrency,
        "payableAmount": payableAmount,
        "sellingAmount": sellingAmount,
        "duration": duration,
        "countryDetails": countryDetails?.toJson(),
        "roamingEnabled": roamingEnabled,
      };
}

class CountryDetails {
  final String? countryName;
  final num? networkCount;
  final List<Network>? networks;

  CountryDetails({
    this.countryName,
    this.networkCount,
    this.networks,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) => CountryDetails(
        countryName: json["countryName"],
        networkCount: json["networkCount"],
        networks: json["networks"] == null
            ? []
            : List<Network>.from(json["networks"]!.map((x) => Network.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countryName": countryName,
        "networkCount": networkCount,
        "networks": networks == null ? [] : List<dynamic>.from(networks!.map((x) => x.toJson())),
      };
}

class Network {
  final String? name;
  final String? brandName;
  final List<String>? speeds;

  Network({
    this.name,
    this.brandName,
    this.speeds,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        name: json["name"],
        brandName: json["brandName"],
        speeds: json["speeds"] == null ? [] : List<String>.from(json["speeds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "brandName": brandName,
        "speeds": speeds == null ? [] : List<dynamic>.from(speeds!.map((x) => x)),
      };
}

class Flight {
  final Carriers? carriers;
  final String? sellingCurrency;
  final num? maxStop;
  final String? startDate;
  final String? endDate;
  final List<TravelDatum>? travelData;

  Flight({
    this.carriers,
    this.sellingCurrency,
    this.maxStop,
    this.startDate,
    this.endDate,
    this.travelData,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        carriers: json["carriers"] == null ? null : Carriers.fromJson(json["carriers"]),
        sellingCurrency: json["selling_currency"],
        maxStop: json["max_stop"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        travelData: json["travel_data"] == null
            ? []
            : List<TravelDatum>.from(json["travel_data"]!.map((x) => TravelDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "carriers": carriers?.toJson(),
        "selling_currency": sellingCurrency,
        "max_stop": maxStop,
        "start_date": startDate,
        "end_date": endDate,
        "travel_data":
            travelData == null ? [] : List<dynamic>.from(travelData!.map((x) => x.toJson())),
      };
}

class Carriers {
  final String? qr;

  Carriers({
    this.qr,
  });

  factory Carriers.fromJson(Map<String, dynamic> json) => Carriers(
        qr: json["QR"],
      );

  Map<String, dynamic> toJson() => {
        "QR": qr,
      };
}

class TravelDatum {
  final num? travelTime;
  final num? numstops;
  final List<String>? stops;
  final List<Carrier>? carriers;
  final End? start;
  final End? end;
  final List<Itenerary>? itenerary;

  TravelDatum({
    this.travelTime,
    this.numstops,
    this.stops,
    this.carriers,
    this.start,
    this.end,
    this.itenerary,
  });

  factory TravelDatum.fromJson(Map<String, dynamic> json) => TravelDatum(
        travelTime: json["travel_time"],
        numstops: json["numstops"],
        stops: json["stops"] == null ? [] : List<String>.from(json["stops"]!.map((x) => x)),
        carriers: json["carriers"] == null
            ? []
            : List<Carrier>.from(json["carriers"]!.map((x) => Carrier.fromJson(x))),
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
        itenerary: json["itenerary"] == null
            ? []
            : List<Itenerary>.from(json["itenerary"]!.map((x) => Itenerary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "travel_time": travelTime,
        "numstops": numstops,
        "stops": stops == null ? [] : List<dynamic>.from(stops!.map((x) => x)),
        "carriers": carriers == null ? [] : List<dynamic>.from(carriers!.map((x) => x.toJson())),
        "start": start?.toJson(),
        "end": end?.toJson(),
        "itenerary": itenerary == null ? [] : List<dynamic>.from(itenerary!.map((x) => x.toJson())),
      };
}

class Carrier {
  final String? code;
  final String? name;

  Carrier({
    this.code,
    this.name,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}

class End {
  final DateTime? date;
  final String? time;
  final String? locationId;
  final bool? terminal;
  final String? timezone;

  End({
    this.date,
    this.time,
    this.locationId,
    this.terminal,
    this.timezone,
  });

  factory End.fromJson(Map<String, dynamic> json) => End(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        locationId: json["locationId"],
        terminal: json["terminal"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "locationId": locationId,
        "terminal": terminal,
        "timezone": timezone,
      };
}

class Itenerary {
  final Company? company;
  final String? flightNo;
  final Arrival? departure;
  final num? flightTime;
  final Arrival? arrival;
  final num? numstops;
  final List<String>? baggageInfo;
  final String? bookingClass;
  final String? cabinClass;
  final num? layover;

  Itenerary({
    this.company,
    this.flightNo,
    this.departure,
    this.flightTime,
    this.arrival,
    this.numstops,
    this.baggageInfo,
    this.bookingClass,
    this.cabinClass,
    this.layover,
  });

  factory Itenerary.fromJson(Map<String, dynamic> json) => Itenerary(
        company: json["company"] == null ? null : Company.fromJson(json["company"]),
        flightNo: json["flightNo"],
        departure: json["departure"] == null ? null : Arrival.fromJson(json["departure"]),
        flightTime: json["flight_time"],
        arrival: json["arrival"] == null ? null : Arrival.fromJson(json["arrival"]),
        numstops: json["numstops"],
        baggageInfo: json["baggageInfo"] == null
            ? []
            : List<String>.from(json["baggageInfo"]!.map((x) => x)),
        bookingClass: json["bookingClass"],
        cabinClass: json["cabinClass"],
        layover: json["layover"],
      );

  Map<String, dynamic> toJson() => {
        "company": company?.toJson(),
        "flightNo": flightNo,
        "departure": departure?.toJson(),
        "flight_time": flightTime,
        "arrival": arrival?.toJson(),
        "numstops": numstops,
        "baggageInfo": baggageInfo == null ? [] : List<dynamic>.from(baggageInfo!.map((x) => x)),
        "bookingClass": bookingClass,
        "cabinClass": cabinClass,
        "layover": layover,
      };
}

class Arrival {
  final DateTime? date;
  final String? time;
  final String? locationId;
  final String? timezone;
  final String? airport;
  final String? city;
  final bool? terminal;

  Arrival({
    this.date,
    this.time,
    this.locationId,
    this.timezone,
    this.airport,
    this.city,
    this.terminal,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) => Arrival(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        locationId: json["locationId"],
        timezone: json["timezone"],
        airport: json["airport"],
        city: json["city"],
        terminal: json["terminal"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "locationId": locationId,
        "timezone": timezone,
        "airport": airport,
        "city": city,
        "terminal": terminal,
      };
}

class Company {
  final String? marketingCarrier;
  final String? operatingCarrier;
  final String? logo;

  Company({
    this.marketingCarrier,
    this.operatingCarrier,
    this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        marketingCarrier: json["marketingCarrier"],
        operatingCarrier: json["operatingCarrier"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "marketingCarrier": marketingCarrier,
        "operatingCarrier": operatingCarrier,
        "logo": logo,
      };
}

class Hotel {
  final String? name;
  final String? starRating;
  final String? hotelImage;

  Hotel({
    this.name,
    this.starRating,
    this.hotelImage,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        name: json["name"],
        starRating: json["starRating"],
        hotelImage: json["hotelImage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "starRating": starRating,
        "hotelImage": hotelImage,
      };
}

class Transfer {
  final String? id;
  final String? searchCode;
  final String? type;
  final String? group;
  final DateTime? date;
  final String? time;
  final String? currency;
  final String? payableCurrency;
  final double? netAmount;
  final double? totalAmount;
  final num? sellingPrice;
  final String? serviceTypeCode;
  final String? serviceTypeName;
  final String? productTypeName;
  final String? vehicleTypeName;
  final Price? price;
  final num? units;

  Transfer({
    this.id,
    this.searchCode,
    this.type,
    this.group,
    this.date,
    this.time,
    this.currency,
    this.payableCurrency,
    this.netAmount,
    this.totalAmount,
    this.sellingPrice,
    this.serviceTypeCode,
    this.serviceTypeName,
    this.productTypeName,
    this.vehicleTypeName,
    this.price,
    this.units,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        id: json["_id"],
        searchCode: json["search_code"],
        type: json["type"],
        group: json["group"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        currency: json["currency"],
        payableCurrency: json["payable_currency"],
        netAmount: json["net_amount"]?.toDouble(),
        totalAmount: json["total_amount"]?.toDouble(),
        sellingPrice: json["selling_price"],
        serviceTypeCode: json["service_type_code"],
        serviceTypeName: json["service_type_name"],
        productTypeName: json["product_type_name"],
        vehicleTypeName: json["vehicle_type_name"],
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        units: json["units"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "search_code": searchCode,
        "type": type,
        "group": group,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "currency": currency,
        "payable_currency": payableCurrency,
        "net_amount": netAmount,
        "total_amount": totalAmount,
        "selling_price": sellingPrice,
        "service_type_code": serviceTypeCode,
        "service_type_name": serviceTypeName,
        "product_type_name": productTypeName,
        "vehicle_type_name": vehicleTypeName,
        "price": price?.toJson(),
        "units": units,
      };
}

class Price {
  final double? totalAmount;
  final dynamic netAmount;
  final String? currencyId;
  final num? sellingAmount;
  final String? sellingCurrency;

  Price({
    this.totalAmount,
    this.netAmount,
    this.currencyId,
    this.sellingAmount,
    this.sellingCurrency,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        totalAmount: json["totalAmount"]?.toDouble(),
        netAmount: json["netAmount"],
        currencyId: json["currencyId"],
        sellingAmount: json["selling_amount"],
        sellingCurrency: json["selling_currency"],
      );

  Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "netAmount": netAmount,
        "currencyId": currencyId,
        "selling_amount": sellingAmount,
        "selling_currency": sellingCurrency,
      };
}

class Holder {
  final String? email;
  final String? code;
  final String? phone;
  final String? title;
  final String? firstName;
  final String? lastname;

  Holder({
    this.email,
    this.code,
    this.phone,
    this.title,
    this.firstName,
    this.lastname,
  });

  factory Holder.fromJson(Map<String, dynamic> json) => Holder(
        email: json["email"],
        code: json["code"],
        phone: json["phone"],
        title: json["title"],
        firstName: json["firstName"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "code": code,
        "phone": phone,
        "title": title,
        "firstName": firstName,
        "lastname": lastname,
      };
}

class PrebookDetails {
  PrebookDetails({
    required this.flights,
    required this.hotels,
    required this.activites,
    required this.transfers,
    required this.esim,
  });

  Flights? flights;
  Hotels? hotels;
  Activites? activites;
  Transfers? transfers;
  EsimData? esim;

  factory PrebookDetails.fromJson(Map<String, dynamic> json) {
    return PrebookDetails(
      flights: json["flights"] == null ? null : Flights.fromJson(json["flights"]),
      hotels: json["hotels"] == null ? null : Hotels.fromJson(json["hotels"]),
      activites: json['activities'] == null ? null : Activites.fromJson(json["activities"]),
      transfers: json['transfers'] != null ? Transfers.fromJson(json["transfers"]) : null,
      esim: json["esim"] != null ? EsimData.fromJson(json["esim"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "flights": flights?.toJson(),
        "hotels": hotels?.toJson(),
        "activities": activites?.toJson(),
        "transfers": transfers?.toJson(),
      };
}

class PrebookDetailsActivities {
  final bool? prebookSuccess;
  final String? message;
  final dynamic failedReasons;
  final List<Detail>? details;

  PrebookDetailsActivities({
    this.prebookSuccess,
    this.message,
    this.failedReasons,
    this.details,
  });

  factory PrebookDetailsActivities.fromJson(Map<String, dynamic> json) => PrebookDetailsActivities(
        prebookSuccess: json["prebook_success"],
        message: json["message"],
        failedReasons: json["failed_reasons"],
        details: json["details"] == null
            ? []
            : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "failed_reasons": failedReasons,
        "details": details == null ? [] : List<dynamic>.from(details!.map((x) => x.toJson())),
      };
}

class Detail {
  final DateTime? date;
  final String? key;
  final DetailDetails? details;

  Detail({
    this.date,
    this.key,
    this.details,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        key: json["key"],
        details: json["details"] == null ? null : DetailDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "key": key,
        "details": details?.toJson(),
      };
}

class DetailDetails {
  final String? name;
  final String? searchId;
  final String? code;
  final String? searchType;
  final String? activityId;
  final String? modalityCode;
  final String? modalityName;
  final List<AmountsFrom>? amountsFrom;
  final String? sellingCurrency;
  final double? netAmount;
  final String? paybleCurency;
  final num? modalityAmount;
  final DateTime? activityDate;
  final List<Question>? questions;
  final String? rateKey;
  final List<ActivityImage>? images;
  final num? prebook;

  DetailDetails({
    this.name,
    this.searchId,
    this.code,
    this.searchType,
    this.activityId,
    this.modalityCode,
    this.modalityName,
    this.amountsFrom,
    this.sellingCurrency,
    this.netAmount,
    this.paybleCurency,
    this.modalityAmount,
    this.activityDate,
    this.questions,
    this.rateKey,
    this.images,
    this.prebook,
  });

  factory DetailDetails.fromJson(Map<String, dynamic> json) => DetailDetails(
        name: json["name"],
        searchId: json["searchId"],
        code: json["code"],
        searchType: json["searchType"],
        activityId: json["activity_id"],
        modalityCode: json["modality_code"],
        modalityName: json["modality_name"],
        amountsFrom: json["amountsFrom"] == null
            ? []
            : List<AmountsFrom>.from(json["amountsFrom"]!.map((x) => AmountsFrom.fromJson(x))),
        sellingCurrency: json["selling_currency"],
        netAmount: json["net_amount"]?.toDouble(),
        paybleCurency: json["paybleCurency"],
        modalityAmount: json["modality_amount"],
        activityDate: json["activity_date"] == null ? null : DateTime.parse(json["activity_date"]),
        questions: json["questions"] == null
            ? []
            : List<Question>.from(json["questions"]!.map((x) => Question.fromJson(x))),
        rateKey: json["rateKey"],
        images: json["images"] == null
            ? []
            : List<ActivityImage>.from(json["images"]!.map((x) => ActivityImage.fromJson(x))),
        prebook: json["prebook"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "searchId": searchId,
        "code": code,
        "searchType": searchType,
        "activity_id": activityId,
        "modality_code": modalityCode,
        "modality_name": modalityName,
        "amountsFrom":
            amountsFrom == null ? [] : List<dynamic>.from(amountsFrom!.map((x) => x.toJson())),
        "selling_currency": sellingCurrency,
        "net_amount": netAmount,
        "paybleCurency": paybleCurency,
        "modality_amount": modalityAmount,
        "activity_date":
            "${activityDate!.year.toString().padLeft(4, '0')}-${activityDate!.month.toString().padLeft(2, '0')}-${activityDate!.day.toString().padLeft(2, '0')}",
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "rateKey": rateKey,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "prebook": prebook,
      };
}

class AmountsFrom {
  final String? paxType;
  final num? ageFrom;
  final num? ageTo;
  final double? amount;
  final double? boxOfficeAmount;
  final bool? mandatoryApplyAmount;

  AmountsFrom({
    this.paxType,
    this.ageFrom,
    this.ageTo,
    this.amount,
    this.boxOfficeAmount,
    this.mandatoryApplyAmount,
  });

  factory AmountsFrom.fromJson(Map<String, dynamic> json) => AmountsFrom(
        paxType: json["paxType"],
        ageFrom: json["ageFrom"],
        ageTo: json["ageTo"],
        amount: json["amount"]?.toDouble(),
        boxOfficeAmount: json["boxOfficeAmount"]?.toDouble(),
        mandatoryApplyAmount: json["mandatoryApplyAmount"],
      );

  Map<String, dynamic> toJson() => {
        "paxType": paxType,
        "ageFrom": ageFrom,
        "ageTo": ageTo,
        "amount": amount,
        "boxOfficeAmount": boxOfficeAmount,
        "mandatoryApplyAmount": mandatoryApplyAmount,
      };
}

class ActivityImage {
  final num? visualizationOrder;
  final String? mimeType;
  final List<ImageUrl>? urls;

  ActivityImage({
    this.visualizationOrder,
    this.mimeType,
    this.urls,
  });

  factory ActivityImage.fromJson(Map<String, dynamic> json) => ActivityImage(
        visualizationOrder: json["visualizationOrder"],
        mimeType: json["mimeType"],
        urls: json["urls"] == null
            ? []
            : List<ImageUrl>.from(json["urls"]!.map((x) => ImageUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visualizationOrder": visualizationOrder,
        "mimeType": mimeType,
        "urls": urls == null ? [] : List<dynamic>.from(urls!.map((x) => x.toJson())),
      };
}

class ImageUrl {
  final num? dpi;
  final num? height;
  final num? width;
  final String? resource;
  final String? sizeType;

  ImageUrl({
    this.dpi,
    this.height,
    this.width,
    this.resource,
    this.sizeType,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
        dpi: json["dpi"],
        height: json["height"],
        width: json["width"],
        resource: json["resource"],
        sizeType: json["sizeType"],
      );

  Map<String, dynamic> toJson() => {
        "dpi": dpi,
        "height": height,
        "width": width,
        "resource": resource,
        "sizeType": sizeType,
      };
}

class Question {
  final String? code;
  final String? text;
  final bool? required;

  Question({
    this.code,
    this.text,
    this.required,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        code: json["code"],
        text: json["text"],
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "text": text,
        "required": required,
      };
}

class FlightsClass {
  final bool? prebookSuccess;
  final String? message;
  final dynamic failedReasons;
  final List<dynamic>? details;

  FlightsClass({
    this.prebookSuccess,
    this.message,
    this.failedReasons,
    this.details,
  });

  factory FlightsClass.fromJson(Map<String, dynamic> json) => FlightsClass(
        prebookSuccess: json["prebook_success"],
        message: json["message"],
        failedReasons: json["failed_reasons"],
        details: json["details"] == null ? [] : List<dynamic>.from(json["details"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "failed_reasons": failedReasons,
        "details": details == null ? [] : List<dynamic>.from(details!.map((x) => x)),
      };
}

class SpecialRequest {
  final List<Map<String, bool?>>? specialRequest;

  SpecialRequest({
    this.specialRequest,
  });

  factory SpecialRequest.fromJson(Map<String, dynamic> json) => SpecialRequest(
        specialRequest: json["specialRequest"] == null
            ? []
            : List<Map<String, bool?>>.from(json["specialRequest"]!
                .map((x) => Map.from(x).map((k, v) => MapEntry<String, bool?>(k, v)))),
      );

  Map<String, dynamic> toJson() => {
        "specialRequest": specialRequest == null
            ? []
            : List<dynamic>.from(specialRequest!
                .map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      };
}

class Payment {
  Payment({
    this.userCurrency,
    this.packageAmountWithoutAnyDiscount,
    this.packageAmountWithCouponDiscount,
    this.packageAmountWithCouponWithCredit,
    this.packageAmountWithCouponWithCreditWithOtherDiscounts,
    this.finalSellingAmount,
    this.payFullAmountByCredit,
    this.payPartialAmountByCredit,
    this.discounts,
  });

  String? userCurrency;
  String? packageAmountWithoutAnyDiscount;
  String? packageAmountWithCouponDiscount;
  String? packageAmountWithCouponWithCredit;
  String? packageAmountWithCouponWithCreditWithOtherDiscounts;
  String? finalSellingAmount;
  bool? payFullAmountByCredit;
  bool? payPartialAmountByCredit;
  Discounts? discounts;

  factory Payment.fromMap(Map<String, dynamic> json) {
    return Payment(
      userCurrency: json["user_currency"],
      packageAmountWithoutAnyDiscount: json["package_amount_without_any_discount"],
      packageAmountWithCouponDiscount: json["package_amount_with_coupon_discount"],
      packageAmountWithCouponWithCredit: json["package_amount_with_coupon_with_credit"],
      packageAmountWithCouponWithCreditWithOtherDiscounts:
          json["package_amount_with_coupon_with_credit_with_other_discounts"],
      finalSellingAmount: json["final_selling_amount"],
      payFullAmountByCredit: json["pay_full_amount_by_credit"],
      payPartialAmountByCredit: json["pay_partial_amount_by_credit"],
      discounts: Discounts.fromMap(json["discounts"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "user_currency": userCurrency,
        "package_amount_without_any_discount": packageAmountWithoutAnyDiscount,
        "package_amount_with_coupon_discount": packageAmountWithCouponDiscount,
        "package_amount_with_coupon_with_credit": packageAmountWithCouponWithCredit,
        "package_amount_with_coupon_with_credit_with_other_discounts":
            packageAmountWithCouponWithCreditWithOtherDiscounts,
        "final_selling_amount": finalSellingAmount,
        "pay_full_amount_by_credit": payFullAmountByCredit,
        "pay_partial_amount_by_credit": payPartialAmountByCredit,
        "discounts": discounts?.toMap(),
      };
}

class Discounts {
  Discounts({
    this.totalDiscount,
    this.credit,
    this.gamePointsDiscount,
    this.coupons,
  });

  Coupons? totalDiscount;
  Coupons? credit;
  Coupons? gamePointsDiscount;
  Coupons? coupons;

  factory Discounts.fromMap(Map<String, dynamic> json) => Discounts(
        totalDiscount: Coupons.fromMap(json["total_discount"]),
        credit: Coupons.fromMap(json["credit"]),
        gamePointsDiscount: Coupons.fromMap(json["game_points_discount"]),
        coupons: Coupons.fromMap(json["coupons"]),
      );

  Map<String, dynamic> toMap() => {
        "total_discount": totalDiscount?.toMap(),
        "credit": credit?.toMap(),
        "game_points_discount": gamePointsDiscount?.toMap(),
        "coupons": coupons?.toMap(),
      };
}

class Coupons {
  Coupons({
    this.currency,
    this.amount,
    this.userCurrency,
    this.userAmount,
  });

  String? currency;
  String? amount;
  String? userCurrency;
  String? userAmount;

  factory Coupons.fromMap(Map<String, dynamic> json) => Coupons(
        currency: json["currency"],
        amount: json["amount"],
        userCurrency: json["user_currency"],
        userAmount: json["user_amount"],
      );

  Map<String, dynamic> toMap() => {
        "currency": currency,
        "amount": amount,
        "user_currency": userCurrency,
        "user_amount": userAmount,
      };
}

class Flights {
  Flights(
      {required this.prebookSuccess,
      required this.message,
      required this.details,
      required this.failedReasons});

  bool prebookSuccess;
  String message;
  List<FlightsDetail> details;
  FailedReasons? failedReasons;

  factory Flights.fromJson(Map<String, dynamic> json) {
    return Flights(
      prebookSuccess: json["prebook_success"],
      message: json["message"],
      details: json["prebook_success"] == false
          ? List<FlightsDetail>.from(json["details"].map((x) => FlightsDetail.fromJson(x)))
          : [],
      failedReasons:
          json["failed_reasons"] == null ? null : FailedReasons.fromMap(json["failed_reasons"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "failed_reasons": failedReasons?.toMap(),
      };
}

class FlightsDetail {
  FlightsDetail({
    required this.date,
    required this.key,
    required this.details,
  });

  DateTime date;
  String key;
  FluffyDetails details;

  factory FlightsDetail.fromJson(Map<String, dynamic> json) => FlightsDetail(
        date: DateTime.parse(json["date"]),
        key: json["key"],
        details: FluffyDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "key": key,
        "details": details.toJson(),
      };
}

class FluffyDetails {
  FluffyDetails({
    required this.flightId,
    required this.flightClass,
    required this.carrierName,
    required this.sellingCurrency,
    required this.total,
    required this.payableCurrency,
    required this.netAmount,
    required this.tripType,
    required this.maxStop,
    required this.tripStart,
    required this.tripEnd,
    required this.carriers,
    required this.travelDate,
    required this.traveldata,
    required this.prebook,
    required this.transactionId,
  });

  String flightId;
  String flightClass;
  String carrierName;
  String sellingCurrency;
  num total;
  String payableCurrency;
  num netAmount;
  num tripType;
  num maxStop;
  String tripStart;
  String tripEnd;
  Carriers? carriers;
  List<TravelDate> travelDate;
  List<Traveldatum> traveldata;
  num? prebook;
  num transactionId;

  factory FluffyDetails.fromJson(Map<String, dynamic> json) => FluffyDetails(
        flightId: json["flight_id"],
        flightClass: json["flight_class"],
        carrierName: json["carrier_name"],
        sellingCurrency: json["selling_currency"],
        total: json["total"],
        payableCurrency: json["payable_currency"],
        netAmount: json["net_amount"],
        tripType: json["trip_type"],
        maxStop: json["max_stop"],
        tripStart: json["trip_start"],
        tripEnd: json["trip_end"],
        carriers: Carriers.fromJson(json["carriers"]),
        travelDate: List<TravelDate>.from(json["travel_date"].map((x) => TravelDate.fromJson(x))),
        traveldata: List<Traveldatum>.from(json["traveldata"].map((x) => Traveldatum.fromJson(x))),
        prebook: json["prebook"],
        transactionId: json["transactionId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "flight_id": flightId,
        "flight_class": flightClass,
        "carrier_name": carrierName,
        "selling_currency": sellingCurrency,
        "total": total,
        "payable_currency": payableCurrency,
        "net_amount": netAmount,
        "trip_type": tripType,
        "max_stop": maxStop,
        "trip_start": tripStart,
        "trip_end": tripEnd,
        "carriers": carriers?.toJson() ?? '',
        "travel_date": List<dynamic>.from(travelDate.map((x) => x.toJson())),
        "traveldata": List<dynamic>.from(traveldata.map((x) => x.toJson())),
        "prebook": prebook,
        "transactionId": transactionId,
      };
}

class TravelDate {
  TravelDate({
    required this.date,
    required this.time,
  });

  DateTime date;
  String time;

  factory TravelDate.fromJson(Map<String, dynamic> json) => TravelDate(
        date: DateTime.parse(json["date"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
      };
}

class Hotels {
  Hotels({
    required this.prebookSuccess,
    required this.message,
    required this.details,
  });

  bool prebookSuccess;
  String message;
  List<HotelsDetail> details;

  factory Hotels.fromJson(Map<String, dynamic> json) => Hotels(
        prebookSuccess: json["prebook_success"],
        message: json["message"],
        details: json["prebook_success"] == true
            ? []
            : List<HotelsDetail>.from(json["details"].map((x) => HotelsDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class HotelsDetail {
  HotelsDetail({
    required this.date,
    required this.key,
    required this.details,
  });

  DateTime date;
  String key;
  TentacledDetails details;

  factory HotelsDetail.fromJson(Map<String, dynamic> json) => HotelsDetail(
        date: DateTime.parse(json["date"]),
        key: json["key"].toString(),
        details: TentacledDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "key": key,
        "details": details.toJson(),
      };
}

class TentacledDetails {
  TentacledDetails({
    required this.hotelId,
    required this.hotelCode,
    required this.name,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.starRating,
    required this.numOfRooms,
    required this.sellingCurrency,
    required this.amount,
    required this.payableCurrency,
    required this.totalAmount,
    required this.adults,
    required this.children,
    required this.destinationCode,
    required this.destinationName,
    required this.checkIn,
    required this.checkOut,
    required this.checkin,
    required this.checkout,
    required this.selectedRoom,
    required this.availability,
    required this.searchId,
    required this.prebook,
  });

  num hotelId;
  dynamic hotelCode;
  String name;
  String image;
  String? latitude;
  String? longitude;
  String starRating;
  num numOfRooms;
  String sellingCurrency;
  num amount;
  String payableCurrency;

  num totalAmount;
  List adults;
  List children;

  String? destinationCode;
  String? destinationName;
  DateTime checkIn;
  DateTime checkOut;
  DateTime checkin;
  DateTime checkout;
  List<SelectedRoom> selectedRoom;
  bool? availability;
  String searchId;
  num? prebook;

  factory TentacledDetails.fromJson(Map<String, dynamic> json) => TentacledDetails(
        hotelId: json["hotel_id"],
        hotelCode: json["hotel_code"],
        name: json["name"],
        image: json["image"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        starRating: json["starRating"],
        numOfRooms: json["numOfRooms"],
        sellingCurrency: json["selling_currency"],
        amount: json["amount"],
        payableCurrency: json["payable_currency"],
        //   netAmount: json["net_amount"],
        totalAmount: json["total_amount"],
        adults: json.containsKey('adults')
            ? (json["adults"].runtimeType == Map)
                ? json["adult"].values.map((e) => e).toList()
                : []
            : [],

        children: json.containsKey('children')
            ? (json["children"].runtimeType == Map)
                ? json["children"].values.map((e) => e).toList()
                : []
            : [],
        //   childrenAges: json["childrenAges"],
        destinationCode: json["destination_code"],
        destinationName: json["destination_name"],
        checkIn: DateTime.parse(json["checkIn"]),
        checkOut: DateTime.parse(json["checkOut"]),
        checkin: DateTime.parse(json["checkin"]),
        checkout: DateTime.parse(json["checkout"]),
        selectedRoom:
            List<SelectedRoom>.from(json["selectedRoom"].map((x) => SelectedRoom.fromJson(x))),
        availability: json["availability"],
        searchId: json["searchId"],
        prebook: json["prebook"],
      );

  Map<String, dynamic> toJson() => {
        "hotel_id": hotelId,
        "hotel_code": hotelCode,
        "name": name,
        "image": image,
        "latitude": latitude,
        "longitude": longitude,
        "starRating": starRating,
        "numOfRooms": numOfRooms,
        "selling_currency": sellingCurrency,
        "amount": amount,
        "payable_currency": payableCurrency,
        "total_amount": totalAmount,
        "adults": adults,
        "children": children,
        "destination_code": destinationCode,
        "destination_name": destinationName,
        "checkIn":
            "${checkIn.year.toString().padLeft(4, '0')}-${checkIn.month.toString().padLeft(2, '0')}-${checkIn.day.toString().padLeft(2, '0')}",
        "checkOut":
            "${checkOut.year.toString().padLeft(4, '0')}-${checkOut.month.toString().padLeft(2, '0')}-${checkOut.day.toString().padLeft(2, '0')}",
        "checkin":
            "${checkin.year.toString().padLeft(4, '0')}-${checkin.month.toString().padLeft(2, '0')}-${checkin.day.toString().padLeft(2, '0')}",
        "checkout":
            "${checkout.year.toString().padLeft(4, '0')}-${checkout.month.toString().padLeft(2, '0')}-${checkout.day.toString().padLeft(2, '0')}",
        "selectedRoom": List<dynamic>.from(selectedRoom.map((x) => x.toJson())),
        "availability": availability,
        "searchId": searchId,
        "prebook": prebook,
      };
}

class Adults {
  Adults({
    required this.the1,
  });

  String the1;

  factory Adults.fromJson(Map<String, dynamic> json) => Adults(
        the1: json["1"],
      );

  Map<String, dynamic> toJson() => {
        "1": the1,
      };
}

class SelectedRoom {
  SelectedRoom({
    required this.name,
    required this.code,
    required this.allotment,
    required this.rateKey,
    required this.rateClass,
    required this.rateType,
    required this.boardCode,
    required this.boardName,
    required this.sellingCurrency,
    required this.amount,
    required this.amountChange,
    required this.type,
    required this.prebook,
  });

  String name;
  String code;
  num allotment;
  String rateKey;
  String rateClass;
  String rateType;
  String boardCode;
  String boardName;
  String sellingCurrency;
  num amount;
  num amountChange;
  String type;
  num? prebook;

  factory SelectedRoom.fromJson(Map<String, dynamic> json) => SelectedRoom(
        name: json["name"],
        code: json["code"],
        allotment: json["allotment"],
        rateKey: json["rateKey"],
        rateClass: json["rateClass"],
        rateType: json["rateType"],
        boardCode: json["boardCode"],
        boardName: json["boardName"],
        sellingCurrency: json["SellingCurrency"],
        amount: json["amount"],
        amountChange: json["amountChange"],
        type: json["type"],
        prebook: json["prebook"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "allotment": allotment,
        "rateKey": rateKey,
        "rateClass": rateClass,
        "rateType": rateType,
        "boardCode": boardCode,
        "boardName": boardName,
        "SellingCurrency": sellingCurrency,
        "amount": amount,
        "amountChange": amountChange,
        "type": type,
        "prebook": prebook,
      };
}

class Transfers {
  Transfers({
    required this.prebookSuccess,
    required this.message,
    required this.details,
  });

  bool prebookSuccess;
  String message;
  List<TransfersDetail> details;

  factory Transfers.fromJson(Map<String, dynamic> json) {
    return Transfers(
        prebookSuccess: json["prebook_success"],
        message: json["message"],
        details: json["details"].isEmpty
            ? []
            : List<TransfersDetail>.from(json["details"].map((x) => TransfersDetail.fromJson(x))));
  }

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class TransfersDetail {
  TransfersDetail({
    required this.date,
    required this.key,
    required this.details,
  });

  DateTime date;
  num key;
  StickyDetails details;

  factory TransfersDetail.fromJson(Map<String, dynamic> json) {
    return TransfersDetail(
      date: DateTime.parse(json["date"]),
      key: json["key"],
      details: StickyDetails.fromJson(json["details"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "key": key,
        "details": details.toJson(),
      };
}

class StickyDetails {
  StickyDetails({
    required this.id,
    required this.searchCode,
    required this.type,
    required this.group,
    required this.date,
    required this.time,
    required this.currency,
    required this.payableCurrency,
    required this.netAmount,
    required this.totalAmount,
    required this.sellingPrice,
    required this.serviceTypeCode,
    required this.serviceTypeName,
    required this.productTypeName,
    required this.vehicleTypeName,
    required this.units,
    required this.prebook,
    required this.supplierCurrency,
    required this.supplierPrice,
  });

  String? id;
  String? searchCode;
  String? type;
  String? group;
  DateTime? date;
  String? time;
  String? currency;
  String? payableCurrency;
  double? netAmount;
  num? totalAmount;
  double? sellingPrice;
  String? serviceTypeCode;
  String? serviceTypeName;
  String? productTypeName;
  String? vehicleTypeName;
  num? units;
  num? prebook;
  String? supplierCurrency;
  String? supplierPrice;

  factory StickyDetails.fromJson(Map<String, dynamic> json) => StickyDetails(
        id: json["_id"],
        searchCode: json["search_code"],
        type: json["type"],
        group: json["group"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        currency: json["currency"],
        payableCurrency: json["payable_currency"],
        netAmount: json["net_amount"].toDouble(),
        totalAmount: json["total_amount"],
        sellingPrice: json["selling_price"].toDouble(),
        serviceTypeCode: json["service_type_code"],
        serviceTypeName: json["service_type_name"],
        productTypeName: json["product_type_name"],
        vehicleTypeName: json["vehicle_type_name"],
        units: json["units"],
        prebook: json.containsKey('prebook') ? json["prebook"] ?? 0 : 0,
        supplierCurrency: json["supplier_currency"],
        supplierPrice: json["supplier_price"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "search_code": searchCode,
        "type": type,
        "group": group,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "time": time,
        "currency": currency,
        "payable_currency": payableCurrency,
        "net_amount": netAmount,
        "total_amount": totalAmount,
        "selling_price": sellingPrice,
        "service_type_code": serviceTypeCode,
        "service_type_name": serviceTypeName,
        "product_type_name": productTypeName,
        "vehicle_type_name": vehicleTypeName,
        "units": units,
        "prebook": prebook,
        "supplier_currency": supplierCurrency,
        "supplier_price": supplierPrice,
      };
}

class FailedReasons {
  FailedReasons({
    this.fielderrors,
    this.unknownerror,
  });

  bool? fielderrors;
  bool? unknownerror;

  factory FailedReasons.fromMap(Map<String, dynamic> json) => FailedReasons(
        fielderrors: json["fielderrors"],
        unknownerror: json["unknownerror"],
      );

  Map<String, dynamic> toMap() => {
        "fielderrors": fielderrors,
        "unknownerror": unknownerror,
      };
}

class Traveldatum {
  Traveldatum({
    required this.travelTime,
    required this.numstops,
    required this.stops,
    required this.carriers,
    required this.start,
    required this.end,
    required this.itenerary,
  });

  num travelTime;
  num numstops;
  List<String> stops;
  List<Carrier> carriers;
  End start;
  End end;
  List<Itenerary> itenerary;

  factory Traveldatum.fromJson(Map<String, dynamic> json) => Traveldatum(
        travelTime: json["travel_time"],
        numstops: json["numstops"],
        stops: List<String>.from(json["stops"].map((x) => x)),
        carriers: List<Carrier>.from(json["carriers"].map((x) => Carrier.fromJson(x))),
        start: End.fromJson(json["start"]),
        end: End.fromJson(json["end"]),
        itenerary: List<Itenerary>.from(json["itenerary"].map((x) => Itenerary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "travel_time": travelTime,
        "numstops": numstops,
        "stops": List<dynamic>.from(stops.map((x) => x)),
        "carriers": List<dynamic>.from(carriers.map((x) => x.toJson())),
        "start": start.toJson(),
        "end": end.toJson(),
        "itenerary": List<dynamic>.from(itenerary.map((x) => x.toJson())),
      };
}

class Activites {
  Activites({
    required this.prebookSuccess,
    required this.message,
    required this.details,
  });

  bool prebookSuccess;
  String message;
  List<ActivitesDetail> details;

  factory Activites.fromJson(Map<String, dynamic> json) => Activites(
      prebookSuccess: json["prebook_success"],
      message: json["message"],
      details: json["prebook_success"] == false
          ? List<ActivitesDetail>.from(json["details"].map((x) => ActivitesDetail.fromJson(x)))
          : []);

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class ActivitesDetail {
  ActivitesDetail({
    required this.date,
    required this.key,
    required this.details,
  });

  DateTime date;
  String key;
  PurpleDetails details;

  factory ActivitesDetail.fromJson(Map<String, dynamic> json) => ActivitesDetail(
        date: DateTime.parse(json["date"]),
        key: json["key"].toString(),
        details: PurpleDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "key": key,
        "details": details.toJson(),
      };
}

class PurpleDetails {
  PurpleDetails({
    required this.name,
    required this.searchId,
    required this.code,
    required this.activityId,
    required this.modalityCode,
    required this.modalityName,
    // required this.amountsFrom,
    required this.sellingCurrency,
    required this.netAmount,
    required this.paybleCurency,
    required this.modalityAmount,
    required this.activityDate,
    required this.questions,
    required this.rateKey,
    required this.images,
    required this.bookingReference,
    required this.prebook,
  });

  String name;
  String searchId;
  String code;
  String activityId;
  String modalityCode;
  String modalityName;

  String sellingCurrency;
  double netAmount;
  String paybleCurency;
  num modalityAmount;
  DateTime activityDate;
  List<Question> questions;
  String rateKey;
  List<ActivityImage> images;
  String bookingReference;
  num? prebook;

  // String prebookedAt;
  // String supplierReference;
  // String supplierCurrency;
  // double supplierPrice;

  factory PurpleDetails.fromJson(Map<String, dynamic> json) => PurpleDetails(
        name: json["name"],
        searchId: json["searchId"],
        code: json["code"],
        activityId: json["activity_id"],
        modalityCode: json["modality_code"],
        modalityName: json["modality_name"],
        // amountsFrom:
        //     List<AmountsFrom>.from(json["amountsFrom"].map((x) => AmountsFrom.fromJson(x))),
        sellingCurrency: json["selling_currency"],
        netAmount: json["net_amount"].toDouble(),
        paybleCurency: json["paybleCurency"],
        modalityAmount: json["modality_amount"],
        activityDate: DateTime.parse(json["activity_date"]),
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
        rateKey: json["rateKey"],
        images: List<ActivityImage>.from(json["images"].map((x) => ActivityImage.fromJson(x))),
        bookingReference:
            json.containsKey('bookingReference') ? json["bookingReference"] ?? "" : '',
        prebook: json["prebook"],
        //prebookedAt: json["prebooked_at"],
        // supplierReference: json["supplierReference"],
        // supplierCurrency: json["supplier_currency"],
        // supplierPrice: json["supplier_price"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "searchId": searchId,
        "code": code,
        "activity_id": activityId,
        "modality_code": modalityCode,
        "modality_name": modalityName,
        // "amountsFrom": List<dynamic>.from(amountsFrom.map((x) => x.toJson())),
        "selling_currency": sellingCurrency,
        "net_amount": netAmount,
        "paybleCurency": paybleCurency,
        "modality_amount": modalityAmount,
        "activity_date":
            "${activityDate.year.toString().padLeft(4, '0')}-${activityDate.month.toString().padLeft(2, '0')}-${activityDate.day.toString().padLeft(2, '0')}",
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "rateKey": rateKey,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "bookingReference": bookingReference,
        "prebook": prebook,
        // "prebooked_at": prebookedAt,
        // "supplierReference": supplierReference,
        // "supplier_currency": supplierCurrency,
        // "supplier_price": supplierPrice,
      };
}

class EsimData {
  EsimData({
    required this.prebookSuccess,
    required this.message,
    required this.details,
  });

  bool prebookSuccess;
  String message;
  final EsimDetails? details;

  factory EsimData.fromJson(Map<String, dynamic> json) => EsimData(
        prebookSuccess: json["prebook_success"],
        message: json["message"],
        details: json["details"] == null
            ? null
            : json["details"] is List
                ? null
                : EsimDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "prebook_success": prebookSuccess,
        "message": message,
        "details": details?.toJson(),
      };
}

class EsimDetails {
  final DateTime? date;
  final num? key;
  final String? details;

  EsimDetails({
    this.date,
    this.key,
    this.details,
  });

  factory EsimDetails.fromJson(Map<String, dynamic> json) => EsimDetails(
        date: (json["date"] == null || json["date"] == "") ? null : DateTime.parse(json["date"]),
        key: json["key"],
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "key": key,
        "details": details,
      };
}
