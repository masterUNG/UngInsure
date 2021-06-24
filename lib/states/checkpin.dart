import 'package:flutter/material.dart';
import 'package:otp_screen/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unginsure/models/insure_model.dart';
import 'package:unginsure/states/form_customer.dart';

class CheckPin extends StatefulWidget {
  final InsureModel? insureModel;
  const CheckPin({Key? key, required this.insureModel}) : super(key: key);

  @override
  _CheckPinState createState() => _CheckPinState();
}

class _CheckPinState extends State<CheckPin> {
  String? pin;
  InsureModel? insureModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    insureModel = widget.insureModel;
    findPin();
  }

  Future<Null> findPin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    pin = preferences.getString('pin');
    print('### pin ==>> $pin');
  }

  Future<String?> processCheckPin(String string) async {
    if (string == pin) {
      return null;
    } else {
      return 'Pin False !!! Please Try Again';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Pin'),
      ),
      body: OtpScreen(
        validateOtp: processCheckPin,
        routeCallback: (BuildContext context) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => FormCustomer(insureModel: insureModel!),
            ),
            (route) => false),
        otpLength: 6,
      ),
    );
  }
}
