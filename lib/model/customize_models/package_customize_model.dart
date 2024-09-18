// To parse this JSON data, do
//
//     final packageCustomizeModel = packageCustomizeModelFromJson(jsonString);

import 'dart:convert';

import 'package:geolocator/geolocator.dart';

PackageCustomizeModel packageCustomizeModelFromJson(String str) =>
    PackageCustomizeModel.fromJson(json.decode(str));

String packageCustomizeModelToJson(PackageCustomizeModel data) => json.encode(data.toJson());

class PackageCustomizeModel {
  final Status? status;
  final Result? result;

  PackageCustomizeModel({
    this.status,
    this.result,
  });

  factory PackageCustomizeModel.fromJson(Map<String, dynamic> json) => PackageCustomizeModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "result": result?.toJson(),
      };
}

class Result {
  final String? paxDetails;
  final String? customizeId;
  final String? packageId;
  final num? searchId;
  final String? packageName;
  final num? packageDays;
  final DateTime? packageStart;
  final DateTime? packageEnd;
  final String? fromCity;
  final String? toCity;
  final bool? sameCitySearch;
  final Esim? esim;
  final String? sellingCurrency;
  final num? totalAmount;
  final num? adults;
  final num? children;
  final num? totalPassenger;
  //final ChildAge? childAge;
  final num? prebook;
  final List<Hotel>? hotels;
  final Flight? flight;
  final List<Transfer>? transfer;
  final Map<String, List<Activity>>? activities;
  final bool? noActivity;
  final bool? noTransfer;
  final bool? noHotels;
  final bool? noFlight;
  final String? searchMode;
  final bool? isHotelSearch;
  final bool? isTransferSearch;
  final bool? isActivitySearch;
  final bool? isFlightSearch;

  Result({
    this.paxDetails,
    this.customizeId,
    this.packageId,
    this.searchId,
    this.packageName,
    this.packageDays,
    this.packageStart,
    this.packageEnd,
    this.fromCity,
    this.toCity,
    this.sameCitySearch,
    this.esim,
    this.sellingCurrency,
    this.totalAmount,
    this.adults,
    this.children,
    this.totalPassenger,
    //this.childAge,
    this.prebook,
    this.hotels,
    this.flight,
    this.transfer,
    this.activities,
    this.noActivity,
    this.noTransfer,
    this.noHotels,
    this.noFlight,
    this.searchMode,
    this.isHotelSearch,
    this.isTransferSearch,
    this.isActivitySearch,
    this.isFlightSearch,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        paxDetails: json["paxDetails"],
        customizeId: json["customizeId"],
        packageId: json["packageId"],
        searchId: json["searchId"],
        packageName: json["package_name"],
        packageDays: json["package_days"],
        packageStart: json["package_start"] == null ? null : DateTime.parse(json["package_start"]),
        packageEnd: json["package_end"] == null ? null : DateTime.parse(json["package_end"]),
        fromCity: json["from_city"],
        toCity: json["to_city"],
        sameCitySearch: json["same_city_search"],
        esim: json["esim"] == null ? null : Esim.fromJson(json["esim"]),
        sellingCurrency: json["selling_currency"],
        totalAmount: json["total_amount"],
        adults: json["adults"],
        children: json["children"],
        totalPassenger: json["totalPassenger"],
        //  childAge: json["childAge"] == null ? null : ChildAge.fromJson(json["childAge"]),
        prebook: json["prebook"],
        hotels: json["hotels"] == null
            ? []
            : List<Hotel>.from(json["hotels"]!.map((x) => Hotel.fromJson(x))),
        flight: json["flight"] == null
            ? null
            : json['flight'].runtimeType.toString() == "List<dynamic>"
                ? null
                : Flight.fromJson(json["flight"]),
        transfer: json["transfer"] == null
            ? []
            : List<Transfer>.from(json["transfer"]!.map((x) => Transfer.fromJson(x))),
        activities: Map.from(json["activities"]!).map((k, v) => MapEntry<String, List<Activity>>(
            k, List<Activity>.from(v.map((x) => Activity.fromJson(x))))),
        noActivity: json["no_activity"],
        noTransfer: json["no_transfer"],
        noHotels: json["no_hotels"],
        noFlight: json["no_flight"],
        searchMode: json["searchMode"],
        isHotelSearch: json["isHotelSearch"],
        isTransferSearch: json["isTransferSearch"],
        isActivitySearch: json["isActivitySearch"],
        isFlightSearch: json["isFlightSearch"],
      );

  Map<String, dynamic> toJson() => {
        "paxDetails": paxDetails,
        "customizeId": customizeId,
        "packageId": packageId,
        "searchId": searchId,
        "package_name": packageName,
        "package_days": packageDays,
        "package_start":
            "${packageStart!.year.toString().padLeft(4, '0')}-${packageStart!.month.toString().padLeft(2, '0')}-${packageStart!.day.toString().padLeft(2, '0')}",
        "package_end":
            "${packageEnd!.year.toString().padLeft(4, '0')}-${packageEnd!.month.toString().padLeft(2, '0')}-${packageEnd!.day.toString().padLeft(2, '0')}",
        "from_city": fromCity,
        "to_city": toCity,
        "same_city_search": sameCitySearch,
        "esim": esim?.toJson(),
        "selling_currency": sellingCurrency,
        "total_amount": totalAmount,
        "adults": adults,
        "children": children,
        "totalPassenger": totalPassenger,
        //  "childAge": childAge?.toJson(),
        "prebook": prebook,
        "hotels": hotels == null ? [] : List<dynamic>.from(hotels!.map((x) => x.toJson())),
        "flight": flight?.toJson(),
        "transfer": transfer == null ? [] : List<dynamic>.from(transfer!.map((x) => x.toJson())),
        "activities": Map.from(activities!).map(
            (k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "no_activity": noActivity,
        "no_transfer": noTransfer,
        "no_hotels": noHotels,
        "no_flight": noFlight,
        "searchMode": searchMode,
        "isHotelSearch": isHotelSearch,
        "isTransferSearch": isTransferSearch,
        "isActivitySearch": isActivitySearch,
        "isFlightSearch": isFlightSearch,
      };
}

class Activity {
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
  final List<dynamic>? questions;
  final String? rateKey;
  final List<ActivityImages>? images;
  final num? day;
  final String? activityDateDisplay;
  final String? activityDestination;
  final String? image;
  final String? description;
  final String? prebook;

  Activity({
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
    this.day,
    this.activityDateDisplay,
    this.activityDestination,
    this.image,
    this.description,
    this.prebook,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
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
        questions:
            json["questions"] == null ? [] : List<dynamic>.from(json["questions"]!.map((x) => x)),
        rateKey: json["rateKey"],
        images: json["images"] == null
            ? []
            : List<ActivityImages>.from(json["images"]!.map((x) => ActivityImages.fromJson(x))),
        day: json["day"],
        activityDateDisplay: json["activity_date_display"],
        activityDestination: json["activity_destination"],
        image: json["image"],
        description: json["description"],
        prebook: json["prebook"].toString(),
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
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x)),
        "rateKey": rateKey,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "day": day,
        "activity_date_display": activityDateDisplay,
        "activity_destination": activityDestination,
        "image": image,
        "description": description,
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

class ActivityImages {
  final num? visualizationOrder;
  final String? mimeType;
  final List<ImageDataUrl>? urls;

  ActivityImages({
    this.visualizationOrder,
    this.mimeType,
    this.urls,
  });

  factory ActivityImages.fromJson(Map<String, dynamic> json) => ActivityImages(
        visualizationOrder: json["visualizationOrder"],
        mimeType: json["mimeType"],
        urls: json["urls"] == null
            ? []
            : List<ImageDataUrl>.from(json["urls"]!.map((x) => ImageDataUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visualizationOrder": visualizationOrder,
        "mimeType": mimeType,
        "urls": urls == null ? [] : List<dynamic>.from(urls!.map((x) => x.toJson())),
      };
}

class ImageDataUrl {
  final num? dpi;
  final num? height;
  final num? width;
  final String? resource;
  final String? sizeType;

  ImageDataUrl({
    this.dpi,
    this.height,
    this.width,
    this.resource,
    this.sizeType,
  });

  factory ImageDataUrl.fromJson(Map<String, dynamic> json) => ImageDataUrl(
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

class ChildAge {
  final Map<String, String>? the1;

  ChildAge({
    this.the1,
  });

  factory ChildAge.fromJson(Map<String, dynamic> json) => ChildAge(
        the1: Map.from(json["1"]!).map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "1": Map.from(the1!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Esim {
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

  Esim({
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

  factory Esim.fromJson(Map<String, dynamic> json) => Esim(
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
  final Carrier? carrier;
  final String? tripStart;
  final String? tripEnd;
  final Passenger? passenger;
  final String? flightClass;
  final From? from;
  final From? to;
  final String? flightId;
  final String? prebook;

  Flight({
    this.carriers,
    this.carrier,
    this.tripStart,
    this.tripEnd,
    this.passenger,
    this.flightClass,
    this.from,
    this.to,
    this.flightId,
    this.prebook,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        carriers: json["carriers"] == null ? null : Carriers.fromJson(json["carriers"]),
        carrier: json["carrier"] == null ? null : Carrier.fromJson(json["carrier"]),
        tripStart: json["trip_start"],
        tripEnd: json["trip_end"],
        passenger: json["passenger"] == null ? null : Passenger.fromJson(json["passenger"]),
        flightClass: json["flight_class"],
        from: json["from"] == null ? null : From.fromJson(json["from"]),
        to: json["to"] == null ? null : From.fromJson(json["to"]),
        flightId: json["flight_id"],
        prebook: json["prebook"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "carriers": carriers?.toJson(),
        "carrier": carrier?.toJson(),
        "trip_start": tripStart,
        "trip_end": tripEnd,
        "passenger": passenger?.toJson(),
        "flight_class": flightClass,
        "from": from?.toJson(),
        "to": to?.toJson(),
        "flight_id": flightId,
        "prebook": prebook,
      };
}

class Carrier {
  final String? code;
  final String? name;
  final String? label;

  Carrier({
    this.code,
    this.name,
    this.label,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
        code: json["code"],
        name: json["name"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "label": label,
      };
}

class Carriers {
  final String? lx;

  Carriers({
    this.lx,
  });

  factory Carriers.fromJson(Map<String, dynamic> json) => Carriers(
        lx: json["LX"],
      );

  Map<String, dynamic> toJson() => {
        "LX": lx,
      };
}

class From {
  final num? numstops;
  final List<String>? stops;
  final String? departure;
  final String? arrival;
  final num? arrivalDays;
  final DateTime? departureFdate;
  final String? departureDate;
  final String? departureTime;
  final DateTime? arrivalFdate;
  final String? arrivalDate;
  final String? arrivalTime;
  final String? travelTime;
  final List<Itinerary>? itinerary;
  final String? carrierCode;
  final String? carrierName;
  final String? carrierLogo;

  From({
    this.numstops,
    this.stops,
    this.departure,
    this.arrival,
    this.arrivalDays,
    this.departureFdate,
    this.departureDate,
    this.departureTime,
    this.arrivalFdate,
    this.arrivalDate,
    this.arrivalTime,
    this.travelTime,
    this.itinerary,
    this.carrierCode,
    this.carrierName,
    this.carrierLogo,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        numstops: json["numstops"],
        stops: json["stops"] == null ? [] : List<String>.from(json["stops"]!.map((x) => x)),
        departure: json["departure"],
        arrival: json["arrival"],
        arrivalDays: json["arrival_days"],
        departureFdate:
            json["departure_fdate"] == null ? null : DateTime.parse(json["departure_fdate"]),
        departureDate: json["departure_date"],
        departureTime: json["departure_time"],
        arrivalFdate: json["arrival_fdate"] == null ? null : DateTime.parse(json["arrival_fdate"]),
        arrivalDate: json["arrival_date"],
        arrivalTime: json["arrival_time"],
        travelTime: json["travel_time"],
        itinerary: json["itinerary"] == null
            ? []
            : List<Itinerary>.from(json["itinerary"]!.map((x) => Itinerary.fromJson(x))),
        carrierCode: json["carrier_code"],
        carrierName: json["carrier_name"],
        carrierLogo: json["carrier_logo"],
      );

  Map<String, dynamic> toJson() => {
        "numstops": numstops,
        "stops": stops == null ? [] : List<dynamic>.from(stops!.map((x) => x)),
        "departure": departure,
        "arrival": arrival,
        "arrival_days": arrivalDays,
        "departure_fdate":
            "${departureFdate!.year.toString().padLeft(4, '0')}-${departureFdate!.month.toString().padLeft(2, '0')}-${departureFdate!.day.toString().padLeft(2, '0')}",
        "departure_date": departureDate,
        "departure_time": departureTime,
        "arrival_fdate":
            "${arrivalFdate!.year.toString().padLeft(4, '0')}-${arrivalFdate!.month.toString().padLeft(2, '0')}-${arrivalFdate!.day.toString().padLeft(2, '0')}",
        "arrival_date": arrivalDate,
        "arrival_time": arrivalTime,
        "travel_time": travelTime,
        "itinerary": itinerary == null ? [] : List<dynamic>.from(itinerary!.map((x) => x.toJson())),
        "carrier_code": carrierCode,
        "carrier_name": carrierName,
        "carrier_logo": carrierLogo,
      };
}

class Itinerary {
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

  Itinerary({
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

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
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
  final String? name;
  Company({
    this.marketingCarrier,
    this.operatingCarrier,
    this.logo,
    this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
      marketingCarrier: json["marketingCarrier"],
      operatingCarrier: json["operatingCarrier"],
      logo: json["logo"],
      name: json["name"]);

  Map<String, dynamic> toJson() => {
        "marketingCarrier": marketingCarrier,
        "operatingCarrier": operatingCarrier,
        "logo": logo,
      };
}

class Passenger {
  final num? adult;
  final num? child;

  Passenger({
    this.adult,
    this.child,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        adult: json["Adult"],
        child: json["Child"],
      );

  Map<String, dynamic> toJson() => {
        "Adult": adult,
        "Child": child,
      };
}

class Hotel {
  final num? id;
  final String? searchId;
  final String? hotelCode;
  final String? name;
  final String? description;
  final String? starRating;
  final String? destinationCode;
  final String? destinationName;
  final String? checkInText;
  final String? checkOutText;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final DateTime? checkin;
  final DateTime? checkout;
  final String? address;
  final String? currency;
  final num? rateFrom;
  final String? latitude;
  final String? longitude;
  final String? image;
  final List<ImgAll>? imgAll;
  final List<List<Room>>? rooms;
  final List<String>? facilities;
  final List<SelectedRoom>? selectedRoom;
  final bool? availability;
  final String? prebook;
  final String? distanceFromMakkah;

  Hotel({
    this.id,
    this.searchId,
    this.hotelCode,
    this.name,
    this.description,
    this.starRating,
    this.destinationCode,
    this.destinationName,
    this.checkInText,
    this.checkOutText,
    this.checkIn,
    this.checkOut,
    this.checkin,
    this.checkout,
    this.address,
    this.currency,
    this.rateFrom,
    this.latitude,
    this.longitude,
    this.image,
    this.imgAll,
    this.rooms,
    this.facilities,
    this.selectedRoom,
    this.availability,
    this.prebook,
    this.distanceFromMakkah,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
      id: json["id"],
      searchId: json["searchId"],
      hotelCode: json["hotelCode"],
      name: json["name"],
      description: json["description"],
      starRating: json["starRating"],
      destinationCode: json["destinationCode"],
      destinationName: json["destinationName"],
      checkInText: json["checkInText"],
      checkOutText: json["checkOutText"],
      checkIn: json["checkIn"] == null ? null : DateTime.parse(json["checkIn"]),
      checkOut: json["checkOut"] == null ? null : DateTime.parse(json["checkOut"]),
      checkin: json["checkin"] == null ? null : DateTime.parse(json["checkin"]),
      checkout: json["checkout"] == null ? null : DateTime.parse(json["checkout"]),
      address: json["address"],
      currency: json["currency"],
      rateFrom: json["rateFrom"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      image: json["image"],
      imgAll: json["img_all"] == null
          ? []
          : List<ImgAll>.from(json["img_all"]!.map((x) => ImgAll.fromJson(x))),
      rooms: json["rooms"] == null
          ? []
          : List<List<Room>>.from(
              json["rooms"]!.map((x) => List<Room>.from(x.map((x) => Room.fromJson(x))))),
      facilities:
          json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
      selectedRoom: json["selectedRoom"] == null
          ? []
          : List<SelectedRoom>.from(json["selectedRoom"]!.map((x) => SelectedRoom.fromJson(x))),
      availability: json["availability"],
      prebook: json["prebook"].toString(),
      distanceFromMakkah: (Geolocator.distanceBetween(
                double.tryParse(json["latitude"]) ?? 1,
                double.tryParse(json["longitude"]) ?? 1,
                21.422510,
                39.826168,
              ) /
              1000)
          .toStringAsFixed(1));
  Map<String, dynamic> toJson() => {
        "id": id,
        "searchId": searchId,
        "hotelCode": hotelCode,
        "name": name,
        "description": description,
        "starRating": starRating,
        "destinationCode": destinationCode,
        "destinationName": destinationName,
        "checknumext": checkInText,
        "checkOutText": checkOutText,
        "checkIn":
            "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
        "checkOut":
            "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
        "checkin":
            "${checkin!.year.toString().padLeft(4, '0')}-${checkin!.month.toString().padLeft(2, '0')}-${checkin!.day.toString().padLeft(2, '0')}",
        "checkout":
            "${checkout!.year.toString().padLeft(4, '0')}-${checkout!.month.toString().padLeft(2, '0')}-${checkout!.day.toString().padLeft(2, '0')}",
        "address": address,
        "currency": currency,
        "rateFrom": rateFrom,
        "latitude": latitude,
        "longitude": longitude,
        "image": image,
        "img_all": imgAll == null ? [] : List<dynamic>.from(imgAll!.map((x) => x.toJson())),
        "rooms": rooms == null
            ? []
            : List<dynamic>.from(rooms!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
        "selectedRoom":
            selectedRoom == null ? [] : List<dynamic>.from(selectedRoom!.map((x) => x.toJson())),
        "availability": availability,
        "prebook": prebook,
      };
}

class ImgAll {
  final String? src;

  ImgAll({
    this.src,
  });

  factory ImgAll.fromJson(Map<String, dynamic> json) => ImgAll(
        src: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "src": src,
      };
}

class Room {
  final String? name;
  final String? code;
  final num? allotment;
  final String? rateKey;
  final String? rateClass;
  final String? roomTypeText;
  final String? rateType;
  final String? boardCode;
  final String? boardName;
  final String? sellingCurrency;
  final num? amount;
  final num? amountChange;
  final String? type;

  Room({
    this.name,
    this.code,
    this.allotment,
    this.rateKey,
    this.rateClass,
    this.roomTypeText,
    this.rateType,
    this.boardCode,
    this.boardName,
    this.sellingCurrency,
    this.amount,
    this.amountChange,
    this.type,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        name: json["name"],
        code: json["code"],
        allotment: json["allotment"],
        rateKey: json["rateKey"],
        rateClass: json["rateClass"],
        roomTypeText: json["roomTypeText"],
        rateType: json["rateType"],
        boardCode: json["boardCode"],
        boardName: json["boardName"],
        sellingCurrency: json["SellingCurrency"],
        amount: json["amount"],
        amountChange: json["amountChange"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "allotment": allotment,
        "rateKey": rateKey,
        "rateClass": rateClass,
        "roomTypeText": roomTypeText,
        "rateType": rateType,
        "boardCode": boardCode,
        "boardName": boardName,
        "SellingCurrency": sellingCurrency,
        "amount": amount,
        "amountChange": amountChange,
        "type": type,
      };
}

class SelectedRoom {
  final String? name;
  final String? code;
  final num? allotment;
  final String? rateKey;
  final String? rateClass;
  final String? roomTypeText;
  final String? rateType;
  final String? boardCode;
  final String? boardName;
  final String? sellingCurrency;
  final num? amount;
  final num? amountChange;
  final String? type;

  SelectedRoom({
    this.name,
    this.code,
    this.allotment,
    this.rateKey,
    this.rateClass,
    this.roomTypeText,
    this.rateType,
    this.boardCode,
    this.boardName,
    this.sellingCurrency,
    this.amount,
    this.amountChange,
    this.type,
  });

  factory SelectedRoom.fromJson(Map<String, dynamic> json) => SelectedRoom(
        name: json["name"],
        code: json["code"],
        allotment: json["allotment"],
        rateKey: json["rateKey"],
        rateClass: json["rateClass"],
        roomTypeText: json["roomTypeText"],
        rateType: json["rateType"],
        boardCode: json["boardCode"],
        boardName: json["boardName"],
        sellingCurrency: json["SellingCurrency"],
        amount: json["amount"],
        amountChange: json["amountChange"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "allotment": allotment,
        "rateKey": rateKey,
        "rateClass": rateClass,
        "roomTypeText": roomTypeText,
        "rateType": rateType,
        "boardCode": boardCode,
        "boardName": boardName,
        "SellingCurrency": sellingCurrency,
        "amount": amount,
        "amountChange": amountChange,
        "type": type,
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
  final String? image;
  final String? pickUpLocation;
  final String? dropOffLocation;
  final List<dynamic>? waitingInfo;
  final List<String>? generalInformation;
  final String? pickupInformation;

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
    this.image,
    this.pickUpLocation,
    this.dropOffLocation,
    this.waitingInfo,
    this.generalInformation,
    this.pickupInformation,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        id: json["_id"],
        searchCode: json["search_code"],
        type: json["type"],
        group: json["group"],
        date: json["date"] == null
            ? null
            : json["date"] == ''
                ? null
                : DateTime.parse(json["date"]),
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
        image: json["image"],
        pickUpLocation: json["pick_up_location"],
        dropOffLocation: json["drop_off_location"],
        waitingInfo: json["waiting_info"] == null
            ? []
            : List<dynamic>.from(json["waiting_info"]!.map((x) => x)),
        generalInformation: json["general_information"] == null
            ? []
            : List<String>.from(json["general_information"]!.map((x) => x)),
        pickupInformation: json["pickup_information"],
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
        "image": image,
        "pick_up_location": pickUpLocation,
        "drop_off_location": dropOffLocation,
        "waiting_info": waitingInfo == null ? [] : List<dynamic>.from(waitingInfo!.map((x) => x)),
        "general_information":
            generalInformation == null ? [] : List<dynamic>.from(generalInformation!.map((x) => x)),
        "pickup_information": pickupInformation,
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

class Status {
  final num? code;
  final String? message;
  final bool? error;

  Status({
    this.code,
    this.message,
    this.error,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json["code"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "error": error,
      };
}
