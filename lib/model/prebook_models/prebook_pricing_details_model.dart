 
//final prebookPricingDetails = prebookPricingDetailsFromJson(jsonString);

import 'dart:convert';

PrebookPricingDetails prebookPricingDetailsFromJson(String str) => PrebookPricingDetails.fromJson(json.decode(str));

String prebookPricingDetailsToJson(PrebookPricingDetails data) => json.encode(data.toJson());

class PrebookPricingDetails {
    final int? code;
    final bool? error;
    final String? message;
    final PricingDetails? data;

    PrebookPricingDetails({
        this.code,
        this.error,
        this.message,
        this.data,
    });

    factory PrebookPricingDetails.fromJson(Map<String, dynamic> json) => PrebookPricingDetails(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : PricingDetails.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data?.toJson(),
    };
}

class PricingDetails {
    final PaymentData? paymentData;
    final String? customizeId;
    final String? packageName;
    final DateTime? packageStart;
    final DateTime? packageEnd;
    final int? packageDays;
    final int? adults;
    final int? children;
    final PaymentDetails? paymentDetails;

    PricingDetails({
        this.paymentData,
        this.customizeId,
        this.packageName,
        this.packageStart,
        this.packageEnd,
        this.packageDays,
        this.adults,
        this.children,
        this.paymentDetails,
    });

    factory PricingDetails.fromJson(Map<String, dynamic> json) => PricingDetails(
        paymentData: json["payment_data"] == null ? null : PaymentData.fromJson(json["payment_data"]),
        customizeId: json["customize_id"],
        packageName: json["package_name"],
        packageStart: json["package_start"] == null ? null : DateTime.parse(json["package_start"]),
        packageEnd: json["package_end"] == null ? null : DateTime.parse(json["package_end"]),
        packageDays: json["package_days"],
        adults: json["adults"],
        children: json["children"],
        paymentDetails: json["payment_details"] == null ? null : PaymentDetails.fromJson(json["payment_details"]),
    );

    Map<String, dynamic> toJson() => {
        "payment_data": paymentData?.toJson(),
        "customize_id": customizeId,
        "package_name": packageName,
        "package_start": "${packageStart!.year.toString().padLeft(4, '0')}-${packageStart!.month.toString().padLeft(2, '0')}-${packageStart!.day.toString().padLeft(2, '0')}",
        "package_end": "${packageEnd!.year.toString().padLeft(4, '0')}-${packageEnd!.month.toString().padLeft(2, '0')}-${packageEnd!.day.toString().padLeft(2, '0')}",
        "package_days": packageDays,
        "adults": adults,
        "children": children,
        "payment_details": paymentDetails?.toJson(),
    };
}

class PaymentData {
    final String? paymentUrl;
    final String? gateway;
    final String? currency;
    final String? transactionFees;
    final String? ibhAmount;
    final String? totalAmount;
    final String? streamApi;
    final dynamic streamApiTest;

    PaymentData({
        this.paymentUrl,
        this.gateway,
        this.currency,
        this.transactionFees,
        this.ibhAmount,
        this.totalAmount,
        this.streamApi,
        this.streamApiTest,
    });

    factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        paymentUrl: json["payment_url"],
        gateway: json["gateway"],
        currency: json["currency"],
        transactionFees: json["transaction_fees"],
        ibhAmount: json["ibh_amount"],
        totalAmount: json["total_amount"],
        streamApi: json["stream_api"],
        streamApiTest: json["stream_api_test"],
    );

    Map<String, dynamic> toJson() => {
        "payment_url": paymentUrl,
        "gateway": gateway,
        "currency": currency,
        "transaction_fees": transactionFees,
        "ibh_amount": ibhAmount,
        "total_amount": totalAmount,
        "stream_api": streamApi,
        "stream_api_test": streamApiTest,
    };
}

class PaymentDetails {
    final String? userCurrency;
    final String? packageAmountWithoutAnyDiscount;
    final String? packageAmountWithCouponDiscount;
    final String? packageAmountWithCouponWithCredit;
    final String? packageAmountWithCouponWithCreditWithOtherDiscounts;
    final String? transactionFees;
    final String? finalSellingAmount;
    final bool? payFullAmountByCredit;
    final bool? payPartialAmountByCredit;
    final Discounts? discounts;

    PaymentDetails({
        this.userCurrency,
        this.packageAmountWithoutAnyDiscount,
        this.packageAmountWithCouponDiscount,
        this.packageAmountWithCouponWithCredit,
        this.packageAmountWithCouponWithCreditWithOtherDiscounts,
        this.transactionFees,
        this.finalSellingAmount,
        this.payFullAmountByCredit,
        this.payPartialAmountByCredit,
        this.discounts,
    });

    factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        userCurrency: json["user_currency"],
        packageAmountWithoutAnyDiscount: json["package_amount_without_any_discount"],
        packageAmountWithCouponDiscount: json["package_amount_with_coupon_discount"],
        packageAmountWithCouponWithCredit: json["package_amount_with_coupon_with_credit"],
        packageAmountWithCouponWithCreditWithOtherDiscounts: json["package_amount_with_coupon_with_credit_with_other_discounts"],
        transactionFees: json["transaction_fees"],
        finalSellingAmount: json["final_selling_amount"],
        payFullAmountByCredit: json["pay_full_amount_by_credit"],
        payPartialAmountByCredit: json["pay_partial_amount_by_credit"],
        discounts: json["discounts"] == null ? null : Discounts.fromJson(json["discounts"]),
    );

    Map<String, dynamic> toJson() => {
        "user_currency": userCurrency,
        "package_amount_without_any_discount": packageAmountWithoutAnyDiscount,
        "package_amount_with_coupon_discount": packageAmountWithCouponDiscount,
        "package_amount_with_coupon_with_credit": packageAmountWithCouponWithCredit,
        "package_amount_with_coupon_with_credit_with_other_discounts": packageAmountWithCouponWithCreditWithOtherDiscounts,
        "transaction_fees": transactionFees,
        "final_selling_amount": finalSellingAmount,
        "pay_full_amount_by_credit": payFullAmountByCredit,
        "pay_partial_amount_by_credit": payPartialAmountByCredit,
        "discounts": discounts?.toJson(),
    };
}

class Discounts {
    final Coupons? totalDiscount;
    final Coupons? credit;
    final Coupons? gamePointsDiscount;
    final Coupons? coupons;

    Discounts({
        this.totalDiscount,
        this.credit,
        this.gamePointsDiscount,
        this.coupons,
    });

    factory Discounts.fromJson(Map<String, dynamic> json) => Discounts(
        totalDiscount: json["total_discount"] == null ? null : Coupons.fromJson(json["total_discount"]),
        credit: json["credit"] == null ? null : Coupons.fromJson(json["credit"]),
        gamePointsDiscount: json["game_points_discount"] == null ? null : Coupons.fromJson(json["game_points_discount"]),
        coupons: json["coupons"] == null ? null : Coupons.fromJson(json["coupons"]),
    );

    Map<String, dynamic> toJson() => {
        "total_discount": totalDiscount?.toJson(),
        "credit": credit?.toJson(),
        "game_points_discount": gamePointsDiscount?.toJson(),
        "coupons": coupons?.toJson(),
    };
}

class Coupons {
    final String? currency;
    final String? amount;
    final String? userCurrency;
    final String? userAmount;

    Coupons({
        this.currency,
        this.amount,
        this.userCurrency,
        this.userAmount,
    });

    factory Coupons.fromJson(Map<String, dynamic> json) => Coupons(
        currency: json["currency"],
        amount: json["amount"],
        userCurrency: json["user_currency"],
        userAmount: json["user_amount"],
    );

    Map<String, dynamic> toJson() => {
        "currency": currency,
        "amount": amount,
        "user_currency": userCurrency,
        "user_amount": userAmount,
    };
}
