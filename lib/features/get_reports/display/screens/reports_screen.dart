import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:generadorreportes/features/get_reports/display/screens/report_details.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/code_uitils.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../data/models/report_model.dart';
import '../providers/reports_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ReportsProvider reportsProvider = Provider.of<ReportsProvider>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Resumen general de reportes'),
            const SizedBox(height: 20),
            Container(
              height: UiUtils().screenHeight * 0.6,
              child: ListView.builder(
                itemCount: reportsProvider.reportsList.length,
                itemBuilder: (context, index) {
                  return buildCardReports(reportsProvider.reportsList[index],
                      () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ReportDetailsScreen(
                            report: reportsProvider.reportsList[index])));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardReports(ReportModel report, VoidCallback onTapDetails) {
    UiUtils uiUtils = UiUtils();
    CodeUtils codeUtils = CodeUtils();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      height: uiUtils.screenHeight * 0.1,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(2, 5),
          blurRadius: 8,
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.attachment_outlined),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                codeUtils.formatFecha(report.completedDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                report.status,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              onTapDetails();
            },
            child: const Text(
              'Detalles',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          )
        ],
      ),
    );
  }
}
