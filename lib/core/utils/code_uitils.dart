import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CodeUtils {
  CodeUtils._privateConstructor();

  static final CodeUtils _instance = CodeUtils._privateConstructor();

  factory CodeUtils() {
    return _instance;
  }

  Future<Map<String, dynamic>> checkStoragePermissions() async {
    try {
      Map<String, dynamic> permissionsAnswer = {
        'granted': false,
        'message': '',
      };
      PermissionStatus storageStatus = await Permission.storage.request();
      // var storageStatus = await Permission.storage.status;
      if (storageStatus.isGranted || storageStatus.isRestricted) {
        permissionsAnswer['granted'] = true;
      } else if (storageStatus.isDenied) {
        permissionsAnswer['granted'] = false;
        permissionsAnswer['message'] =
            'Debes conceder los permisos para continuar';
      } else if (storageStatus.isPermanentlyDenied) {
        permissionsAnswer['granted'] = false;
        permissionsAnswer['message'] =
            'Los permisos fueron rechazados permanentemente, ingresa a los ajustes de tu teléfono para continuar';
      }
      return permissionsAnswer;
    } catch (error) {
      return {
        'granted': false,
        'message': 'Ocurrió algo inesperado al solicitar los permisos $error',
      };
    }
  }

  Future<Map<String, dynamic>> checkCameraPermissions() async {
    try {
      Map<String, dynamic> permissionsAnswer = {
        'granted': false,
        'message': '',
      };
      PermissionStatus cameraStatus = await Permission.camera.request();
      // var storageStatus = await Permission.storage.status;
      if (cameraStatus.isGranted || cameraStatus.isRestricted) {
        permissionsAnswer['granted'] = true;
      } else if (cameraStatus.isDenied) {
        permissionsAnswer['granted'] = false;
        permissionsAnswer['message'] =
            'Debes conceder los permisos para continuar';
      } else if (cameraStatus.isPermanentlyDenied) {
        permissionsAnswer['granted'] = false;
        permissionsAnswer['message'] =
            'Los permisos fueron rechazados permanentemente, ingresa a los ajustes de tu teléfono para continuar';
      }
      return permissionsAnswer;
    } catch (error) {
      return {
        'granted': false,
        'message': 'Ocurrió algo inesperado al solicitar los permisos $error',
      };
    }
  }

  String formatFecha(DateTime fecha) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(fecha);
  }
}
