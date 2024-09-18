// To parse this JSON data, do
//
//     final flightsListingModel = flightsListingModelFromJson(jsonString);

import 'dart:convert';

FlightsListingModel flightsListingModelFromJson(String str) =>
    FlightsListingModel.fromJson(json.decode(str));

String flightsListingModelToJson(FlightsListingModel data) => json.encode(data.toJson());

class FlightsListingModel {
  final bool? error;
  final List<FlightData>? data;

  FlightsListingModel({
    this.error,
    this.data,
  });

  factory FlightsListingModel.fromJson(Map<String, dynamic> json) => FlightsListingModel(
        error: json["error"],
        data: json["data"] == null
            ? []
            : List<FlightData>.from(json["data"]!.map((x) => FlightData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FlightData {
  final String? flightId;
  final Carrier? carrier;
  final String? currency;
  final num? priceDiff;
  final num? priceGroup;
  final FlightFrom? from;
  final FlightFrom? to;

  FlightData({
    this.flightId,
    this.carrier,
    this.currency,
    this.priceDiff,
    this.priceGroup,
    this.from,
    this.to,
  });

  factory FlightData.fromJson(Map<String, dynamic> json) => FlightData(
        flightId: json["flight_id"],
        carrier: json["carrier"] == null ? null : Carrier.fromJson(json["carrier"]),
        currency: json["currency"],
        priceDiff: json["priceDiff"],
        priceGroup: json["priceGroup"],
        from: json["from"] == null ? null : FlightFrom.fromJson(json["from"]),
        to: json["to"] == null ? null : FlightFrom.fromJson(json["to"]),
      );

  Map<String, dynamic> toJson() => {
        "flight_id": flightId,
        "carrier": carrier?.toJson(),
        "currency": currency,
        "priceDiff": priceDiff,
        "priceGroup": priceGroup,
        "from": from?.toJson(),
        "to": to?.toJson(),
      };
}

class Carrier {
  final String? name;
  final String? code;
  final String? label;

  Carrier({
    this.name,
    this.code,
    this.label,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
        name: json["name"],
        code: json["code"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "label": label,
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
        name: json["name"] ?? '',
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

class FlightFrom {
  final num? numstops;
  final List<String>? stops;
  final String? departureCity;
  final String? arrivalCity;
  final String? departureCityCode;
  final String? arrivalCityCode;
  final String? arrivalDate;
  final DateTime? arrivalFdate;
  final String? arrivalTime;
  final String? carrierImage;
  final String? departureDate;
  final DateTime? departureFdate;
  final String? departureTime;
  final num? arrivalDays;
  final String? travelTime;
  final List<FromItinerary>? itinerary;

  FlightFrom({
    this.numstops,
    this.stops,
    this.departureCity,
    this.arrivalCity,
    this.departureCityCode,
    this.arrivalCityCode,
    this.arrivalDate,
    this.arrivalFdate,
    this.arrivalTime,
    this.carrierImage,
    this.departureDate,
    this.departureFdate,
    this.departureTime,
    this.arrivalDays,
    this.travelTime,
    this.itinerary,
  });

  factory FlightFrom.fromJson(Map<String, dynamic> json) => FlightFrom(
        numstops: json["numstops"],
        stops: json["stops"] == null ? [] : List<String>.from(json["stops"]!.map((x) => x)),
        departureCity: json["departure_city"],
        arrivalCity: json["arrival_city"],
        departureCityCode: json["departure_city_code"],
        arrivalCityCode: json["arrival_city_code"],
        arrivalDate: json["arrival_date"],
        arrivalFdate: json["arrival_fdate"] == null ? null : DateTime.parse(json["arrival_fdate"]),
        arrivalTime: json["arrival_time"],
        carrierImage: json["carrier_image"],
        departureDate: json["departure_date"],
        departureFdate:
            json["departure_fdate"] == null ? null : DateTime.parse(json["departure_fdate"]),
        departureTime: json["departure_time"],
        arrivalDays: json["arrival_days"],
        travelTime: json["travel_time"],
        itinerary: json["itinerary"] == null
            ? []
            : List<FromItinerary>.from(json["itinerary"]!.map((x) => FromItinerary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "numstops": numstops,
        "stops": stops == null ? [] : List<dynamic>.from(stops!.map((x) => x)),
        "departure_city": departureCity,
        "arrival_city": arrivalCity,
        "departure_city_code": departureCityCode,
        "arrival_city_code": arrivalCityCode,
        "arrival_date": arrivalDate,
        "arrival_fdate":
            "${arrivalFdate!.year.toString().padLeft(4, '0')}-${arrivalFdate!.month.toString().padLeft(2, '0')}-${arrivalFdate!.day.toString().padLeft(2, '0')}",
        "arrival_time": arrivalTime,
        "carrier_image": carrierImage,
        "departure_date": departureDate,
        "departure_fdate":
            "${departureFdate!.year.toString().padLeft(4, '0')}-${departureFdate!.month.toString().padLeft(2, '0')}-${departureFdate!.day.toString().padLeft(2, '0')}",
        "departure_time": departureTime,
        "arrival_days": arrivalDays,
        "travel_time": travelTime,
        "itinerary": itinerary == null ? [] : List<dynamic>.from(itinerary!.map((x) => x.toJson())),
      };
}
