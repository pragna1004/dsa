import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:pie_chart/pie_chart.dart";
import "dart:io";
import "package:http/http.dart" as http ;
import "dart:convert";
import "jk.dart";
import "final.dart";

class Super extends StatefulWidget {

  const Super({super.key,required this.s,required this.bu});

  final List<String> s;
  final List<String> bu;

  @override
  State<Super> createState() => _SuperState();
}

class _SuperState extends State<Super> {
  List _templates=[];
  String? _template;
  bool _isloadingtempltes=true;
  Map<String,double> datas={};
  @override
   void initState() {
    super.initState();
    _dash();
    for(int i=0;i<widget.s.length;i++){
      datas[widget.s[i]]= double.parse(widget.bu[i]);
    }
  }
  Future<void> _dash() async {
    try {
      final response = await http.get(Uri.parse('$url/templates'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _templates = data['templates'];

          _template = "standard";
          _isloadingtempltes = false;
        });
      }
    } catch (e) {
      print("Error fetching templates: $e");
      setState(() {
        _isloadingtempltes = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 10,
          shadowColor: Colors.white60,
          leading:BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [Colors.black,Colors.blue.shade900,Colors.blue.shade900,Colors.black])
            ),
          ),
          title:Center(child: Padding(
            padding: const EdgeInsets.fromLTRB(40,50,50,50),
            child: Text("Division",style: GoogleFonts.inconsolata(color:Colors.white,fontSize: MediaQuery.of(context).size.width>1000?MediaQuery.of(context).size.width*0.041:MediaQuery.of(context).size.width*0.098),),
          )),

        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: [Colors.blue.shade900,Colors.black],
            radius: 0.63)
          ),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 39, 8, 10),
                  child: Row(
                    children: [
                      Container(
                        height:50,
                        width:140,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(colors: [Colors.black,Colors.blue.shade900,Colors.black]),
                          boxShadow: [BoxShadow(
                            blurRadius: 8,
                            spreadRadius: 1,
                            color: Colors.white,
                          )]
                        ),
                        child:Center(child: Text("DIVISION",style: TextStyle(color:Colors.white,fontSize: 20,),))
                      ),
                      SizedBox(
                        width:60
                      ),
                      Container(
                          height:50,
                          width:65,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.black,Colors.blue.shade900,Colors.black]),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                            boxShadow: [BoxShadow(
                            blurRadius: 8,
                            spreadRadius: 1,
                            color: Colors.white,
                          )]
                      ),
                          child:Center(child: Text("%",style: TextStyle(color:Colors.white,fontSize: 20,),))
                      )
                    ],
                  ),
                ),

                SingleChildScrollView(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 600 ,
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(3,0,8,0),
                            child: ListView.builder(
                              itemCount: widget.s.length,
                              itemBuilder: (context,index){
                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15,10,8,15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        height: 60,
                                        width: 200,
                                        child: Center(child: Text("${widget.s[index]}",style: TextStyle(color: Colors.white,fontSize: 25),)),

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 15),
                                      child: Container(decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.circular(20)
                                      ),

                                        height: 50,
                                        width: 90,
                                        child: Center(child: Text("${widget.bu[index]}",style: TextStyle(color:Colors.white,fontSize: 20),)),

                                      ),
                                    ),

                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                      if (datas.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: PieChart(
                            dataMap: datas,
                            animationDuration: Duration(milliseconds: 1000),
                            chartLegendSpacing: 32,
                            chartRadius: MediaQuery.of(context).size.width / 4,
                            colorList: [Colors.blue, Colors.orange, Colors.purple, Colors.green, Colors.red,Colors.cyan],
                            initialAngleInDegree: 0,
                            chartType: ChartType.disc,
                            ringStrokeWidth: 32,
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.right,
                              showLegends: true,
                              legendTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text("Select Grading Curve:", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: _isloadingtempltes
                        ? CircularProgressIndicator(color: Colors.white)
                        : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.blue.shade900,
                        value: _template,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        items: _templates.map<DropdownMenuItem<String>>((template) {
                          return DropdownMenuItem<String>(
                            value: template['id'],
                            child: Text(template['name'] + " - " + template['tag']),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _template = newValue;
                          });
                        },
                      ),
                    ),




                ),),
                    SizedBox(height: 40),
                    Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              onPressed: () {
                Map<String, int> divisionMap = {};
                for(int i = 0; i < widget.s.length; i++) {
                  divisionMap[widget.s[i]] = int.parse(widget.bu[i]);
                }

                print("Ready to calculate!");
                print("Divisions: $divisionMap");
                print("Selected Template: $_template");
                String ta=_template??"standard";
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>ProcessGradesPage(
                  divisions: divisionMap,
                  templateId: ta,
                )));




              },
              child: Text("CALCULATE GRADES", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

                    ),
            ],

            ),
          ),
        ),
      ),
    );
  }
}
