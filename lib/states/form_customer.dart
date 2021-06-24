import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unginsure/models/insure_model.dart';
import 'package:unginsure/utility/my_constant.dart';
import 'package:unginsure/widgets/show_progress.dart';

class FormCustomer extends StatefulWidget {
  final InsureModel insureModel;
  const FormCustomer({Key? key, required this.insureModel}) : super(key: key);

  @override
  _FormCustomerState createState() => _FormCustomerState();
}

class _FormCustomerState extends State<FormCustomer> {
  InsureModel? insureModel;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    insureModel = widget.insureModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => processBuyInsure(),
            icon: Icon(Icons.fingerprint),
          ),
          buildListInsure(context)
        ],
        title: Text('Register'),
        backgroundColor: MyConstant.primary,
      ),
      body: buildContent(),
    );
  }

  IconButton buildListInsure(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.routeListInsure, (route) => false),
        icon: Icon(Icons.list));
  }

  Widget buildContent() => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  buildName(),
                  buildAddress(),
                  buildPhone(),
                  buildText(),
                  buildDetail(),
                  buildBuyInsure(),
                ],
              ),
            ),
          ),
        ),
      );

  Container buildBuyInsure() {
    return Container(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          processBuyInsure();
        },
        child: Text('Buy Insure'),
      ),
    );
  }

  Future<Null> processBuyInsure() async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String address = addressController.text;
      String phone = phoneController.text;

      print('## name= $name, address = $address, phone = $phone');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? pin = preferences.getString('pin');
      print('## pin = $pin');
      if (pin?.isEmpty ?? true) {
        print('### process New Register');
        savePin(name, address, phone);
      } else {
        print('### Check Pin');
      }
    }
  }

  Future<Null> savePin(String name, String address, String phone) async {
    String pin;
    TextEditingController pinController = TextEditingController();
    final pinForm = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Image.asset('images/logo.png'),
          title: Text('New Customer ?'),
          subtitle: Text('Please Set Your PIN'),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: pinForm,
              child: Container(
                width: 200,
                child: TextFormField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.length != 6) {
                      return 'Fill pin 6 Digi';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 6,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  if (pinForm.currentState!.validate()) {
                    pin = pinController.text;
                    int i = Random().nextInt(100000);
                    String keyCustomer = 'key$i';
                    print(
                        '### pin = $pin , name = $name, address = $address, phone = $phone, keyCustomer = $keyCustomer');
                    String apiInsertUser =
                        '${MyConstant.domain}/unginsure/insertUser.php?isAdd=true&name=$name&address=$address&phone=$phone&pin=$pin&keycustomer=$keyCustomer';

                    print('#### apiInserUer = $apiInsertUser');

                    await Dio().get(apiInsertUser).then((value) async {
                      if (value.toString() == 'true') {
                        print('Create New Account Success');

                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString('pin', pin).then((value) => null);
                      } else {
                        print('Cannot Create');
                      }
                    });
                  }
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildDetail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildImage(),
          Container(
            width: 200,
            child: Text(insureModel!.detail),
          ),
        ],
      ),
    );
  }

  Container buildImage() {
    return Container(
      width: 100,
      child: CachedNetworkImage(
        imageUrl: '${MyConstant.domain}${insureModel!.promote}',
        placeholder: (context, url) => ShowProgress(),
      ),
    );
  }

  Card buildText() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              insureModel!.insure,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              insureModel!.price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'Name :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildAddress() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        controller: addressController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Address :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPhone() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        controller: phoneController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        maxLength: 8,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Phone :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
