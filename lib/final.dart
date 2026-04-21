import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'dart:convert';
import 'jk.dart';

class ProcessGradesPage extends StatefulWidget {
  final Map<String, int> divisions;
  final String templateId;

  const ProcessGradesPage({super.key, required this.divisions, required this.templateId});

  @override
  State<ProcessGradesPage> createState() => _ProcessGradesPageState();
}

class _ProcessGradesPageState extends State<ProcessGradesPage> {
  String _statusMessage = "Ready to process grades.";
  bool _isProcessing = false;
  String? _downloadUrl;

  // To store chart data from the backend
  List<dynamic> _chartData = [];

  Future<void> _pickAndProcessFile() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [const XTypeGroup(label: 'documents', extensions: ['csv', 'xlsx', 'xls'])],
    );

    if (file == null) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = "Uploading & Calculating...";
      _downloadUrl = null;
      _chartData = [];
    });

    try {
      var fileBytes = await file.readAsBytes();
      var fileName = file.name;

      var request = http.MultipartRequest('POST', Uri.parse('$url/upload'));
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));

      var uploadResponse = await request.send();
      if (uploadResponse.statusCode != 200) throw Exception("Upload failed");

      var uploadData = json.decode(await uploadResponse.stream.bytesToString());

      var calcResponse = await http.post(
        Uri.parse('$url/calculate-grades'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "file_id": uploadData['file_id'],
          "divisions": widget.divisions,
          "distribution_type": "template",
          "template_id": widget.templateId,
        }),
      );

      if (calcResponse.statusCode == 200) {
        var calcData = json.decode(calcResponse.body);
        setState(() {
          _isProcessing = false;
          _statusMessage = "Success!";
          String rawDomain = url.replaceAll("/api", "");
          _downloadUrl = "$rawDomain${calcData['download_url']}";

          // Save the chart data sent from backend
          _chartData = calcData['chart_data'];
        });
      } else {
        throw Exception("Calculation failed.");
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = "Error: $e";
      });
    }
  }

  Future<void> _downloadFile() async {
    if (_downloadUrl != null) {
      if (!await launchUrl(Uri.parse(_downloadUrl!), mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open file')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: BackButton(color: Colors.white)),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [Colors.blue.shade900, Colors.black], radius: 0.8)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Final Step", style: GoogleFonts.inconsolata(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(_statusMessage, style: TextStyle(color: Colors.white70, fontSize: 18)),
                SizedBox(height: 30),

                if (_isProcessing)
                  CircularProgressIndicator(color: Colors.white)
                else if (_downloadUrl == null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: Icon(Icons.upload_file, color: Colors.white),
                    label: Text("Select File & Generate Grades", style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: _pickAndProcessFile,
                  ),

                // SHOW THE CHART IF DATA EXISTS
                if (_chartData.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 250,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _chartData.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b).toDouble() + 2,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(_chartData[value.toInt()]['grade'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          barGroups: List.generate(_chartData.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: _chartData[index]['count'].toDouble(),
                                  color: Colors.greenAccent,
                                  width: 20,
                                  borderRadius: BorderRadius.circular(4),
                                )
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                if (_downloadUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: Icon(Icons.download, color: Colors.black),
                      label: Text("Download Graded Excel", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                      onPressed: _downloadFile,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}