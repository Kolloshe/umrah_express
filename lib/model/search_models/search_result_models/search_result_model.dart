// To parse this JSON data, do
//
//     final searchResultModel = searchResultModelFromJson(jsonString);

import 'dart:convert';

SearchResultModel searchResultModelFromJson(String str) =>
    SearchResultModel.fromJson(json.decode(str));

String searchResultModelToJson(SearchResultModel data) => json.encode(data.toJson());

class SearchResultModel {
  final bool? error;
  final Data? data;

  SearchResultModel({
    this.error,
    this.data,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data?.toJson(),
      };
}

class Data {
  final String? searchMode;
  final bool? hotelOnly;
  final bool? flightOnly;
  final bool? activityOnly;
  final bool? transferOnly;
  final bool? holidaySearch;
  final num? code;
  final bool? secondAPISearch;
  final String? message;
  final SearchData? searchData;
  final num? totalPackages;
  final List<Package>? packages;
  final PriceRange? priceRange;
  final String? packageId;
  final String? listingUrl;

  Data({
    this.secondAPISearch,
    this.searchMode,
    this.hotelOnly,
    this.flightOnly,
    this.activityOnly,
    this.transferOnly,
    this.holidaySearch,
    this.code,
    this.message,
    this.searchData,
    this.totalPackages,
    this.packages,
    this.priceRange,
    this.packageId,
    this.listingUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        secondAPISearch: json["secondAPISearch"] ?? false,
        searchMode: json["search_mode"],
        hotelOnly: json["hotel_only"],
        flightOnly: json["flight_only"],
        activityOnly: json["activity_only"],
        transferOnly: json["transfer_only"],
        holidaySearch: json["holiday_search"],
        code: json["code"],
        message: json["message"],
        searchData: json["search_data"] == null ? null : SearchData.fromJson(json["search_data"]),
        totalPackages: json["totalPackages"],
        packages: json["packages"] == null
            ? []
            : List<Package>.from(json["packages"]!.map((x) => Package.fromJson(x))),
        priceRange: json["priceRange"] == null ? null : PriceRange.fromJson(json["priceRange"]),
        packageId: json["package_id"],
        listingUrl: json["listing_url"],
      );

  Map<String, dynamic> toJson() => {
        "search_mode": searchMode,
        "hotel_only": hotelOnly,
        "flight_only": flightOnly,
        "activity_only": activityOnly,
        "transfer_only": transferOnly,
        "holiday_search": holidaySearch,
        "code": code,
        "message": message,
        "search_data": searchData?.toJson(),
        "totalPackages": totalPackages,
        "packages": packages == null ? [] : List<dynamic>.from(packages!.map((x) => x.toJson())),
        "priceRange": priceRange?.toJson(),
        "package_id": packageId,
        "listing_url": listingUrl,
      };
}

class Package {
  final FlightDetails? flightDetails;
  final HotelDetails? hotelDetails;
  final String? id;
  final num? packageDays;
  final String? sellingCurrency;
  final Flights? flights;
  final num? flightStop;
  final bool? noFlight;
  final String? paxs;
  final String? fromCity;
  final String? toCity;
  final String? hotelName;
  final String? packageName;
  final String? travelDate;
  final String? hotelImage;
  final List<HotelImage>? hotelImages;
  final num? hotelStar;
  final String? latitude;
  final String? longitude;
  final List<Activity>? activities;
  final List<Transfer>? transfer;
  final Esim? esim;
  final num? total;
  final num? oldPrice;
  final String? responseFrom;

  Package({
    this.hotelDetails,
    this.flightDetails,
    this.id,
    this.packageDays,
    this.sellingCurrency,
    this.flights,
    this.flightStop,
    this.noFlight,
    this.paxs,
    this.fromCity,
    this.toCity,
    this.hotelName,
    this.packageName,
    this.travelDate,
    this.hotelImage,
    this.hotelImages,
    this.hotelStar,
    this.latitude,
    this.longitude,
    this.activities,
    this.transfer,
    this.esim,
    this.total,
    this.oldPrice,
    this.responseFrom,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        hotelDetails: json.containsKey('hotel_details')
            ? json["hotel_details"] == null
                ? null
                : HotelDetails.fromJson(json["hotel_details"])
            : null,
        flightDetails: json.containsKey("flight_details")
            ? json["flight_details"] == null
                ? null
                : FlightDetails.fromJson(json["flight_details"])
            : null,
        id: json["id"],
        packageDays: json["package_days"],
        sellingCurrency: json["selling_currency"],
        flights: json["flights"] == null ? null : Flights.fromJson(json["flights"]),
        flightStop: json["flight_stop"],
        noFlight: json["no_flight"],
        paxs: json["paxs"],
        fromCity: json["from_city"],
        toCity: json["to_city"],
        hotelName: json["hotel_name"],
        packageName: json["package_name"],
        travelDate: json["travel_date"],
        hotelImage: json["hotel_image"],
        hotelImages: json["hotel_images"] == null
            ? []
            : List<HotelImage>.from(json["hotel_images"]!.map((x) => HotelImage.fromJson(x))),
        hotelStar: json["hotel_star"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        activities: json["activities"] == null
            ? []
            : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
        transfer: json["transfer"] == null
            ? []
            : List<Transfer>.from(json["transfer"]!.map((x) => Transfer.fromJson(x))),
        esim: json["esim"] == null ? null : Esim.fromJson(json["esim"]),
        total: json["total"],
        oldPrice: json["old_price"],
        responseFrom: json["response_from"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_days": packageDays,
        "selling_currency": sellingCurrency,
        "flights": flights?.toJson(),
        "flight_stop": flightStop,
        "no_flight": noFlight,
        "paxs": paxs,
        "from_city": fromCity,
        "to_city": toCity,
        "hotel_name": hotelName,
        "package_name": packageName,
        "travel_date": travelDate,
        "hotel_image": hotelImage,
        "hotel_images":
            hotelImages == null ? [] : List<dynamic>.from(hotelImages!.map((x) => x.toJson())),
        "hotel_star": hotelStar,
        "latitude": latitude,
        "longitude": longitude,
        "activities":
            activities == null ? [] : List<dynamic>.from(activities!.map((x) => x.toJson())),
        "transfer": transfer == null ? [] : List<dynamic>.from(transfer!.map((x) => x.toJson())),
        "esim": esim?.toJson(),
        "total": total,
        "old_price": oldPrice,
        "response_from": responseFrom,
      };
}

class Activity {
  final String? name;
  final DateTime? date;

  Activity({
    this.name,
    this.date,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json["name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

class Esim {
  final String? name;
  final String? description;
  final num? dataAmount;
  final List<String>? speed;
  final bool? autostart;
  final List<String>? groups;
  final String? countryName;
  final String? payableCurrency;
  final String? sellingCurrency;
  final double? payableAmount;
  final num? sellingAmount;
  final String? duration;
  final num? roamingCountry;
  final String? roaming;
  final List<String>? roamingEnabled;

  Esim({
    this.name,
    this.description,
    this.dataAmount,
    this.speed,
    this.autostart,
    this.groups,
    this.countryName,
    this.payableCurrency,
    this.sellingCurrency,
    this.payableAmount,
    this.sellingAmount,
    this.duration,
    this.roamingCountry,
    this.roaming,
    this.roamingEnabled,
  });

  factory Esim.fromJson(Map<String, dynamic> json) => Esim(
        name: json["name"],
        description: json["description"],
        dataAmount: json["dataAmount"],
        speed: json["speed"] == null ? [] : List<String>.from(json["speed"]!.map((x) => x)),
        autostart: json["autostart"],
        groups: json["groups"] == null ? [] : List<String>.from(json["groups"]!.map((x) => x)),
        countryName: json["countryName"],
        payableCurrency: json["payableCurrency"],
        sellingCurrency: json["sellingCurrency"],
        payableAmount: json["payableAmount"]?.toDouble(),
        sellingAmount: json["sellingAmount"],
        duration: json["duration"],
        roamingCountry: json["roamingCountry"],
        roaming: json["roaming"],
        roamingEnabled: json["roamingEnabled"] == null
            ? []
            : List<String>.from(json["roamingEnabled"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "dataAmount": dataAmount,
        "speed": speed == null ? [] : List<dynamic>.from(speed!.map((x) => x)),
        "autostart": autostart,
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
        "countryName": countryName,
        "payableCurrency": payableCurrency,
        "sellingCurrency": sellingCurrency,
        "payableAmount": payableAmount,
        "sellingAmount": sellingAmount,
        "duration": duration,
        "roamingCountry": roamingCountry,
        "roaming": roaming,
        "roamingEnabled":
            roamingEnabled == null ? [] : List<dynamic>.from(roamingEnabled!.map((x) => x)),
      };
}

class Flights {
  final String? name;

  Flights({
    this.name,
  });

  factory Flights.fromJson(Map<String, dynamic> json) => Flights(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class HotelImage {
  final String? src;

  HotelImage({
    this.src,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) => HotelImage(
        src: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "src": src,
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
  final String? pickup;
  final String? dropoff;

  Transfer(
      {this.id,
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
      this.pickup,
      this.dropoff});

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
      image: json.containsKey('image') ? json["image"] : null,
      pickup: json.containsKey("pickup") ? json["pickup"] : null,
      dropoff: json.containsKey("dropoff") ? json["dropoff"] : null);

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
        "pickup": pickup,
        "dropoff": dropoff,
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

class PriceRange {
  final double? min;
  final double? max;

  PriceRange({
    this.min,
    this.max,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        min: double.tryParse(json["min"].toString()),
        max: double.tryParse(json["max"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
      };
}

class SearchData {
  final String? travelStart;
  final String? packageStart;
  final String? packageEnd;
  final String? departureCode;
  final String? departureName;
  final String? arrivalCode;
  final String? arrivalName;
  final List<dynamic>? adults;
  final List<num>? firstChildAge;
  final List<num>? secondChildAges;
  final List<bool>? ageOptionOne;
  final List<bool>? ageOptionTwo;
  final num? roomsCount;
  final num? adultsCount;
  final List<dynamic>? children;
  final num? childrenCount;
  final num? totalPassengers;
//  final ChildAge? childAge;
  final List<String>? childrenAges;
  final String? modifyTravelStart;
  final String? modifyTravelEnd;
  final String? flightClass;
  final String? flightCode;
  final String? flightName;
  final String? hotelCode;
  final String? hotelName;
  final String? flightTripType;
  final String? flightTripTypeText;
  final String? fromCity;
  final String? toCity;

  SearchData({
    this.travelStart,
    this.packageStart,
    this.packageEnd,
    this.departureCode,
    this.departureName,
    this.arrivalCode,
    this.arrivalName,
    this.adults,
    this.firstChildAge,
    this.secondChildAges,
    this.ageOptionOne,
    this.ageOptionTwo,
    this.roomsCount,
    this.adultsCount,
    this.children,
    this.childrenCount,
    this.totalPassengers,
    //this.childAge,
    this.childrenAges,
    this.modifyTravelStart,
    this.modifyTravelEnd,
    this.flightClass,
    this.flightCode,
    this.flightName,
    this.hotelCode,
    this.hotelName,
    this.flightTripType,
    this.flightTripTypeText,
    this.fromCity,
    this.toCity,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        travelStart: json["travel_start"],
        packageStart: json["package_start"],
        packageEnd: json["package_end"],
        departureCode: json["departure_code"],
        departureName: json["departure_name"],
        arrivalCode: json["arrival_code"],
        arrivalName: json["arrival_name"],
        adults: json["adults"] == null ? [] : List<dynamic>.from(json["adults"]!.map((x) => x)),
        firstChildAge: json["first_child_age"] == null
            ? []
            : List<num>.from(json["first_child_age"]!.map((x) => x)),
        secondChildAges: json["second_child_ages"] == null
            ? []
            : List<num>.from(json["second_child_ages"]!.map((x) => x)),
        ageOptionOne: json["age_option_one"] == null
            ? []
            : List<bool>.from(json["age_option_one"]!.map((x) => x)),
        ageOptionTwo: json["age_option_two"] == null
            ? []
            : List<bool>.from(json["age_option_two"]!.map((x) => x)),
        roomsCount: json["rooms_count"],
        adultsCount: json["adults_count"],
        children:
            json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
        childrenCount: json["children_count"],
        totalPassengers: json["total_passengers"],
        // childAge: json["child_age"] == null
        //     ? null
        //     : json["child_age"] is List<dynamic>
        //         ? null
        //         : ChildAge.fromJson(json["child_age"]),
        childrenAges: json["childrenAges"] == null
            ? []
            : List<String>.from(json["childrenAges"]!.map((x) => x)),
        modifyTravelStart: json["modify_travel_start"],
        modifyTravelEnd: json["modify_travel_end"],
        flightClass: json["flight_class"],
        flightCode: json["flight_code"],
        flightName: json["flight_name"],
        hotelCode: json["hotelCode"],
        hotelName: json["hotelName"],
        flightTripType: json["flightTripType"].toString(),
        flightTripTypeText: json["flightTripTypeText"],
        fromCity: json["from_city"],
        toCity: json["to_city"],
      );

  Map<String, dynamic> toJson() => {
        "travel_start": travelStart,
        "package_start": packageStart,
        "package_end": packageEnd,
        "departure_code": departureCode,
        "departure_name": departureName,
        "arrival_code": arrivalCode,
        "arrival_name": arrivalName,
        "adults": adults == null ? [] : List<dynamic>.from(adults!.map((x) => x)),
        "first_child_age":
            firstChildAge == null ? [] : List<dynamic>.from(firstChildAge!.map((x) => x)),
        "second_child_ages":
            secondChildAges == null ? [] : List<dynamic>.from(secondChildAges!.map((x) => x)),
        "age_option_one":
            ageOptionOne == null ? [] : List<dynamic>.from(ageOptionOne!.map((x) => x)),
        "age_option_two":
            ageOptionTwo == null ? [] : List<dynamic>.from(ageOptionTwo!.map((x) => x)),
        "rooms_count": roomsCount,
        "adults_count": adultsCount,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
        "children_count": childrenCount,
        "total_passengers": totalPassengers,
        //  "child_age": childAge?.toJson(),
        "childrenAges": childrenAges == null ? [] : List<dynamic>.from(childrenAges!.map((x) => x)),
        "modify_travel_start": modifyTravelStart,
        "modify_travel_end": modifyTravelEnd,
        "flight_class": flightClass,
        "flight_code": flightCode,
        "flight_name": flightName,
        "hotelCode": hotelCode,
        "hotelName": hotelName,
        "flightTripType": flightTripType,
        "flightTripTypeText": flightTripTypeText,
        "from_city": fromCity,
        "to_city": toCity,
      };
}

class ChildAge {
  final The1? the1;

  ChildAge({
    this.the1,
  });

  factory ChildAge.fromJson(Map<String, dynamic> json) => ChildAge(
        the1: json["1"] == null ? null : The1.fromJson(json["1"]),
      );

  Map<String, dynamic> toJson() => {
        "1": the1?.toJson(),
      };
}

class The1 {
  final String? the1;

  The1({
    this.the1,
  });

  factory The1.fromJson(Map<String, dynamic> json) => The1(
        the1: json["1"],
      );

  Map<String, dynamic> toJson() => {
        "1": the1,
      };
}

class FlightDetails {
  final String? tripStart;
  final String? tripEnd;
  final Passenger? passenger;
  final String? flightClass;
  final From? from;
  final To? to;
  final String? flightId;
  final String? prebook;

  FlightDetails({
    this.tripStart,
    this.tripEnd,
    this.passenger,
    this.flightClass,
    this.from,
    this.to,
    this.flightId,
    this.prebook,
  });

  factory FlightDetails.fromJson(Map<String, dynamic> json) => FlightDetails(
        tripStart: json["trip_start"],
        tripEnd: json["trip_end"],
        passenger: json["passenger"] == null ? null : Passenger.fromJson(json["passenger"]),
        flightClass: json["flight_class"],
        from: json["from"] == null ? null : From.fromJson(json["from"]),
        to: json["to"] == null ? null : To.fromJson(json["to"]),
        flightId: json["flight_id"],
        prebook: json["prebook"],
      );

  Map<String, dynamic> toJson() => {
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
  final List<FromItinerary>? itinerary;
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
            : List<FromItinerary>.from(json["itinerary"]!.map((x) => FromItinerary.fromJson(x))),
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

class FromItinerary {
  final Company? company;
  final String? flightNo;
  final Departure? departure;
  final num? flightTime;
  final Arrival? arrival;
  final num? numstops;
  final List<String>? baggageInfo;
  final String? bookingClass;
  final String? cabinClass;
  final num? layover;

  FromItinerary({
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

  factory FromItinerary.fromJson(Map<String, dynamic> json) => FromItinerary(
        company: json["company"] == null ? null : Company.fromJson(json["company"]),
        flightNo: json["flightNo"],
        departure: json["departure"] == null ? null : Departure.fromJson(json["departure"]),
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

class Departure {
  final DateTime? date;
  final String? time;
  final String? locationId;
  final String? timezone;
  final String? airport;
  final String? city;
  final bool? terminal;

  Departure({
    this.date,
    this.time,
    this.locationId,
    this.timezone,
    this.airport,
    this.city,
    this.terminal,
  });

  factory Departure.fromJson(Map<String, dynamic> json) => Departure(
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

class To {
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
  final List<ToItinerary>? itinerary;
  final String? carrierCode;
  final String? carrierName;
  final String? carrierLogo;

  To({
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

  factory To.fromJson(Map<String, dynamic> json) => To(
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
            : List<ToItinerary>.from(json["itinerary"]!.map((x) => ToItinerary.fromJson(x))),
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

class ToItinerary {
  final Company? company;
  final String? flightNo;
  final Arrival? departure;
  final num? flightTime;
  final Departure? arrival;
  final num? numstops;
  final List<String>? baggageInfo;
  final String? bookingClass;
  final String? cabinClass;
  final num? layover;

  ToItinerary({
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

  factory ToItinerary.fromJson(Map<String, dynamic> json) => ToItinerary(
        company: json["company"] == null ? null : Company.fromJson(json["company"]),
        flightNo: json["flightNo"],
        departure: json["departure"] == null ? null : Arrival.fromJson(json["departure"]),
        flightTime: json["flight_time"],
        arrival: json["arrival"] == null ? null : Departure.fromJson(json["arrival"]),
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

class HotelDetails {
  final num? id;
  final String? searchId;
  final String? hotelCode;
  final String? name;
  final String? description;
  final String? starRating;
  final String? destinationCode;
  final String? destinationName;
  final String? checknumext;
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
  final List<HotelImage>? imgAll;
  final List<Room>? rooms;
  final List<String>? facilities;
  final List<dynamic>? selectedRoom;
  final num? roomsRequired;

  HotelDetails({
    this.id,
    this.searchId,
    this.hotelCode,
    this.name,
    this.description,
    this.starRating,
    this.destinationCode,
    this.destinationName,
    this.checknumext,
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
    this.roomsRequired,
  });

  factory HotelDetails.fromJson(Map<String, dynamic> json) => HotelDetails(
        id: json["id"],
        searchId: json["searchId"],
        hotelCode: json["hotelCode"],
        name: json["name"],
        description: json["description"],
        starRating: json["starRating"],
        destinationCode: json["destinationCode"],
        destinationName: json["destinationName"],
        checknumext: json["checknumext"],
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
            : List<HotelImage>.from(json["img_all"]!.map((x) => HotelImage.fromJson(x))),
        rooms: json["rooms"] == null
            ? []
            : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
        facilities:
            json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
        selectedRoom: json["selectedRoom"] == null
            ? []
            : List<dynamic>.from(json["selectedRoom"]!.map((x) => x)),
        roomsRequired: json["rooms_required"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "searchId": searchId,
        "hotelCode": hotelCode,
        "name": name,
        "description": description,
        "starRating": starRating,
        "destinationCode": destinationCode,
        "destinationName": destinationName,
        "checknumext": checknumext,
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
        "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
        "selectedRoom": selectedRoom == null ? [] : List<dynamic>.from(selectedRoom!.map((x) => x)),
        "rooms_required": roomsRequired,
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
