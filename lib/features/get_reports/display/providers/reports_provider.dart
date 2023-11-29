import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:generadorreportes/core/utils/ui_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/code_uitils.dart';
import '../../data/models/report_model.dart';

class ReportsProvider with ChangeNotifier {
  List<File> initalPhotos = [];
  List<File> finalsPhotos = [];
  List<ReportModel> reportsList = [];
  File preview = File('');
  TextEditingController observationsController = TextEditingController();
  String ipController = 'DEFAULT';
  String hostController = 'NO APLICA';
  String deviceController = 'DEFAULT';
  String serialController = 'DEFAULT';
  String modelController = 'DEFAULT';
  String brandController = 'DEFAULT';
  String assigntedController = 'DEFAULT';
  final pdf = pw.Document();

  Future<File?> uploadPhoto({
    required bool fromCamera,
    required BuildContext context,
  }) async {
    try {
      CodeUtils codeUtils = CodeUtils();
      // Verifica los permisos antes de abrir la cámara
      Map<String, dynamic> response = await codeUtils.checkCameraPermissions();
      log('Permisos solicitados: $response');
      if (!response['granted']) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Permisos requeridos'),
              content: Text(response['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return null;
      }

      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile == null) {
        return null;
      }

      File finalFile = File(pickedFile.path);
      notifyListeners();

      return finalFile;
    } catch (error) {
      log('Error al abrir la cámara: $error');
      return null;
    }
  }

//guardar los reportes en local al shared
  Future<void> saveReportToSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> reportsJsonList = prefs.getStringList('reports') ?? [];

      List<String> initialPhotoPaths =
          initalPhotos.map((file) => file.path).toList();
      List<String> finalPhotoPaths =
          finalsPhotos.map((file) => file.path).toList();

      Map<String, dynamic> reportData = {
        'initialPhotos': initialPhotoPaths,
        'finalPhotos': finalPhotoPaths,
        'status': 'Finalizado',
        'completedDate': DateTime.now().millisecondsSinceEpoch,
        'tecnique_name': assigntedController,
        'observations': observationsController.text,
        'ip': ipController,
        'host': hostController,
        'device_type': deviceController,
        'serial_number': serialController,
        'model': modelController,
        'brand': brandController,
        'file_preview': preview.path
      };

      String reportJson = jsonEncode(reportData);
      reportsJsonList.add(reportJson);

      await prefs.setStringList('reports', reportsJsonList);
    } catch (error) {
      log('Error al guardar el reporte en SharedPreferences: $error');
    }
  }

//traer los reportes desde el shared
  Future<List<ReportModel>> getReportsFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> reportsJsonList = prefs.getStringList('reports') ?? [];

      List<ReportModel> reports = reportsJsonList.map((reportJson) {
        Map<String, dynamic> reportData = jsonDecode(reportJson);
        return ReportModel(
            initialFiles: (reportData['initialPhotos'] as List<dynamic>)
                .map((path) => File(path))
                .toList(),
            finalFiles: (reportData['finalPhotos'] as List<dynamic>)
                .map((path) => File(path))
                .toList(),
            status: reportData['status'],
            completedDate: DateTime.fromMillisecondsSinceEpoch(
                reportData['completedDate']),
            tecniqueName: reportData['tecnique_name'],
            observations: reportData['observations'],
            ip: reportData['ip'],
            host: reportData['host'],
            devideType: reportData['device_type'],
            serialNumber: reportData['serial_number'],
            model: reportData['model'],
            brand: reportData['brand'],
            filePreview: File(reportData['file_preview']));
      }).toList();
      reportsList = reports;
      notifyListeners();
      return reportsList;
    } catch (error) {
      log('Error al obtener los reportes desde SharedPreferences: $error');
      return [];
    }
  }

  Future<void> clearReportsFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.remove('reports');
    } catch (error) {
      log('Error al eliminar los informes desde SharedPreferences: $error');
    }
  }

//generación del widget del pdf
  Future<void> createPdf(
    BuildContext context,
    ReportModel report,
  ) async {
    CodeUtils codeUtils = CodeUtils();
    UiUtils uiUtils = UiUtils();
    final directory = await getExternalStorageDirectory();

    const baseFileName = 'pdf';

    int version = 1;
    while (
        await File('${directory!.path}/$baseFileName$version.pdf').exists()) {
      version++;
    }

    final fileName = '$baseFileName$version.pdf';
    try {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.all(16.0),
            child: pw.Container(
              // height: uiUtils.screenHeight * 0.9,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text('TECNICAL DATA PREVIEW'),
                  ),
                  buildPhotoView(report.filePreview),
                  buildTecnicalInfo(uiUtils, 'IP:', report.ip),
                  buildTecnicalInfo(uiUtils, 'HOST:', report.host),
                  buildTecnicalInfo(uiUtils, 'DEVICE TYPE:', report.devideType),
                  buildTecnicalInfo(
                      uiUtils, 'SERIAL NUMBER:', report.serialNumber),
                  buildTecnicalInfo(uiUtils, 'MODEL:', report.model),
                  buildTecnicalInfo(uiUtils, 'BRAND:', report.brand),
                  buildTecnicalInfo(
                      uiUtils, 'ASSIGNATED USER:', report.tecniqueName),
                  pw.Column(children: [
                    pw.Container(
                      height: uiUtils.screenHeight * 0.04,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                              width: 1.0, color: PdfColors.black)),
                      child: pw.Center(
                        child: pw.Text('MANTENIENCE DATA '),
                      ),
                    ),
                    pw.Row(
                      children: [
                        buildPhotoSection(
                            'BEFORE MAINTENANCE', report.initialFiles),
                        pw.SizedBox(width: 16.0),
                        buildPhotoSection(
                            'AFTER MAINTENANCE', report.finalFiles),
                      ],
                    ),
                  ]),
                  pw.SizedBox(height: 12.0),
                  pw.Container(
                    height: uiUtils.screenHeight * 0.04,
                    decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(width: 1.0, color: PdfColors.black)),
                    child: pw.Center(
                      child: pw.Text('OBSERVATIONS & COMMENTS'),
                    ),
                  ),
                  pw.SizedBox(height: 12.0),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(left: 5),
                    width: uiUtils.screenWidth * 0.99,
                    height: uiUtils.screenHeight * 0.04,
                    decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(width: 1.0, color: PdfColors.black)),
                    child: pw.Text(
                      report.observations,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ));

      final path = '${directory.path}/$fileName';

      // Guardado del archivo PDF en la ruta
      // esto lo puedo cambiar a gusto del cliente
      File(path).writeAsBytesSync(await pdf.save());

      UiUtils().showFlushBar(
        context: context,
        title: 'Guardado',
        message: 'Se ha guardado en $path',
        icon: Icons.check,
      );
      codeUtils.checkStoragePermissions();
      OpenFilex.open(path);
    } catch (e, stackTrace) {
      log('Error al generar PDF: $e');
      log('StackTrace: $stackTrace');
    }
  }

  pw.Widget buildPhotoView(File photo) {
    UiUtils uiUtils = UiUtils();
    return pw.SizedBox(
        height: uiUtils.screenHeight * 0.4,
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Image(
            pw.MemoryImage(File(photo.path).readAsBytesSync()),
            fit: pw.BoxFit.fill,
          ),
        ));
  }

  pw.Widget buildTecnicalInfo(UiUtils uiUtils, String text, String hintText) {
    return pw.Row(children: [
      pw.Container(
        padding: const pw.EdgeInsets.only(left: 5),
        width: uiUtils.screenWidth * 0.36,
        decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.3, color: PdfColors.black)),
        child: pw.Text(
          text,
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold, font: pw.Font.timesItalic()),
        ),
      ),
      pw.Expanded(
        child: pw.Container(
          width: uiUtils.screenWidth * 0.3,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1.0, color: PdfColors.black),
          ),
          child: pw.Text(
            hintText,
            style: pw.TextStyle(
                color: PdfColors.grey, font: pw.Font.timesItalic()),
          ),
        ),
      ),
    ]);
  }

  pw.Widget buildPhotoSection(String title, List<File> photos) {
    UiUtils uiUtils = UiUtils();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: uiUtils.screenWidth * 0.55,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1.0, color: PdfColors.black),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(font: pw.Font.timesItalic()),
          ),
        ),
        for (var photo in photos)
          pw.Container(
            margin: pw.EdgeInsets.only(bottom: 10),
            height: uiUtils.screenHeight * 0.2,
            width: uiUtils.screenWidth * 0.55,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1.0, color: PdfColors.black),
            ),
            child: pw.Image(
              pw.MemoryImage(File(photo.path).readAsBytesSync()),
              fit: pw.BoxFit.fill,
            ),
          ),
      ],
    );
  }
}
