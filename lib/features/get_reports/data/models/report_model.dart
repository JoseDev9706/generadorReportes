import 'dart:io';

class ReportModel {
  final List<File> initialFiles;
  final List<File> finalFiles;
  final String status;
  final DateTime completedDate;
  final String tecniqueName;
  final String observations;
  final String ip;
  final String host;
  final String devideType;
  final String serialNumber;
  final String model;
  final String brand;
  final File filePreview;

  ReportModel({
    required this.initialFiles,
    required this.finalFiles,
    required this.status,
    required this.completedDate,
    required this.tecniqueName,
    required this.observations,
    required this.ip,
    required this.host,
    required this.devideType,
    required this.serialNumber,
    required this.model,
    required this.brand,
    required this.filePreview,
  });
}
