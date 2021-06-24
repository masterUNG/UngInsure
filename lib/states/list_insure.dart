import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:unginsure/models/insure_model.dart';
import 'package:unginsure/states/detail_insure.dart';
import 'package:unginsure/utility/my_constant.dart';
import 'package:unginsure/widgets/show_progress.dart';

class ListInsure extends StatefulWidget {
  const ListInsure({Key? key}) : super(key: key);

  @override
  _ListInsureState createState() => _ListInsureState();
}

class _ListInsureState extends State<ListInsure> {
  bool load = true;
  List<InsureModel> insureModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllInsure();
  }

  Future<Null> readAllInsure() async {
    String path = '${MyConstant.domain}/unginsure/getAllinsure.php';
    await Dio().get(path).then((value) {
      // print('value = $value');
      for (var item in json.decode(value.data)) {
        InsureModel model = InsureModel.fromMap(item);
        setState(() {
          load = false;
          insureModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text('เลือกประเภทประกัน'),
      ),
      body: load ? ShowProgress() : buildGrid(),
    );
  }

  Widget buildGrid() => Container(
        decoration: MyConstant().myBoxDecoration(),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160),
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailInsure(insureModel: insureModels[index],),
              ),
            ),
            child: Card(
              color: MyConstant.primary,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    child: Image.network(
                        '${MyConstant.domain}${insureModels[index].promote}'),
                  ),
                  Text(
                    insureModels[index].insure,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          itemCount: insureModels.length,
        ),
      );
} // class
