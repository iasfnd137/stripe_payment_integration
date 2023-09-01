import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project_flutter/home_screen.dart';
class PaymentScreen extends StatefulWidget {
  var money;
   PaymentScreen({super.key,required this.money});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print('thiss isss selected money................${widget.money}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()async{
              await makePayment();
            }, child: const Text('Payment Methode')),
          ],
        ),
      ),
    );
  }
  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment() async {
    try {
      double decimalAmount = money; // Replace this with your actual amount
      int integerAmount = (decimalAmount * 100) .toInt();
      paymentIntentData = await createPaymentIntent(integerAmount.toString(), 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              setupIntentClientSecret: 'sk_test_51NhVeOEqNHk1E7CnGDdFmGgEinCNRm0lLh7NA2OFnycnDTYegJdkGs6BA2HpEEGPgXWqcaKdTZbWrq2XEKFgjwXf00VNG4o0nE',
              paymentIntentClientSecret:
              paymentIntentData!['client_secret'],
              //applePay: PaymentSheetApplePay.,
              //googlePay: true,
              customFlow: true,
              style: ThemeMode.dark,
              // merchantCountryCode: 'US',
              merchantDisplayName: 'Kashif'))
          .then((value) {});
      ///now finally display payment sheeet
      print('this is not working');
      displayPaymentSheet();
      print('this is working');
    } catch (e) {
      print('Payment exception : $e .......');
    }
  }
  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
        //       parameters: PresentPaymentSheetParameters(
        // clientSecret: paymentIntentData!['client_secret'],
        // confirmPayment: true,
        // )
      )
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text("paid successfully")));
        // sendPayment();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
        //   return DashBoardHome();
        // }));
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }
  createPaymentIntent(var amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51NhVeOEqNHk1E7CnGDdFmGgEinCNRm0lLh7NA2OFnycnDTYegJdkGs6BA2HpEEGPgXWqcaKdTZbWrq2XEKFgjwXf00VNG4o0nE',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
  // calculateAmount(String amount) {
  //   final a = int.parse(amount)*100;
  //   return a.toString();
  // }
}
