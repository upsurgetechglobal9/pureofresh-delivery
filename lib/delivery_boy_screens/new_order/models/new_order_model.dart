// To parse this JSON data, do
//
//     final newOrderDetailsModel = newOrderDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NewOrderDetailsModel newOrderDetailsModelFromJson(String str) =>
    NewOrderDetailsModel.fromJson(json.decode(str));

String newOrderDetailsModelToJson(NewOrderDetailsModel data) =>
    json.encode(data.toJson());

class NewOrderDetailsModel {
  String errCode;
  String title;
  Data data;

  NewOrderDetailsModel({
    required this.errCode,
    required this.title,
    required this.data,
  });

  factory NewOrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      NewOrderDetailsModel(
        errCode: json["err_code"],
        title: json["title"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "data": data.toJson(),
      };
}

class Data {
  String refId;
  String couponId;
  String couponCode;
  String couponPromotionBy;
  String serviceDate;
  String paymentMode;
  String paymentRefNumber;
  String mainAmountForCommission;
  String subTotal;
  String appliedTaxAmount;
  String appliedDiscountAmount;
  String appliedDeliveryCharge;
  String deliveryPersonCharges;
  String grandTotal;
  String throughWalletAmount;
  String paymentStatus;
  String serviceStatus;
  String restaurantLat;
  String restaurantLng;
  String deliveryLat;
  String deliveryLng;
  String landmark;
  String doorNo;
  String address;
  String addressType;
  String restaurantOrderAcceptedAt;
  String restaurantOrderRejectedAt;
  String rejectedReason;
  String deliveryPersonAcceptedAt;
  String pickedupAcceptedAt;
  String deliveryPersonsId;
  String deliveryPersonName;
  String deliveryPersonContactNumber;
  String outForDeliveryAt;
  String deliveredAt;
  String restaurantCommissionType;
  String restaurantCommissionValue;
  String restaurantCommissionAmount;
  String gstOnCommission;
  String promotionAmount;
  String payableAmountToRestaurant;
  String restaurantFeedBack;
  String restaurantRating;
  String deliveryPersonFeedback;
  String deliveryPersonRating;
  String otherFeedbackText;
  String feedbackGivenDate;
  String paymentRefundedNumber;
  String remark;
  String instamojoPaymentRequestId;
  String paymentCollectedBy;
  String deliveryPersonEarningAmount;
  String deliveryDistance;
  String distanceToCustomerFromStore;
  String deliveryOtp;
  String city;
  String paymentGateway;
  String paytmSignature;
  String showReview;
  String deliveryDate;
  String serviceDateTime;
  String orderType;
  String fullDeliveryCharges;
  String deliveryChargeFromVendor;
  String deliveryChargeFromCustomer;
  String payableAmountAddedToVendorWallet;
  String earningsAmountAddedToDeliveryPersonWallet;
  String selfPickAccepted;
  String selfPickAcceptedAt;
  String razorPayOrderId;
  String refundDateTime;
  String preRequestId;
  String isAdminCollectedAmount;
  String adminAmountCollectionsId;
  String specialInstructions;
  String isOrderReady;
  String isOrderPickedup;
  String dunzoTaskId;
  String deliveryPartner;
  String dunzoTaskCreateResponse;
  String tipAmount;
  String smileAmount;
  String audioInstructions;
  String appliedPlusbenefitAmount;
  String customerAddress;
  RestaurantDetails restaurantDetails;
  String restaurantId;
  bool mart;
  CustomerDetails customerDetails;
  List<CartItem> cartItems;
  List<dynamic> taxes;
  String paymentStatusBootstrapClass;
  String settlementStatusBootstrapClass;
  String hasLiveTrackingPermission;
  String distance;
  String distanceToStore;
  String deliveryPersonLat;
  String deliveryPersonLng;
  String liveDistanceToCustomer;
  String otp;
  String deliveryPersonPic;
  String refundText;
  RemaingTimeObj remaingTimeObj;
  String tableName;
  String expectedEarning;
  String deliveryPersonEarningInfo;

  Data({
    required this.refId,
    required this.couponId,
    required this.couponCode,
    required this.couponPromotionBy,
    required this.serviceDate,
    required this.paymentMode,
    required this.paymentRefNumber,
    required this.mainAmountForCommission,
    required this.subTotal,
    required this.appliedTaxAmount,
    required this.appliedDiscountAmount,
    required this.appliedDeliveryCharge,
    required this.deliveryPersonCharges,
    required this.grandTotal,
    required this.throughWalletAmount,
    required this.paymentStatus,
    required this.serviceStatus,
    required this.restaurantLat,
    required this.restaurantLng,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.landmark,
    required this.doorNo,
    required this.address,
    required this.addressType,
    required this.restaurantOrderAcceptedAt,
    required this.restaurantOrderRejectedAt,
    required this.rejectedReason,
    required this.deliveryPersonAcceptedAt,
    required this.pickedupAcceptedAt,
    required this.deliveryPersonsId,
    required this.deliveryPersonName,
    required this.deliveryPersonContactNumber,
    required this.outForDeliveryAt,
    required this.deliveredAt,
    required this.restaurantCommissionType,
    required this.restaurantCommissionValue,
    required this.restaurantCommissionAmount,
    required this.gstOnCommission,
    required this.promotionAmount,
    required this.payableAmountToRestaurant,
    required this.restaurantFeedBack,
    required this.restaurantRating,
    required this.deliveryPersonFeedback,
    required this.deliveryPersonRating,
    required this.otherFeedbackText,
    required this.feedbackGivenDate,
    required this.paymentRefundedNumber,
    required this.remark,
    required this.instamojoPaymentRequestId,
    required this.paymentCollectedBy,
    required this.deliveryPersonEarningAmount,
    required this.deliveryDistance,
    required this.distanceToCustomerFromStore,
    required this.deliveryOtp,
    required this.city,
    required this.paymentGateway,
    required this.paytmSignature,
    required this.showReview,
    required this.deliveryDate,
    required this.serviceDateTime,
    required this.orderType,
    required this.fullDeliveryCharges,
    required this.deliveryChargeFromVendor,
    required this.deliveryChargeFromCustomer,
    required this.payableAmountAddedToVendorWallet,
    required this.earningsAmountAddedToDeliveryPersonWallet,
    required this.selfPickAccepted,
    required this.selfPickAcceptedAt,
    required this.razorPayOrderId,
    required this.refundDateTime,
    required this.preRequestId,
    required this.isAdminCollectedAmount,
    required this.adminAmountCollectionsId,
    required this.specialInstructions,
    required this.isOrderReady,
    required this.isOrderPickedup,
    required this.dunzoTaskId,
    required this.deliveryPartner,
    required this.dunzoTaskCreateResponse,
    required this.tipAmount,
    required this.smileAmount,
    required this.audioInstructions,
    required this.appliedPlusbenefitAmount,
    required this.customerAddress,
    required this.restaurantDetails,
    required this.restaurantId,
    required this.mart,
    required this.customerDetails,
    required this.cartItems,
    required this.taxes,
    required this.paymentStatusBootstrapClass,
    required this.settlementStatusBootstrapClass,
    required this.hasLiveTrackingPermission,
    required this.distance,
    required this.distanceToStore,
    required this.deliveryPersonLat,
    required this.deliveryPersonLng,
    required this.liveDistanceToCustomer,
    required this.otp,
    required this.deliveryPersonPic,
    required this.refundText,
    required this.remaingTimeObj,
    required this.tableName,
    required this.expectedEarning,
    required this.deliveryPersonEarningInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        refId: json["ref_id"].toString(),
        couponId: json["coupon_id"].toString(),
        couponCode: json["coupon_code"].toString(),
        couponPromotionBy: json["coupon_promotion_by"].toString(),
        serviceDate: json["service_date"].toString(),
        paymentMode: json["payment_mode"].toString(),
        paymentRefNumber: json["payment_ref_number"].toString(),
        mainAmountForCommission: json["main_amount_for_commission"].toString(),
        subTotal: json["sub_total"].toString(),
        appliedTaxAmount: json["applied_tax_amount"].toString(),
        appliedDiscountAmount: json["applied_discount_amount"].toString(),
        appliedDeliveryCharge: json["applied_delivery_charge"].toString(),
        deliveryPersonCharges: json["delivery_person_charges"].toString(),
        grandTotal: json["grand_total"].toString(),
        throughWalletAmount: json["through_wallet_amount"].toString(),
        paymentStatus: json["payment_status"].toString(),
        serviceStatus: json["service_status"].toString(),
        restaurantLat: json["restaurant_lat"].toString(),
        restaurantLng: json["restaurant_lng"].toString(),
        deliveryLat: json["delivery_lat"].toString(),
        deliveryLng: json["delivery_lng"].toString(),
        landmark: json["landmark"].toString(),
        doorNo: json["door_no"].toString(),
        address: json["address"].toString(),
        addressType: json["address_type"].toString(),
        restaurantOrderAcceptedAt:
            json["restaurant_order_accepted_at"].toString(),
        restaurantOrderRejectedAt:
            json["restaurant_order_rejected_at"].toString(),
        rejectedReason: json["rejected_reason"].toString(),
        deliveryPersonAcceptedAt:
            json["delivery_person_accepted_at"].toString(),
        pickedupAcceptedAt: json["pickedup_accepted_at"].toString(),
        deliveryPersonsId: json["delivery_persons_id"].toString(),
        deliveryPersonName: json["delivery_person_name"].toString(),
        deliveryPersonContactNumber:
            json["delivery_person_contact_number"].toString(),
        outForDeliveryAt: json["out_for_delivery_at"].toString(),
        deliveredAt: json["delivered_at"].toString(),
        restaurantCommissionType: json["restaurant_commission_type"].toString(),
        restaurantCommissionValue:
            json["restaurant_commission_value"].toString(),
        restaurantCommissionAmount:
            json["restaurant_commission_amount"].toString(),
        gstOnCommission: json["gst_on_commission"].toString(),
        promotionAmount: json["promotion_amount"].toString(),
        payableAmountToRestaurant:
            json["payable_amount_to_restaurant"].toString(),
        restaurantFeedBack: json["restaurant_feed_back"].toString(),
        restaurantRating: json["restaurant_rating"].toString(),
        deliveryPersonFeedback: json["delivery_person_feedback"].toString(),
        deliveryPersonRating: json["delivery_person_rating"].toString(),
        otherFeedbackText: json["other_feedback_text"].toString(),
        feedbackGivenDate: json["feedback_given_date"].toString(),
        paymentRefundedNumber: json["payment_refunded_number"].toString(),
        remark: json["remark"].toString(),
        instamojoPaymentRequestId:
            json["instamojo_payment_request_id"].toString(),
        paymentCollectedBy: json["payment_collected_by"].toString(),
        deliveryPersonEarningAmount:
            json["delivery_person_earning_amount"].toString(),
        deliveryDistance: json["delivery_distance"].toString(),
        distanceToCustomerFromStore:
            json["distance_to_customer_from_store"].toString(),
        deliveryOtp: json["delivery_otp"].toString(),
        city: json["city"].toString(),
        paymentGateway: json["payment_gateway"].toString().toString(),
        paytmSignature: json["paytm_signature"].toString(),
        showReview: json["show_review"].toString(),
        deliveryDate: json["delivery_date"].toString(),
        serviceDateTime: json["service_date_time"].toString(),
        orderType: json["order_type"].toString(),
        fullDeliveryCharges: json["full_delivery_charges"].toString(),
        deliveryChargeFromVendor:
            json["delivery_charge_from_vendor"].toString(),
        deliveryChargeFromCustomer:
            json["delivery_charge_from_customer"].toString(),
        payableAmountAddedToVendorWallet:
            json["payable_amount_added_to_vendor_wallet"].toString(),
        earningsAmountAddedToDeliveryPersonWallet:
            json["earnings_amount_added_to_delivery_person_wallet"]
                .toString()
                .toString(),
        selfPickAccepted: json["self_pick_accepted"].toString(),
        selfPickAcceptedAt: json["self_pick_accepted_at"].toString(),
        razorPayOrderId: json["razor_pay_order_id"].toString(),
        refundDateTime: json["refund_date_time"].toString(),
        preRequestId: json["pre_request_id"].toString(),
        isAdminCollectedAmount: json["is_admin_collected_amount"].toString(),
        adminAmountCollectionsId:
            json["admin_amount_collections_id"].toString(),
        specialInstructions: json["special_instructions"].toString(),
        isOrderReady: json["is_order_ready"].toString(),
        isOrderPickedup: json["is_order_pickedup"].toString(),
        dunzoTaskId: json["dunzo_task_id"].toString(),
        deliveryPartner: json["delivery_partner"].toString(),
        dunzoTaskCreateResponse: json["dunzo_task_create_response"].toString(),
        tipAmount: json["tip_amount"].toString(),
        smileAmount: json["smile_amount"].toString(),
        audioInstructions: json["audio_instructions"].toString(),
        appliedPlusbenefitAmount: json["applied_plusbenefit_amount"].toString(),
        customerAddress: json["customer_address"].toString(),
        restaurantDetails: json["restaurant_details"] == false
            ? RestaurantDetails(
                id: '',
                accessToken: '',
                isTrending: '',
                foodType: '',
                isProvidingOrderLater: '',
                restaurantName: '',
                contactEmail: '',
                mobile: '',
                secondaryMobile: '',
                minFoodPreparationTime: '',
                maxFoodPreparationTime: '',
                minDeliveryTime: '',
                maxDeliveryTime: '',
                minimumOrderAmount: '',
                displayImage: '',
                landMark: '',
                address: '',
                zipcode: '',
                latitude: '',
                longitude: '',
                seoUrl: '',
                rating: '',
                description: '',
                commissionValue: '',
                pushNotificationToken: '',
                mobileVerified: '',
                gstNumber: '',
                fssaiLicenseNumber: '',
                marketingExecutivesId: '',
                deliveryRadius: '',
                copiedToS3: '',
                registerThrough: '',
                isPetpoojaLinkedStore: '',
                petpoojaStoreId: '',
                otp: '',
                deliveryType: '',
                storeType: '',
                locationName: '',
                cityContactInfo: CityContactInfo(
                    cityName: '',
                    userSupportNumber: '',
                    restaurantSupportNumber: '',
                    riderSupportNumber: ''),
                countryContactInfo: CountryContactInfo(countryName: ''),
                displayAddress: '')
            : RestaurantDetails.fromJson(json["restaurant_details"]),
        restaurantId: json["restaurant_id"].toString(),
        mart: json["mart"],
        customerDetails: CustomerDetails.fromJson(json["customer_details"]),
        cartItems: List<CartItem>.from(
            json["cart_items"].map((x) => CartItem.fromJson(x))),
        taxes: List<dynamic>.from(json["taxes"].map((x) => x)),
        paymentStatusBootstrapClass:
            json["payment_status_bootstrap_class"].toString(),
        settlementStatusBootstrapClass:
            json["settlement_status_bootstrap_class"].toString(),
        hasLiveTrackingPermission:
            json["has_live_tracking_permission"].toString(),
        distance: json["distance"].toString(),
        distanceToStore: json["distance_to_store"].toString(),
        deliveryPersonLat: json["delivery_person_lat"].toString(),
        deliveryPersonLng: json["delivery_person_lng"].toString(),
        liveDistanceToCustomer: json["live_distance_to_customer"].toString(),
        otp: json["otp"].toString(),
        deliveryPersonPic: json["delivery_person_pic"].toString(),
        refundText: json["refund_text"].toString(),
        remaingTimeObj: RemaingTimeObj.fromJson(json["remaing_time_obj"]),
        tableName: json["table_name"].toString(),
        expectedEarning: json["expected_earning"].toString(),
        deliveryPersonEarningInfo:
            json["delivery_person_earning_info"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "ref_id": refId,
        "coupon_id": couponId,
        "coupon_code": couponCode,
        "coupon_promotion_by": couponPromotionBy,
        "service_date": serviceDate,
        "payment_mode": paymentMode,
        "payment_ref_number": paymentRefNumber,
        "main_amount_for_commission": mainAmountForCommission,
        "sub_total": subTotal,
        "applied_tax_amount": appliedTaxAmount,
        "applied_discount_amount": appliedDiscountAmount,
        "applied_delivery_charge": appliedDeliveryCharge,
        "delivery_person_charges": deliveryPersonCharges,
        "grand_total": grandTotal,
        "through_wallet_amount": throughWalletAmount,
        "payment_status": paymentStatus,
        "service_status": serviceStatus,
        "restaurant_lat": restaurantLat,
        "restaurant_lng": restaurantLng,
        "delivery_lat": deliveryLat,
        "delivery_lng": deliveryLng,
        "landmark": landmark,
        "door_no": doorNo,
        "address": address,
        "address_type": addressType,
        "restaurant_order_accepted_at": restaurantOrderAcceptedAt,
        "restaurant_order_rejected_at": restaurantOrderRejectedAt,
        "rejected_reason": rejectedReason,
        "delivery_person_accepted_at": deliveryPersonAcceptedAt,
        "pickedup_accepted_at": pickedupAcceptedAt,
        "delivery_persons_id": deliveryPersonsId,
        "delivery_person_name": deliveryPersonName,
        "delivery_person_contact_number": deliveryPersonContactNumber,
        "out_for_delivery_at": outForDeliveryAt,
        "delivered_at": deliveredAt,
        "restaurant_commission_type": restaurantCommissionType,
        "restaurant_commission_value": restaurantCommissionValue,
        "restaurant_commission_amount": restaurantCommissionAmount,
        "gst_on_commission": gstOnCommission,
        "promotion_amount": promotionAmount,
        "payable_amount_to_restaurant": payableAmountToRestaurant,
        "restaurant_feed_back": restaurantFeedBack,
        "restaurant_rating": restaurantRating,
        "delivery_person_feedback": deliveryPersonFeedback,
        "delivery_person_rating": deliveryPersonRating,
        "other_feedback_text": otherFeedbackText,
        "feedback_given_date": feedbackGivenDate,
        "payment_refunded_number": paymentRefundedNumber,
        "remark": remark,
        "instamojo_payment_request_id": instamojoPaymentRequestId,
        "payment_collected_by": paymentCollectedBy,
        "delivery_person_earning_amount": deliveryPersonEarningAmount,
        "delivery_distance": deliveryDistance,
        "distance_to_customer_from_store": distanceToCustomerFromStore,
        "delivery_otp": deliveryOtp,
        "city": city,
        "payment_gateway": paymentGateway,
        "paytm_signature": paytmSignature,
        "show_review": showReview,
        "delivery_date": deliveryDate,
        "service_date_time": serviceDateTime,
        "order_type": orderType,
        "full_delivery_charges": fullDeliveryCharges,
        "delivery_charge_from_vendor": deliveryChargeFromVendor,
        "delivery_charge_from_customer": deliveryChargeFromCustomer,
        "payable_amount_added_to_vendor_wallet":
            payableAmountAddedToVendorWallet,
        "earnings_amount_added_to_delivery_person_wallet":
            earningsAmountAddedToDeliveryPersonWallet,
        "self_pick_accepted": selfPickAccepted,
        "self_pick_accepted_at": selfPickAcceptedAt,
        "razor_pay_order_id": razorPayOrderId,
        "refund_date_time": refundDateTime,
        "pre_request_id": preRequestId,
        "is_admin_collected_amount": isAdminCollectedAmount,
        "admin_amount_collections_id": adminAmountCollectionsId,
        "special_instructions": specialInstructions,
        "is_order_ready": isOrderReady,
        "is_order_pickedup": isOrderPickedup,
        "dunzo_task_id": dunzoTaskId,
        "delivery_partner": deliveryPartner,
        "dunzo_task_create_response": dunzoTaskCreateResponse,
        "tip_amount": tipAmount,
        "smile_amount": smileAmount,
        "audio_instructions": audioInstructions,
        "applied_plusbenefit_amount": appliedPlusbenefitAmount,
        "customer_address": customerAddress,
        "restaurant_details": restaurantDetails.toJson(),
        "restaurant_id": restaurantId,
        "mart": mart,
        "customer_details": customerDetails.toJson(),
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "taxes": List<dynamic>.from(taxes.map((x) => x)),
        "payment_status_bootstrap_class": paymentStatusBootstrapClass,
        "settlement_status_bootstrap_class": settlementStatusBootstrapClass,
        "has_live_tracking_permission": hasLiveTrackingPermission,
        "distance": distance,
        "distance_to_store": distanceToStore,
        "delivery_person_lat": deliveryPersonLat,
        "delivery_person_lng": deliveryPersonLng,
        "live_distance_to_customer": liveDistanceToCustomer,
        "otp": otp,
        "delivery_person_pic": deliveryPersonPic,
        "refund_text": refundText,
        "remaing_time_obj": remaingTimeObj.toJson(),
        "table_name": tableName,
        "expected_earning": expectedEarning,
        "delivery_person_earning_info": deliveryPersonEarningInfo,
      };
}

class CartItem {
  String restaurantFoodItemsId;
  String restaurantFoodItemOptionsId;
  String restaurantFoodItemAddonsId;
  String applicablePrice;
  String qty;
  String restaurantFoodItemsName;
  String restaurantFoodItemAddonsNames;
  String appliedTaxAmount;
  String taxPercentage;
  List<dynamic> addonsJson;
  String addOnsAmount;
  String totalAmount;
  String adminCommissionAmount;
  String adminCommissionPercentage;
  String serviceOrderItemId;
  String foodType;
  String offerPercentage;
  String image;
  String followingIndividualItemTax;

  CartItem({
    required this.restaurantFoodItemsId,
    required this.restaurantFoodItemOptionsId,
    required this.restaurantFoodItemAddonsId,
    required this.applicablePrice,
    required this.qty,
    required this.restaurantFoodItemsName,
    required this.restaurantFoodItemAddonsNames,
    required this.appliedTaxAmount,
    required this.taxPercentage,
    required this.addonsJson,
    required this.addOnsAmount,
    required this.totalAmount,
    required this.adminCommissionAmount,
    required this.adminCommissionPercentage,
    required this.serviceOrderItemId,
    required this.foodType,
    required this.offerPercentage,
    required this.image,
    required this.followingIndividualItemTax,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        restaurantFoodItemsId: json["restaurant_food_items_id"].toString(),
        restaurantFoodItemOptionsId:
            json["restaurant_food_item_options_id"].toString(),
        restaurantFoodItemAddonsId:
            json["restaurant_food_item_addons_id"].toString(),
        applicablePrice: json["applicable_price"].toString(),
        qty: json["qty"].toString(),
        restaurantFoodItemsName: json["restaurant_food_items_name"].toString(),
        restaurantFoodItemAddonsNames:
            json["restaurant_food_item_addons_names"].toString(),
        appliedTaxAmount: json["applied_tax_amount"].toString(),
        taxPercentage: json["tax_percentage"].toString(),
        addonsJson: List<dynamic>.from(json["addons_json"].map((x) => x)),
        addOnsAmount: json["add_ons_amount"].toString(),
        totalAmount: json["total_amount"].toString(),
        adminCommissionAmount: json["admin_commission_amount"].toString(),
        adminCommissionPercentage:
            json["admin_commission_percentage"].toString(),
        serviceOrderItemId: json["service_order_item_id"].toString(),
        foodType: json["food_type"].toString(),
        offerPercentage: json["offer_percentage"].toString(),
        image: json["image"].toString(),
        followingIndividualItemTax:
            json["following_individual_item_tax"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "restaurant_food_items_id": restaurantFoodItemsId,
        "restaurant_food_item_options_id": restaurantFoodItemOptionsId,
        "restaurant_food_item_addons_id": restaurantFoodItemAddonsId,
        "applicable_price": applicablePrice,
        "qty": qty,
        "restaurant_food_items_name": restaurantFoodItemsName,
        "restaurant_food_item_addons_names": restaurantFoodItemAddonsNames,
        "applied_tax_amount": appliedTaxAmount,
        "tax_percentage": taxPercentage,
        "addons_json": List<dynamic>.from(addonsJson.map((x) => x)),
        "add_ons_amount": addOnsAmount,
        "total_amount": totalAmount,
        "admin_commission_amount": adminCommissionAmount,
        "admin_commission_percentage": adminCommissionPercentage,
        "service_order_item_id": serviceOrderItemId,
        "food_type": foodType,
        "offer_percentage": offerPercentage,
        "image": image,
        "following_individual_item_tax": followingIndividualItemTax,
      };
}

class CustomerDetails {
  String customerName;
  String email;
  String countriesId;
  String mobile;
  String alternateMobile;
  String dob;
  String citiesId;
  String pushNotificationKey;
  String googleAccountId;
  String facebookAccountId;
  String appleId;
  String deviceType;
  String userDeliveryType;
  String plusBenefits;
  String subscribeStartDate;
  String subscribeEndDate;
  String currentWalletAmount;
  String totalReferalls;
  String totalEarnings;

  CustomerDetails({
    required this.customerName,
    required this.email,
    required this.countriesId,
    required this.mobile,
    required this.alternateMobile,
    required this.dob,
    required this.citiesId,
    required this.pushNotificationKey,
    required this.googleAccountId,
    required this.facebookAccountId,
    required this.appleId,
    required this.deviceType,
    required this.userDeliveryType,
    required this.plusBenefits,
    required this.subscribeStartDate,
    required this.subscribeEndDate,
    required this.currentWalletAmount,
    required this.totalReferalls,
    required this.totalEarnings,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        customerName: json["customer_name"].toString(),
        email: json["email"].toString(),
        countriesId: json["countries_id"].toString(),
        mobile: json["mobile"].toString(),
        alternateMobile: json["alternate_mobile"].toString(),
        dob: json["dob"].toString(),
        citiesId: json["cities_id"].toString(),
        pushNotificationKey: json["push_notification_key"].toString(),
        googleAccountId: json["google_account_id"].toString(),
        facebookAccountId: json["facebook_account_id"].toString(),
        appleId: json["apple_id"].toString(),
        deviceType: json["device_type"].toString(),
        userDeliveryType: json["user_delivery_type"].toString(),
        plusBenefits: json["plus_benefits"].toString(),
        subscribeStartDate: json["subscribe_start_date"].toString(),
        subscribeEndDate: json["subscribe_end_date"].toString(),
        currentWalletAmount: json["current_wallet_amount"].toString(),
        totalReferalls: json["total_referalls"].toString(),
        totalEarnings: json["total_earnings"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "email": email,
        "countries_id": countriesId,
        "mobile": mobile,
        "alternate_mobile": alternateMobile,
        "dob": dob,
        "cities_id": citiesId,
        "push_notification_key": pushNotificationKey,
        "google_account_id": googleAccountId,
        "facebook_account_id": facebookAccountId,
        "apple_id": appleId,
        "device_type": deviceType,
        "user_delivery_type": userDeliveryType,
        "plus_benefits": plusBenefits,
        "subscribe_start_date": subscribeStartDate,
        "subscribe_end_date": subscribeEndDate,
        "current_wallet_amount": currentWalletAmount,
        "total_referalls": totalReferalls,
        "total_earnings": totalEarnings,
      };
}

class OrderStatusLog {
  String displayLable;
  String currentStatus;
  String description;
  String dateTime;
  String actionActivated;
  String image;

  OrderStatusLog({
    required this.displayLable,
    required this.currentStatus,
    required this.description,
    required this.dateTime,
    required this.actionActivated,
    required this.image,
  });

  factory OrderStatusLog.fromJson(Map<String, dynamic> json) => OrderStatusLog(
        displayLable: json["display_lable"].toString(),
        currentStatus: json["current_status"].toString(),
        description: json["description"].toString(),
        dateTime: json["date_time"].toString(),
        actionActivated: json["action_activated"].toString(),
        image: json["image"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "display_lable": displayLable,
        "current_status": currentStatus,
        "description": description,
        "date_time": dateTime,
        "action_activated": actionActivated,
        "image": image,
      };
}

class RemaingTimeObj {
  String orderCanAbleCancelTill;
  String remainDays;
  String remainHours;
  String remainMinutes;
  String remainSeconds;
  String totalRemainSeconds;

  RemaingTimeObj({
    required this.orderCanAbleCancelTill,
    required this.remainDays,
    required this.remainHours,
    required this.remainMinutes,
    required this.remainSeconds,
    required this.totalRemainSeconds,
  });

  factory RemaingTimeObj.fromJson(Map<String, dynamic> json) => RemaingTimeObj(
        orderCanAbleCancelTill: json["order_can_able_cancel_till"].toString(),
        remainDays: json["remain_days"].toString(),
        remainHours: json["remain_hours"].toString(),
        remainMinutes: json["remain_minutes"].toString(),
        remainSeconds: json["remain_seconds"].toString(),
        totalRemainSeconds: json["total_remain_seconds"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "order_can_able_cancel_till": orderCanAbleCancelTill,
        "remain_days": remainDays,
        "remain_hours": remainHours,
        "remain_minutes": remainMinutes,
        "remain_seconds": remainSeconds,
        "total_remain_seconds": totalRemainSeconds,
      };
}

class RestaurantDetails {
  String id;
  String accessToken;
  String isTrending;
  String foodType;
  String isProvidingOrderLater;
  String restaurantName;
  String contactEmail;
  String mobile;
  String secondaryMobile;
  String minFoodPreparationTime;
  String maxFoodPreparationTime;
  String minDeliveryTime;
  String maxDeliveryTime;
  String minimumOrderAmount;
  String displayImage;
  String landMark;
  String address;
  String zipcode;
  String latitude;
  String longitude;
  String seoUrl;
  String rating;
  String description;
  String commissionValue;
  String pushNotificationToken;
  String mobileVerified;
  String gstNumber;
  String fssaiLicenseNumber;
  String marketingExecutivesId;
  String deliveryRadius;
  String copiedToS3;
  String registerThrough;
  String isPetpoojaLinkedStore;
  String petpoojaStoreId;
  String otp;
  String deliveryType;
  String storeType;
  String locationName;
  CityContactInfo cityContactInfo;
  CountryContactInfo countryContactInfo;
  String displayAddress;

  RestaurantDetails({
    required this.id,
    required this.accessToken,
    required this.isTrending,
    required this.foodType,
    required this.isProvidingOrderLater,
    required this.restaurantName,
    required this.contactEmail,
    required this.mobile,
    required this.secondaryMobile,
    required this.minFoodPreparationTime,
    required this.maxFoodPreparationTime,
    required this.minDeliveryTime,
    required this.maxDeliveryTime,
    required this.minimumOrderAmount,
    required this.displayImage,
    required this.landMark,
    required this.address,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.seoUrl,
    required this.rating,
    required this.description,
    required this.commissionValue,
    required this.pushNotificationToken,
    required this.mobileVerified,
    required this.gstNumber,
    required this.fssaiLicenseNumber,
    required this.marketingExecutivesId,
    required this.deliveryRadius,
    required this.copiedToS3,
    required this.registerThrough,
    required this.isPetpoojaLinkedStore,
    required this.petpoojaStoreId,
    required this.otp,
    required this.deliveryType,
    required this.storeType,
    required this.locationName,
    required this.cityContactInfo,
    required this.countryContactInfo,
    required this.displayAddress,
  });

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) =>
      RestaurantDetails(
        id: json["id"].toString(),
        accessToken: json["access_token"].toString(),
        isTrending: json["is_trending"].toString(),
        foodType: json["food_type"].toString(),
        isProvidingOrderLater: json["is_providing_order_later"].toString(),
        restaurantName: json["restaurant_name"].toString(),
        contactEmail: json["contact_email"].toString(),
        mobile: json["mobile"].toString(),
        secondaryMobile: json["secondary_mobile"].toString(),
        minFoodPreparationTime: json["min_food_preparation_time"].toString(),
        maxFoodPreparationTime: json["max_food_preparation_time"].toString(),
        minDeliveryTime: json["min_delivery_time"].toString(),
        maxDeliveryTime: json["max_delivery_time"].toString(),
        minimumOrderAmount: json["minimum_order_amount"].toString(),
        displayImage: json["display_image"].toString(),
        landMark: json["land_mark"].toString(),
        address: json["address"].toString(),
        zipcode: json["zipcode"].toString(),
        latitude: json["latitude"].toString(),
        longitude: json["longitude"].toString(),
        seoUrl: json["seo_url"].toString(),
        rating: json["rating"].toString(),
        description: json["description"].toString(),
        commissionValue: json["commission_value"].toString(),
        pushNotificationToken: json["push_notification_token"].toString(),
        mobileVerified: json["mobile_verified"].toString(),
        gstNumber: json["gst_number"].toString(),
        fssaiLicenseNumber: json["fssai_license_number"].toString(),
        marketingExecutivesId: json["marketing_executives_id"].toString(),
        deliveryRadius: json["delivery_radius"].toString(),
        copiedToS3: json["copied_to_s3"].toString(),
        registerThrough: json["register_through"].toString(),
        isPetpoojaLinkedStore: json["is_petpooja_linked_store"].toString(),
        petpoojaStoreId: json["petpooja_store_id"].toString(),
        otp: json["otp"].toString(),
        deliveryType: json["delivery_type"].toString(),
        storeType: json["store_type"].toString(),
        locationName: json["location_name"].toString(),
        cityContactInfo: CityContactInfo.fromJson(json["city_contact_info"]),
        countryContactInfo:
            CountryContactInfo.fromJson(json["country_contact_info"]),
        displayAddress: json["display_address"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "access_token": accessToken,
        "is_trending": isTrending,
        "food_type": foodType,
        "is_providing_order_later": isProvidingOrderLater,
        "restaurant_name": restaurantName,
        "contact_email": contactEmail,
        "mobile": mobile,
        "secondary_mobile": secondaryMobile,
        "min_food_preparation_time": minFoodPreparationTime,
        "max_food_preparation_time": maxFoodPreparationTime,
        "min_delivery_time": minDeliveryTime,
        "max_delivery_time": maxDeliveryTime,
        "minimum_order_amount": minimumOrderAmount,
        "display_image": displayImage,
        "land_mark": landMark,
        "address": address,
        "zipcode": zipcode,
        "latitude": latitude,
        "longitude": longitude,
        "seo_url": seoUrl,
        "rating": rating,
        "description": description,
        "commission_value": commissionValue,
        "push_notification_token": pushNotificationToken,
        "mobile_verified": mobileVerified,
        "gst_number": gstNumber,
        "fssai_license_number": fssaiLicenseNumber,
        "marketing_executives_id": marketingExecutivesId,
        "delivery_radius": deliveryRadius,
        "copied_to_s3": copiedToS3,
        "register_through": registerThrough,
        "is_petpooja_linked_store": isPetpoojaLinkedStore,
        "petpooja_store_id": petpoojaStoreId,
        "otp": otp,
        "delivery_type": deliveryType,
        "store_type": storeType,
        "location_name": locationName,
        "city_contact_info": cityContactInfo.toJson(),
        "country_contact_info": countryContactInfo.toJson(),
        "display_address": displayAddress,
      };
}

class CityContactInfo {
  String cityName;
  String userSupportNumber;
  String restaurantSupportNumber;
  String riderSupportNumber;

  CityContactInfo({
    required this.cityName,
    required this.userSupportNumber,
    required this.restaurantSupportNumber,
    required this.riderSupportNumber,
  });

  factory CityContactInfo.fromJson(Map<String, dynamic> json) =>
      CityContactInfo(
        cityName: json["city_name"].toString(),
        userSupportNumber: json["user_support_number"].toString(),
        restaurantSupportNumber: json["restaurant_support_number"].toString(),
        riderSupportNumber: json["rider_support_number"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "city_name": cityName,
        "user_support_number": userSupportNumber,
        "restaurant_support_number": restaurantSupportNumber,
        "rider_support_number": riderSupportNumber,
      };
}

class CountryContactInfo {
  String countryName;

  CountryContactInfo({
    required this.countryName,
  });

  factory CountryContactInfo.fromJson(Map<String, dynamic> json) =>
      CountryContactInfo(
        countryName: json["country_name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "country_name": countryName,
      };
}
