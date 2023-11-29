import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:generadorreportes/core/datas.dart';
import 'package:generadorreportes/core/utils/ui_utils.dart';
import 'package:generadorreportes/features/get_reports/display/widgets/custom_dropdownButtom.dart';
import 'package:generadorreportes/features/login/display/providers/login_provider.dart';
import 'package:generadorreportes/features/get_reports/display/providers/reports_provider.dart';
import 'package:provider/provider.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);

  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  bool isNewReport = false;
  bool isFinalizingReport = false;
  bool isLoadedScreen = false;
  bool isFilePreview = false;

  late ReportsProvider reportsProvider;
  late LoginProvider loginProvider;

  @override
  void didChangeDependencies() {
    if (!isLoadedScreen) {
      isLoadedScreen = true;
      reportsProvider = Provider.of<ReportsProvider>(context);
      loginProvider = Provider.of<LoginProvider>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UiUtils uiUtils = UiUtils();

    return Scaffold(
      body: isNewReport
          ? _buildCaptureView(uiUtils)
          : Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isNewReport = !isNewReport;
                    isFinalizingReport = !isFinalizingReport;
                  });
                },
                child: Container(
                  height: uiUtils.screenHeight * 0.06,
                  width: uiUtils.screenWidth * 0.8,
                  color: Colors.orange,
                  child: Center(
                      child: Text((!isFinalizingReport)
                          ? 'Nuevo Reporte'
                          : 'Continuar Reporte')),
                ),
              ),
            ),
    );
  }

  Widget _buildCaptureView(UiUtils uiUtils) {
    Datas datas = Datas();
    return Container(
      height: uiUtils.screenHeight * 0.9,
      padding: EdgeInsets.all(uiUtils.screenWidth * 0.04),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text('TECNICAL DATA PREVIEW'),
            ),
            const Divider(),
            Container(
              height: uiUtils.screenHeight * 0.2,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black)),
              child: !isFilePreview
                  ? buildBottomTakePhoto(
                      uiUtils,
                      () async {
                        File? finalFile = await reportsProvider.uploadPhoto(
                          fromCamera: true,
                          context: context,
                        );

                        log(finalFile != null ? finalFile.path : 'No subió');
                        if (finalFile != null) {
                          setState(() {
                            isFilePreview = !isFilePreview;
                            reportsProvider.preview = finalFile;
                          });
                        }
                      },
                    )
                  : _buildPhotoListView(reportsProvider.preview),
            ),
            buildTecnicalInfo(uiUtils, 'IP:', Datas.ipCategorias,
                reportsProvider.ipController, (value) {
              setState(() {
                reportsProvider.ipController = value!;
              });
            }),
            buildTecnicalInfo(
                uiUtils, 'HOST:', Datas.host, reportsProvider.hostController,
                (value) {
              setState(() {
                reportsProvider.hostController = value!;
              });
            }),
            buildTecnicalInfo(uiUtils, 'DEVICE TYPE:', Datas.types,
                reportsProvider.deviceController, (value) {
              setState(() {
                reportsProvider.deviceController = value!;
              });
            }),
            buildTecnicalInfo(uiUtils, 'SERIAL NUMBER:', Datas.serialNumber,
                reportsProvider.serialController, (value) {
              setState(() {
                reportsProvider.serialController = value!;
              });
            }),
            buildTecnicalInfo(uiUtils, 'MODEL:', Datas.listModel,
                reportsProvider.modelController, (value) {
              setState(() {
                reportsProvider.modelController = value!;
              });
            }),
            buildTecnicalInfo(uiUtils, 'BRAND:', Datas.listBrand,
                reportsProvider.brandController, (value) {
              setState(() {
                reportsProvider.brandController = value!;
              });
            }),
            buildTecnicalInfo(
                uiUtils,
                'ASSIGNATED USER:',
                Datas.listAssignatedUser,
                reportsProvider.assigntedController, (value) {
              setState(() {
                reportsProvider.assigntedController = value!;
              });
            }),
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
                            border:
                                Border.all(width: 1.0, color: Colors.black)),
                        child: const Text('BEFORE MAINTENANCE')),
                    Column(
                      children: [
                        buildBottomTakePhoto(
                          uiUtils,
                          () async {
                            File? finalFile = await reportsProvider.uploadPhoto(
                              fromCamera: true,
                              context: context,
                            );

                            log(finalFile != null
                                ? finalFile.path
                                : 'No subió');
                            if (finalFile != null) {
                              setState(() {
                                reportsProvider.initalPhotos.add(finalFile);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                          width: uiUtils.screenWidth * 0.5,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                          child: const Text('AFTER MAINTENANCE')),
                      buildBottomTakePhoto(
                        uiUtils,
                        () async {
                          File? finalFile = await reportsProvider.uploadPhoto(
                            fromCamera: true,
                            context: context,
                          );

                          log(finalFile != null ? finalFile.path : 'No subió');
                          if (finalFile != null) {
                            setState(() {
                              reportsProvider.finalsPhotos.add(finalFile);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                (reportsProvider.initalPhotos.isNotEmpty)
                    ? Expanded(
                        child:
                            _buildPhotosListView(reportsProvider.initalPhotos))
                    : const SizedBox(),
                const SizedBox(width: 15),
                (reportsProvider.initalPhotos.isNotEmpty)
                    ? Expanded(
                        child:
                            _buildPhotosListView(reportsProvider.finalsPhotos))
                    : const SizedBox(),
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
            TextField(
              controller: reportsProvider.observationsController,
              decoration: InputDecoration(
                labelText: 'Observaciones:',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (reportsProvider.initalPhotos.length !=
                    reportsProvider.finalsPhotos.length) {
                  uiUtils.showFlushBar(
                    context: context,
                    title: 'No se pudo guardar',
                    message:
                        'El numero de imagenes iniciales debe ser igual a las finales',
                    icon: Icons.error,
                  );
                } else {
                  await reportsProvider.saveReportToSharedPreferences();
                  setState(() {
                    isFinalizingReport = true;
                    isNewReport = false;
                    reportsProvider.initalPhotos.clear();
                    reportsProvider.finalsPhotos.clear();
                  });
                  uiUtils.showFlushBar(
                    context: context,
                    title: 'Reporte finalizado',
                    message: 'Se ha finalizado el reporte',
                    icon: Icons.check,
                  );
                  await reportsProvider.getReportsFromSharedPreferences();
                }
              },
              child: const Text('Finalizar Reporte'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTecnicalInfo(UiUtils uiUtils, String text, List<String> listItems,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      width: uiUtils.screenWidth,
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black)),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black)),
              child: CustomDropdown(
                itemList: listItems,
                selectedValue: selectedValue,
                onChanged: onChanged,
              )),
        ),
      ]),
    );
  }

  GestureDetector buildBottomTakePhoto(
      UiUtils uiUtils, VoidCallback ontapUploadPhoto) {
    return GestureDetector(
      onTap: ontapUploadPhoto,
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
        height: uiUtils.screenHeight * 0.07,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera),
            SizedBox(width: 8.0),
            Text('TAKE PHOTO'),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosListView(List<File> photos) {
    UiUtils uiUtils = UiUtils();
    return SizedBox(
      height: uiUtils.screenHeight * 0.3,
      child: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(
              photos[index],
              // height: 100.0,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoListView(File photo) {
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
}
