import 'package:flutter/material.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameTextField = TextEditingController();
  TextEditingController fullnameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController telpTextField = TextEditingController();
  TextEditingController alamatTextField = TextEditingController();
  TextEditingController wilayahTextField = TextEditingController();
  TextEditingController tglLahirTextField = TextEditingController();
  TextEditingController jenisKelaminTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget customtextFormField({
      required IconData icon,
      required String title,
      required TextInputType keyboardType,
      required TextEditingController controller,
    }) {
      return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: poppins.copyWith(
                fontWeight: medium,
                fontSize: 20,
                color: backgroundColor1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              style: poppins.copyWith(
                color: backgroundColor1,
              ),
              keyboardType: keyboardType,
              cursorColor: backgroundColor1,
              controller: controller,
              decoration: InputDecoration(
                hintText: "...",
                hintStyle: poppins.copyWith(
                  color: backgroundColor1,
                ),
                prefixIcon: Icon(icon),
                prefixIconColor: backgroundColor1,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor1,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor3,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Profil",
            style: poppins,
          ),
          backgroundColor: backgroundColor3,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Nama Pengguna",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Nama Lengkap",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Email",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Telp",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Alamat",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Wilayah",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Tanggal Lahir",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),

            // NOTE: Jenis Kelamin
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Jenis Kelamin",
                style: poppins.copyWith(
                  fontWeight: medium,
                  fontSize: 20,
                  color: backgroundColor1,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: backgroundColor1,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: CustomDropdown<String>(
                hintText: '...',
                items: const ["Laki-Laki", "Perempuan"],
                onChanged: (value) {
                  jenisKelaminTextField.text = value;
                },
              ),
            ),
          ],
        ));
  }
}
