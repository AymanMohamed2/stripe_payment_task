import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_integration_task/core/api_keys.dart';
import 'package:stripe_integration_task/core/networking/api_service.dart';
import 'package:stripe_integration_task/core/networking/dio.dart';
import 'package:stripe_integration_task/features/stripe_pyment_task/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:stripe_integration_task/features/stripe_pyment_task/data/models/init_payment_sheet_input_model.dart';
import 'package:stripe_integration_task/features/stripe_pyment_task/data/models/payment_intent_input_model.dart';
import 'package:stripe_integration_task/features/stripe_pyment_task/data/models/payment_intent_model/payment_intent_model.dart';

class StripeService {
  final ApiService apiService = DioService(Dio());
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      data: paymentIntentInputModel.toJson(),
      headers: {
        'content-type': Headers.formUrlEncodedContentType,
        'Authorization': 'Bearer ${ApiKeys.secretKey}'
      },
      url: 'https://api.stripe.com/v1/payment_intents',
    );

    var paymentIntentModel = PaymentIntentModel.fromJson(response);

    return paymentIntentModel;
  }

  Future initPaymentSheet(
      {required InitiPaymentSheetInputModel
          initiPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initiPaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            initiPaymentSheetInputModel.ephemeralKeySecret,
        customerId: initiPaymentSheetInputModel.customerId,
        merchantDisplayName: 'tharwat',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemeralKeyModel =
        await createEphemeralKey(customerId: paymentIntentInputModel.cusomerId);
    var initPaymentSheetInputModel = InitiPaymentSheetInputModel(
        clientSecret: paymentIntentModel.clientSecret!,
        customerId: paymentIntentInputModel.cusomerId,
        ephemeralKeySecret: ephemeralKeyModel.secret!);
    await initPaymentSheet(
        initiPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    var response = await apiService.post(
      data: {'customer': customerId},
      headers: {
        'content-type': Headers.formUrlEncodedContentType,
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
        'Stripe-Version': '2023-08-16',
      },
      url: 'https://api.stripe.com/v1/ephemeral_keys',
    );

    var ephermeralKey = EphemeralKeyModel.fromJson(response);

    return ephermeralKey;
  }
}
