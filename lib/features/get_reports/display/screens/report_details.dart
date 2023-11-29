import 'dart:io';

import 'package:flutter/material.dart';
import 'package:generadorreportes/core/utils/code_uitils.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../data/models/report_model.dart';
import '../providers/reports_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportDetailsScreen extends StatelessWidget {
  final ReportModel report;

  const ReportDetailsScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReportsProvider reportsProvider = Provider.of<ReportsProvider>(context);
    UiUtils uiUtils = UiUtils();
    CodeUtils codeUtils = CodeUtils();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: uiUtils.screenHeight * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text('TECNICAL DATA PREVIEW'),
                ),
                buildPhotoListView(report.filePreview),
                buildTecnicalInfo(uiUtils, 'IP:', report.ip),
                buildTecnicalInfo(uiUtils, 'HOST:', report.host),
                buildTecnicalInfo(uiUtils, 'DEVICE TYPE:', report.devideType),
                buildTecnicalInfo(
                    uiUtils, 'SERIAL NUMBER:', report.serialNumber),
                buildTecnicalInfo(uiUtils, 'MODEL:', report.model),
                buildTecnicalInfo(uiUtils, 'BRAND:', report.brand),
                buildTecnicalInfo(
                    uiUtils, 'ASSIGNATED USER:', report.tecniqueName),
                Container(
                  height: uiUtils.screenHeight * 0.04,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black)),
                  child: const Center(
                    child: Text('MANTENIENCE DATA '),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Container(
                            width: uiUtils.screenWidth * 0.5,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.black)),
                            child: const Text('BEFORE MAINTENANCE')),
                        buildPhotosList(report.initialFiles)
                      ],
                    )),
                    const SizedBox(width: 16.0), // Espacio entre las columnas
                    Expanded(
                        child: Column(
                      children: [
                        Container(
                            width: uiUtils.screenWidth * 0.5,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.black)),
                            child: const Text('AFTER MAINTENANCE')),
                        buildPhotosList(report.initialFiles)
                      ],
                    )),
                  ],
                ),
                Container(
                  height: uiUtils.screenHeight * 0.04,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black)),
                  child: const Center(
                    child: Text('OBSERVATIONS & COMMENTS'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(left: 5),
                  width: uiUtils.screenWidth,
                  height: uiUtils.screenHeight * 0.04,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black)),
                  child: Text(
                    report.observations,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      reportsProvider.createPdf(
                        context,
                        report,
                      );
                    },
                    child: const Text('Generar PDF'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhotosList(List<File> photos) {
    UiUtils uiUtils = UiUtils();
    return SizedBox(
      height: uiUtils.screenHeight * 0.3,
      width: uiUtils.screenWidth * 0.4,
      child: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.file(
              photos[index],
              width: uiUtils.screenWidth * 0.3,
              height: uiUtils.screenHeight * 0.2,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget buildPhotoListView(File photo) {
    UiUtils uiUtils = UiUtils();
    return SizedBox(
        height: uiUtils.screenHeight * 0.3,
        width: uiUtils.screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(
            photo,
            fit: BoxFit.fill,
          ),
        ));
  }

  Row buildTecnicalInfo(UiUtils uiUtils, String text, String hintText) {
    return Row(children: [
      Container(
        padding: EdgeInsets.only(left: 5),
        width: uiUtils.screenWidth * 0.36,
        decoration:
            BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: Container(
          width: uiUtils.screenWidth * 0.3,
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black)),
          child: Text(
            hintText,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    ]);
  }
}
