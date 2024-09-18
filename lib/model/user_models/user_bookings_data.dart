// final userBookingsDataModel = userBookingsDataModelFromJson(jsonString);

import 'dart:convert';

UserBookingsDataModel userBookingsDataModelFromJson(String str) =>
    UserBookingsDataModel.fromJson(json.decode(str));

String userBookingsDataModelToJson(UserBookingsDataModel data) => json.encode(data.toJson());

class UserBookingsDataModel {
  final int? code;
  final bool? error;
  final String? message;
  final List<BookingData>? data;

  UserBookingsDataModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory UserBookingsDataModel.fromJson(Map<String, dynamic> json) => UserBookingsDataModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<BookingData>.from(json["data"]!.map((x) => BookingData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BookingData {
  final String? packageName;
  final String? currency;
  final String? amount;
  final String? amountPayed;
  final String? discountAmount;
  final String? creditBalanceUsed;
  final bool? expired;
  final bool? activeBooking;
  final int? statusId;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? paxName;
  final List<BookedHotel>? hotel;
  final List<ServiceData>? flight;
  final List<ServiceData>? transfer;
  final List<ServiceData>? activity;
  final List<ServiceData>? esim;
  final String? esimViewUrl;
  final String? bookingNumber;
  final List<dynamic>? rooms;
  final DateTime? bookingDate;
  final String? destination;
  final String? voucherDetails;
  final bool? canCancel;

  BookingData({
    this.packageName,
    this.currency,
    this.amount,
    this.amountPayed,
    this.discountAmount,
    this.creditBalanceUsed,
    this.expired,
    this.activeBooking,
    this.statusId,
    this.status,
    this.startDate,
    this.endDate,
    this.paxName,
    this.hotel,
    this.flight,
    this.transfer,
    this.activity,
    this.esim,
    this.esimViewUrl,
    this.bookingNumber,
    this.rooms,
    this.bookingDate,
    this.destination,
    this.voucherDetails,
    this.canCancel,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
        packageName: json["packageName"],
        currency: json["currency"],
        amount: json["amount"],
        amountPayed: json["amount_payed"],
        discountAmount: json["discount_amount"],
        creditBalanceUsed: json["credit_balance_used"],
        expired: json["expired"],
        activeBooking: json["activeBooking"],
        statusId: json["statusId"],
        status: json["status"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        paxName: json["paxName"],
        hotel: json["hotel"] == null
            ? null
            : List<BookedHotel>.from(json["hotel"].map((x) => BookedHotel.fromJson(x))),
        flight: json["flight"] == null
            ? []
            : List<ServiceData>.from(json["flight"]!.map((x) => ServiceData.fromJson(x))),
        transfer: json["transfer"] == null
            ? []
            : List<ServiceData>.from(json["transfer"]!.map((x) => ServiceData.fromJson(x))),
        activity: json["activity"] == null
            ? []
            : List<ServiceData>.from(json["activity"]!.map((x) => ServiceData.fromJson(x))),
        esim: json["esim"] == null
            ? []
            : List<ServiceData>.from(json["esim"]!.map((x) => ServiceData.fromJson(x))),
        esimViewUrl: json["esimViewUrl"],
        bookingNumber: json["bookingNumber"],
        rooms: json["rooms"] == null ? [] : List<dynamic>.from(json["rooms"]!.map((x) => x)),
        bookingDate: json["bookingDate"] == null ? null : DateTime.parse(json["bookingDate"]),
        destination: json["destination"],
        voucherDetails: json["voucher_details"],
        canCancel: json["can_cancel"],
      );

  Map<String, dynamic> toJson() => {
        "packageName": packageName,
        "currency": currency,
        "amount": amount,
        "amount_payed": amountPayed,
        "discount_amount": discountAmount,
        "credit_balance_used": creditBalanceUsed,
        "expired": expired,
        "activeBooking": activeBooking,
        "statusId": statusId,
        "status": status,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "paxName": paxName,
        "hotel": hotel == null ? [] : List<dynamic>.from(hotel!.map((x) => x)),
        "flight": flight == null ? [] : List<dynamic>.from(flight!.map((x) => x.toJson())),
        "transfer": transfer == null ? [] : List<dynamic>.from(transfer!.map((x) => x)),
        "activity": activity == null ? [] : List<dynamic>.from(activity!.map((x) => x)),
        "esim": esim == null ? [] : List<dynamic>.from(esim!.map((x) => x)),
        "esimViewUrl": esimViewUrl,
        "bookingNumber": bookingNumber,
        "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x)),
        "bookingDate":
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "destination": destination,
        "voucher_details": voucherDetails,
        "can_cancel": canCancel,
      };
}

class ServiceData {
  final int? id;
  final int? bookingSectorId;
  final int? bookingMasterId;
  final String? bookingReference;
  final String? supplierReference;
  final int? serviceType;
  final String? serviceName;
  final dynamic serviceRouteType;
  final String? serviceDescription;
  final String? leadPaxName;
  final String? startDate;
  final String? endDate;
  final int? supplierId;
  final String? payableCurrency;
  final String? sellingCurrency;
  final String? payableToBaseRate;
  final String? sellingToBaseRate;
  final int? payableAmount;
  final int? sellingAmount;
  final int? canceled;
  final String? canceledOn;
  final int? canceledBy;
  final int? approved;
  final int? approvedBy;
  final String? approvedOn;
  final int? bookingStatus;
  final String? comments;
  final dynamic internalReference;
  final dynamic newBooking;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AmadeusBookings? amadeusBookings;

  ServiceData({
    this.id,
    this.bookingSectorId,
    this.bookingMasterId,
    this.bookingReference,
    this.supplierReference,
    this.serviceType,
    this.serviceName,
    this.serviceRouteType,
    this.serviceDescription,
    this.leadPaxName,
    this.startDate,
    this.endDate,
    this.supplierId,
    this.payableCurrency,
    this.sellingCurrency,
    this.payableToBaseRate,
    this.sellingToBaseRate,
    this.payableAmount,
    this.sellingAmount,
    this.canceled,
    this.canceledOn,
    this.canceledBy,
    this.approved,
    this.approvedBy,
    this.approvedOn,
    this.bookingStatus,
    this.comments,
    this.internalReference,
    this.newBooking,
    this.createdAt,
    this.updatedAt,
    this.amadeusBookings,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
        id: json["id"],
        bookingSectorId: json["BookingSectorId"],
        bookingMasterId: json["BookingMasterId"],
        bookingReference: json["BookingReference"],
        supplierReference: json["SupplierReference"],
        serviceType: json["ServiceType"],
        serviceName: json["ServiceName"],
        serviceRouteType: json["ServiceRouteType"],
        serviceDescription: json["ServiceDescription"],
        leadPaxName: json["LeadPaxName"],
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        supplierId: json["SupplierId"],
        payableCurrency: json["PayableCurrency"],
        sellingCurrency: json["SellingCurrency"],
        payableToBaseRate: json["PayableToBaseRate"],
        sellingToBaseRate: json["SellingToBaseRate"],
        payableAmount: json["PayableAmount"],
        sellingAmount: json["SellingAmount"],
        canceled: json["Canceled"],
        canceledOn: json["CanceledOn"],
        canceledBy: json["CanceledBy"],
        approved: json["Approved"],
        approvedBy: json["ApprovedBy"],
        approvedOn: json["ApprovedOn"],
        bookingStatus: json["BookingStatus"],
        comments: json["Comments"],
        internalReference: json["InternalReference"],
        newBooking: json["NewBooking"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        amadeusBookings: json["amadeus_bookings"] == null
            ? null
            : AmadeusBookings.fromJson(json["amadeus_bookings"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "BookingSectorId": bookingSectorId,
        "BookingMasterId": bookingMasterId,
        "BookingReference": bookingReference,
        "SupplierReference": supplierReference,
        "ServiceType": serviceType,
        "ServiceName": serviceName,
        "ServiceRouteType": serviceRouteType,
        "ServiceDescription": serviceDescription,
        "LeadPaxName": leadPaxName,
        "StartDate": startDate,
        "EndDate": endDate,
        "SupplierId": supplierId,
        "PayableCurrency": payableCurrency,
        "SellingCurrency": sellingCurrency,
        "PayableToBaseRate": payableToBaseRate,
        "SellingToBaseRate": sellingToBaseRate,
        "PayableAmount": payableAmount,
        "SellingAmount": sellingAmount,
        "Canceled": canceled,
        "CanceledOn": canceledOn,
        "CanceledBy": canceledBy,
        "Approved": approved,
        "ApprovedBy": approvedBy,
        "ApprovedOn": approvedOn,
        "BookingStatus": bookingStatus,
        "Comments": comments,
        "InternalReference": internalReference,
        "NewBooking": newBooking,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "amadeus_bookings": amadeusBookings?.toJson(),
      };
}

class AmadeusBookings {
  final int? id;
  final int? bookingId;
  final String? pnrNo;
  final int? userId;
  final String? email;
  final String? mobile;
  final String? payableCurrency;
  final int? payableBase;
  final int? payableTax;
  final int? payableTotal;
  final String? sellingCurrency;
  final int? sellingBase;
  final int? sellingTax;
  final int? sellingTotal;
  final int? searchId;
  final String? searchIndex;
  final int? transactionId;
  final int? refundable;
  final String? cancellationCurrency;
  final int? cancellationAmount;
  final int? ticketIssued;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Segment>? segments;
  final List<Traveller>? travellers;

  AmadeusBookings({
    this.id,
    this.bookingId,
    this.pnrNo,
    this.userId,
    this.email,
    this.mobile,
    this.payableCurrency,
    this.payableBase,
    this.payableTax,
    this.payableTotal,
    this.sellingCurrency,
    this.sellingBase,
    this.sellingTax,
    this.sellingTotal,
    this.searchId,
    this.searchIndex,
    this.transactionId,
    this.refundable,
    this.cancellationCurrency,
    this.cancellationAmount,
    this.ticketIssued,
    this.createdAt,
    this.updatedAt,
    this.segments,
    this.travellers,
  });

  factory AmadeusBookings.fromJson(Map<String, dynamic> json) => AmadeusBookings(
        id: json["id"],
        bookingId: json["booking_id"],
        pnrNo: json["pnr_no"],
        userId: json["user_id"],
        email: json["email"],
        mobile: json["mobile"],
        payableCurrency: json["payable_currency"],
        payableBase: json["payable_base"],
        payableTax: json["payable_tax"],
        payableTotal: json["payable_total"],
        sellingCurrency: json["selling_currency"],
        sellingBase: json["selling_base"],
        sellingTax: json["selling_tax"],
        sellingTotal: json["selling_total"],
        searchId: json["search_id"],
        searchIndex: json["search_index"],
        transactionId: json["transaction_id"],
        refundable: json["refundable"],
        cancellationCurrency: json["cancellation_currency"],
        cancellationAmount: json["cancellation_amount"],
        ticketIssued: json["ticket_issued"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        segments: json["segments"] == null
            ? []
            : List<Segment>.from(json["segments"]!.map((x) => Segment.fromJson(x))),
        travellers: json["travellers"] == null
            ? []
            : List<Traveller>.from(json["travellers"]!.map((x) => Traveller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "pnr_no": pnrNo,
        "user_id": userId,
        "email": email,
        "mobile": mobile,
        "payable_currency": payableCurrency,
        "payable_base": payableBase,
        "payable_tax": payableTax,
        "payable_total": payableTotal,
        "selling_currency": sellingCurrency,
        "selling_base": sellingBase,
        "selling_tax": sellingTax,
        "selling_total": sellingTotal,
        "search_id": searchId,
        "search_index": searchIndex,
        "transaction_id": transactionId,
        "refundable": refundable,
        "cancellation_currency": cancellationCurrency,
        "cancellation_amount": cancellationAmount,
        "ticket_issued": ticketIssued,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "segments": segments == null ? [] : List<dynamic>.from(segments!.map((x) => x.toJson())),
        "travellers":
            travellers == null ? [] : List<dynamic>.from(travellers!.map((x) => x.toJson())),
      };
}

class Segment {
  final int? id;
  final int? flightBookingId;
  final int? numstops;
  final int? stops;
  final String? carriers;
  final DateTime? dDate;
  final String? dLocation;
  final String? dTerminal;
  final DateTime? aDate;
  final String? aLocation;
  final String? aTerminal;
  final String? travelTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Segment({
    this.id,
    this.flightBookingId,
    this.numstops,
    this.stops,
    this.carriers,
    this.dDate,
    this.dLocation,
    this.dTerminal,
    this.aDate,
    this.aLocation,
    this.aTerminal,
    this.travelTime,
    this.createdAt,
    this.updatedAt,
  });

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        id: json["id"],
        flightBookingId: json["flight_booking_id"],
        numstops: json["numstops"],
        stops: json["stops"],
        carriers: json["carriers"],
        dDate: json["d_date"] == null ? null : DateTime.parse(json["d_date"]),
        dLocation: json["d_location"],
        dTerminal: json["d_terminal"],
        aDate: json["a_date"] == null ? null : DateTime.parse(json["a_date"]),
        aLocation: json["a_location"],
        aTerminal: json["a_terminal"],
        travelTime: json["travel_time"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flight_booking_id": flightBookingId,
        "numstops": numstops,
        "stops": stops,
        "carriers": carriers,
        "d_date": dDate?.toIso8601String(),
        "d_location": dLocation,
        "d_terminal": dTerminal,
        "a_date": aDate?.toIso8601String(),
        "a_location": aLocation,
        "a_terminal": aTerminal,
        "travel_time": travelTime,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Traveller {
  final int? id;
  final int? flightBookingId;
  final String? type;
  final String? title;
  final String? firstname;
  final String? lastname;
  final DateTime? dob;
  final dynamic ticketNo;
  final dynamic cancelled;
  final dynamic cancelType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Traveller({
    this.id,
    this.flightBookingId,
    this.type,
    this.title,
    this.firstname,
    this.lastname,
    this.dob,
    this.ticketNo,
    this.cancelled,
    this.cancelType,
    this.createdAt,
    this.updatedAt,
  });

  factory Traveller.fromJson(Map<String, dynamic> json) => Traveller(
        id: json["id"],
        flightBookingId: json["flight_booking_id"],
        type: json["type"],
        title: json["title"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        ticketNo: json["ticket_no"],
        cancelled: json["cancelled"],
        cancelType: json["cancel_type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flight_booking_id": flightBookingId,
        "type": type,
        "title": title,
        "firstname": firstname,
        "lastname": lastname,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "ticket_no": ticketNo,
        "cancelled": cancelled,
        "cancel_type": cancelType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class BookedHotel {
  BookedHotel({
    required this.id,
    required this.bookingSectorId,
    required this.bookingMasterId,
    required this.bookingReference,
    required this.supplierReference,
    required this.serviceType,
    required this.serviceName,
    required this.serviceRouteType,
    required this.serviceDescription,
    required this.leadPaxName,
    required this.startDate,
    required this.endDate,
    required this.supplierId,
    required this.payableCurrency,
    required this.sellingCurrency,
    required this.payableToBaseRate,
    required this.sellingToBaseRate,
    required this.payableAmount,
    required this.sellingAmount,
    required this.canceled,
    required this.canceledOn,
    required this.canceledBy,
    required this.approved,
    required this.approvedBy,
    required this.approvedOn,
    required this.bookingStatus,
    required this.comments,
    required this.internalReference,
    required this.newBooking,
    required this.createdAt,
    required this.updatedAt,
    required this.hotelBookings,
  });

  int? id;
  String? bookingSectorId;
  String? bookingMasterId;
  String? bookingReference;
  String? supplierReference;
  String? serviceType;
  String? serviceName;
  dynamic serviceRouteType;
  String? serviceDescription;
  String? leadPaxName;
  String? startDate;
  String? endDate;
  String? supplierId;
  String? payableCurrency;
  String? sellingCurrency;
  String? payableToBaseRate;
  String? sellingToBaseRate;
  String? payableAmount;
  String? sellingAmount;
  String? canceled;
  String? canceledOn;
  String? canceledBy;
  String? approved;
  String? approvedBy;
  String? approvedOn;
  String? bookingStatus;
  String? comments;
  dynamic internalReference;
  dynamic newBooking;
  String? createdAt;
  String? updatedAt;
  HotelBookings? hotelBookings;

  factory BookedHotel.fromJson(Map<String, dynamic> json) => BookedHotel(
        id: json["id"],
        bookingSectorId: json["BookingSectorId"].toString(),
        bookingMasterId: json["BookingMasterId"].toString(),
        bookingReference: json["BookingReference"].toString(),
        supplierReference: json["SupplierReference"].toString(),
        serviceType: json["ServiceType"].toString(),
        serviceName: json["ServiceName"].toString(),
        serviceRouteType: json["ServiceRouteType"].toString(),
        serviceDescription: json["ServiceDescription"].toString(),
        leadPaxName: json["LeadPaxName"].toString(),
        startDate: json["StartDate"].toString(),
        endDate: json["EndDate"].toString(),
        supplierId: json["SupplierId"].toString(),
        payableCurrency: json["PayableCurrency"].toString(),
        sellingCurrency: json["SellingCurrency"].toString(),
        payableToBaseRate: json["PayableToBaseRate"].toString(),
        sellingToBaseRate: json["SellingToBaseRate"].toString(),
        payableAmount: json["PayableAmount"].toString(),
        sellingAmount: json["SellingAmount"].toString(),
        canceled: json["Canceled"].toString(),
        canceledOn: json["CanceledOn"].toString(),
        canceledBy: json["CanceledBy"].toString(),
        approved: json["Approved"].toString(),
        approvedBy: json["ApprovedBy"].toString(),
        approvedOn: json["ApprovedOn"].toString(),
        bookingStatus: json["BookingStatus"].toString(),
        comments: json["Comments"].toString(),
        internalReference: json["InternalReference"],
        newBooking: json["NewBooking"],
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        hotelBookings:
            json["hotel_bookings"] == null ? null : HotelBookings.fromJson(json["hotel_bookings"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "BookingSectorId": bookingSectorId,
        "BookingMasterId": bookingMasterId,
        "BookingReference": bookingReference,
        "SupplierReference": supplierReference,
        "ServiceType": serviceType,
        "ServiceName": serviceName,
        "ServiceRouteType": serviceRouteType,
        "ServiceDescription": serviceDescription,
        "LeadPaxName": leadPaxName,
        "StartDate": startDate,
        "EndDate": endDate,
        "SupplierId": supplierId,
        "PayableCurrency": payableCurrency,
        "SellingCurrency": sellingCurrency,
        "PayableToBaseRate": payableToBaseRate,
        "SellingToBaseRate": sellingToBaseRate,
        "PayableAmount": payableAmount,
        "SellingAmount": sellingAmount,
        "Canceled": canceled,
        "CanceledOn": canceledOn,
        "CanceledBy": canceledBy,
        "Approved": approved,
        "ApprovedBy": approvedBy,
        "ApprovedOn": approvedOn,
        "BookingStatus": bookingStatus,
        "Comments": comments,
        "InternalReference": internalReference,
        "NewBooking": newBooking,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "hotel_bookings": hotelBookings == null ? null : hotelBookings!.toJson(),
      };
}

class HotelBookings {
  HotelBookings({
    required this.id,
    required this.bookingId,
    required this.searchId,
    required this.userId,
    required this.reference,
    required this.namePrefix,
    required this.name,
    required this.surname,
    required this.email,
    required this.mobile,
    required this.mainGuestOnly,
    required this.remarks,
    required this.date,
    required this.status,
    required this.payableCurrency,
    required this.payableTotal,
    required this.currency,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.rooms,
    required this.hotels,
  });

  int? id;
  String? bookingId;
  String? searchId;
  String? userId;
  String? reference;
  String? namePrefix;
  String? name;
  String? surname;
  String? email;
  String? mobile;
  String? mainGuestOnly;
  String? remarks;
  DateTime? date;
  String? status;
  String? payableCurrency;
  String? payableTotal;
  String? currency;
  String? total;
  String? createdAt;
  String? updatedAt;
  List<BookedRoom>? rooms;
  Hotels? hotels;

  factory HotelBookings.fromJson(Map<String, dynamic> json) => HotelBookings(
        id: json["id"],
        bookingId: json["booking_id"].toString(),
        searchId: json["search_id"].toString(),
        userId: json["user_id"].toString(),
        reference: json["reference"].toString(),
        namePrefix: json["name_prefix"].toString(),
        name: json["name"].toString(),
        surname: json["surname"].toString(),
        email: json["email"].toString(),
        mobile: json["mobile"].toString(),
        mainGuestOnly: json["main_guest_only"].toString(),
        remarks: json["remarks"].toString(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        status: json["status"].toString(),
        payableCurrency: json["payable_currency"].toString(),
        payableTotal: json["payable_total"].toString(),
        currency: json["currency"].toString(),
        total: json["total"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        rooms: json["rooms"] == null
            ? null
            : List<BookedRoom>.from(json["rooms"].map((x) => BookedRoom.fromJson(x))),
        hotels: json["hotels"] == null ? null : Hotels.fromJson(json["hotels"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "search_id": searchId,
        "user_id": userId,
        "reference": reference,
        "name_prefix": namePrefix,
        "name": name,
        "surname": surname,
        "email": email,
        "mobile": mobile,
        "main_guest_only": mainGuestOnly,
        "remarks": remarks,
        "date": date == null
            ? null
            : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "status": status,
        "payable_currency": payableCurrency,
        "payable_total": payableTotal,
        "currency": currency,
        "total": total,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "rooms": rooms == null ? null : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "hotels": hotels == null ? null : hotels!.toJson(),
      };
}

class Hotels {
  Hotels({
    required this.id,
    required this.bookingId,
    required this.code,
    required this.name,
    required this.destinationCode,
    required this.destinationName,
    required this.countryCode,
    required this.countryName,
    required this.checkIn,
    required this.checkOut,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? bookingId;
  String? code;
  String? name;
  String? destinationCode;
  String? destinationName;
  String? countryCode;
  String? countryName;
  DateTime? checkIn;
  DateTime? checkOut;
  String? createdAt;
  String? updatedAt;

  factory Hotels.fromJson(Map<String, dynamic> json) => Hotels(
        id: json["id"],
        bookingId: json["booking_id"],
        code: json["code"],
        name: json["name"],
        destinationCode: json["destination_code"],
        destinationName: json["destination_name"],
        countryCode: json["country_code"],
        countryName: json["country_name"],
        checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
        checkOut: json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "code": code,
        "name": name,
        "destination_code": destinationCode,
        "destination_name": destinationName,
        "country_code": countryCode,
        "country_name": countryName,
        "check_in": checkIn == null
            ? null
            : "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
        "check_out": checkOut == null
            ? null
            : "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class BookedRoom {
  BookedRoom({
    required this.id,
    required this.bookingHotelId,
    required this.roomId,
    required this.code,
    required this.name,
    required this.pax,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? bookingHotelId;
  String? roomId;
  String? code;
  String? name;
  String? pax;
  String? status;
  String? createdAt;
  String? updatedAt;

  factory BookedRoom.fromJson(Map<String, dynamic> json) => BookedRoom(
        id: json["id"],
        bookingHotelId: json["booking_hotel_id"],
        roomId: json["room_id"],
        code: json["code"],
        name: json["name"],
        pax: json["pax"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_hotel_id": bookingHotelId,
        "room_id": roomId,
        "code": code,
        "name": name,
        "pax": pax,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
