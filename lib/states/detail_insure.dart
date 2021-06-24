import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unginsure/models/insure_model.dart';
import 'package:unginsure/states/checkpin.dart';
import 'package:unginsure/states/form_customer.dart';
import 'package:unginsure/utility/my_constant.dart';

class DetailInsure extends StatefulWidget {
  final InsureModel insureModel;
  const DetailInsure({Key? key, required this.insureModel}) : super(key: key);

  @override
  _DetailInsureState createState() => _DetailInsureState();
}

class _DetailInsureState extends State<DetailInsure> {
  InsureModel? insureModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    insureModel = widget.insureModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildBuy(context),
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text(insureModel!.insure),
      ),
      body: Column(
        children: [
          buildImage(),
          buildDetail(),
          Text(
            'Price = ${insureModel!.price} Kt',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildBuy(BuildContext context) {
    return FloatingActionButton(
      child: Text('Buy'),
      backgroundColor: MyConstant.primary,
      onPressed: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? pin = preferences.getString('pin');

        if (pin?.isEmpty ?? true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => FormCustomer(insureModel: insureModel!),
              ),
              (route) => false);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckPin(insureModel: insureModel),
              ));
        }
      },
    );
  }

  Container buildDetail() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Text(insureModel!.detail),
    );
  }

  Container buildImage() {
    return Container(
      width: 250,
      child: Image.network('${MyConstant.domain}${insureModel!.promote}'),
    );
  }
}
