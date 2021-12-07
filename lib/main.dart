// ignore_for_file: unused_import, unused_local_variable, unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextflow_covid_today/covid_today_result.dart';
import 'package:nextflow_covid_today/stat_box.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nextflow COVID-19 Today',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Nextflow COVID-19 Today1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    print('init state');
    getData();
  }

  Future<CovidTodayResult> getData() async {
    print("get Data");
    var url = Uri.parse(
        "https://covid19.th-stat.com/json/covid19v2/getTodayCases.json");
    var response = await http.get(url);
    print(response.body);
    var result = covidTodayResultFromJson(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print("bulid");

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: getData(),
          builder:
              (BuildContext context, AsyncSnapshot<CovidTodayResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data;

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      StatBox(
                        title: 'ผู้ติดเชื้อสะสม',
                        total: result?.confirmed,
                        backgroundColor: Color(0xff77007c),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatBox(
                        title: 'หายแล้ว',
                        total: result?.recovered,
                        backgroundColor: Color(0xff036233),
                      ),
                       SizedBox(
                        height: 10,
                      ),
                      StatBox(
                        title: 'รักษาอยู่ในโรงบาล',
                        total: result?.hospitalized,
                        backgroundColor: Color(0xff00B4B4),
                      ),
                       SizedBox(
                        height: 10,
                      ),
                      StatBox( 
                        title: 'เสียชีวิต',
                        total: result?.deaths,
                        backgroundColor: Color(0xff777777),
                      ),
                    ],
                  ));
            }
            return LinearProgressIndicator();
          },
        ));
  }
}
