import 'package:flutter/material.dart';
import 'package:generadorreportes/core/utils/code_uitils.dart';
import 'package:generadorreportes/core/utils/ui_utils.dart';

import 'package:generadorreportes/features/login/display/providers/login_provider.dart';
import 'package:generadorreportes/features/get_reports/data/models/report_model.dart';
import 'package:generadorreportes/features/get_reports/display/providers/reports_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  // final ReportsProvider reportsProvider;
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    ReportsProvider reportsProvider = Provider.of<ReportsProvider>(context);
    // UiUtils uiUtils = UiUtils();

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Bienvenido ${loginProvider.user.name}'),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Text(
                'Tus reportes Recientes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: UiUtils().screenHeight * 0.6,
                child: ListView.builder(
                  itemCount: reportsProvider.reportsList.length,
                  itemBuilder: (context, index) {
                    return buildCardReports(reportsProvider.reportsList[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ]),
          )),
    );
  }

  Widget buildCardReports(ReportModel report) {
    UiUtils uiUtils = UiUtils();
    CodeUtils codeUtils = CodeUtils();
    return Container(
      margin: EdgeInsets.only(top: 10),
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
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.green),
              child: const Icon(Icons.check))
        ],
      ),
    );
  }
}
