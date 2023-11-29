import 'package:flutter/material.dart';
import 'package:generadorreportes/core/utils/ui_utils.dart';
import 'package:provider/provider.dart';

import '../../../login/data/models/user_model.dart';
import '../../../login/display/providers/login_provider.dart';
import '../providers/profile_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    TextEditingController newNameController =
        TextEditingController(text: loginProvider.user.name);
    TextEditingController newEmailController =
        TextEditingController(text: loginProvider.user.email);
    TextEditingController newPhoneController =
        TextEditingController(text: loginProvider.user.phone);
    UiUtils uiUtils = UiUtils();
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Perfil',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: uiUtils.screenWidth * 0.05),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: uiUtils.screenWidth * 0.7,
                  height: uiUtils.screenHeight * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          image: AssetImage('assets/images/logocapturador.png'),
                          fit: BoxFit.fill)),
                  // child: GestureDetector(
                  //   onTap: () async {
                  //     // File? finalFile = await signInProvider.uploadPhoto(
                  //     //     fromCamera: false,
                  //     //     context: context,
                  //     //     isFromRegister: isFromRegister,
                  //     //     isProfilePhoto: isProfilePhoto);
                  //     // onFileUpload(finalFile);
                  //   },
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       // const SizedBox(height: 20),
                  //       Container(
                  //           decoration: BoxDecoration(
                  //               color: Colors.orange,
                  //               borderRadius: BorderRadius.circular(100)),
                  //           child: const Icon(
                  //             Icons.photo_camera_outlined,
                  //             size: 40,
                  //             color: Colors.white,
                  //           )
                  //           ),
                  //     ],
                  //   ),
                  // )
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  height: uiUtils.screenHeight * 0.3,
                  width: uiUtils.screenWidth,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(2, 5),
                          blurRadius: 8,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      buildTextField(
                        controller: newNameController,
                        label: 'Nombre Completo',
                        isEditing: profileProvider.isEditingProfile,
                      ),
                      const Divider(),
                      buildTextField(
                        controller: newEmailController,
                        label: 'Correo',
                        isEditing: profileProvider.isEditingProfile,
                      ),
                      const Divider(),
                      buildTextField(
                        controller: newPhoneController,
                        label: 'Telefono',
                        isEditing: profileProvider.isEditingProfile,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  profileProvider.isEditingProfile
                      ? profileProvider.saveChanges(UserModel(
                          name: newNameController.text,
                          type: loginProvider.user.type,
                          email: newEmailController.text,
                          phone: newPhoneController.text,
                          password: loginProvider.user.password,
                        ))
                      : profileProvider.startEditing();
                },
                child: Text(
                    profileProvider.isEditingProfile ? 'Guardar' : 'Editar'),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isEditing,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8.0),
        enabled: isEditing,
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        suffixIcon: isEditing
            ? IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(Icons.clear),
              )
            : null,
      ),
    );
  }
}
