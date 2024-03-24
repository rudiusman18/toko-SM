import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/pages/login_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/register_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:geolocator/geolocator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with WidgetsBindingObserver {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  // variabel yang digunakan untuk menyimpan controller text
  TextEditingController userNameTextField = TextEditingController();
  TextEditingController namaLengkapTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController confirmPasswordTextField = TextEditingController();
  // current location
  // late Position _currentPosition;
  // bool _resumed = false; // Flag to check if app is already resumed

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   _checkPermission();
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed && !_resumed) {
  //     setState(() {
  //       _resumed = true;
  //     });
  //   } else if (state == AppLifecycleState.paused) {
  //     // Reset _resumed flag when app goes to the background
  //     setState(() {
  //       _resumed = false;
  //     });
  //   }
  // }

  // _checkPermission() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.deniedForever) {
  //     _showPermissionDeniedForeverDialog();
  //   } else {
  //     _requestPermission();
  //   }
  // }

  // _requestPermission() async {
  //   var status = await Permission.location.request();
  //   if (status == PermissionStatus.denied) {
  //     _showPermissionDeniedForeverDialog();
  //   } else if (status == PermissionStatus.granted) {
  //     _getCurrentLocation();
  //   } else if (status == PermissionStatus.permanentlyDenied) {
  //     _showPermissionDeniedForeverDialog();
  //   }
  // }

  // _showPermissionDeniedForeverDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       title: Text(
  //         "Butuh Perizinan Lokasi",
  //         style: poppins,
  //       ),
  //       content: Text(
  //         "Aplikasi ini membutuhkan perizinan lokasi anda untuk menentukan lokasi cabang terdekat toko kami. Mohon untuk mengatur perizinan lokasi di pengaturan",
  //         style: poppins,
  //       ),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           child: Text(
  //             "BATAL",
  //             style: poppins,
  //           ),
  //           onPressed: () {
  //             Navigator.pushReplacement(
  //                     context,
  //                     PageTransition(
  //                         child: const RegisterPage(),
  //                         type: PageTransitionType.fade))
  //                 .then((value) => setState(() {}));
  //           },
  //         ),
  //         ElevatedButton(
  //           child: const Text("BUKA PENGATURAN"),
  //           onPressed: () {
  //             setState(() {
  //               _resumed = false;
  //             });
  //             openAppSettings();
  //             Navigator.pushReplacement(
  //                     context,
  //                     PageTransition(
  //                         child: const RegisterPage(),
  //                         type: PageTransitionType.fade))
  //                 .then((value) => setState(() {}));
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _currentPosition = position;
  //     print("current Location: ${_currentPosition}");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);

    void registerHandler() async {
      if (passwordTextField.text == confirmPasswordTextField.text) {
        setState(() {
          isLoading = true;
        });
        if (await registerProvider.postRegister(
          username: userNameTextField.text,
          namaLengkap: namaLengkapTextField.text,
          email: emailTextField.text,
          password: passwordTextField.text,
        )) {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const LoginPage(),
                  type: PageTransitionType.leftToRight),
              (route) => false);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Anda berhasil mendaftarkan akun",
              ),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                registerProvider.errorMessage,
              ),
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password tidak cocok",
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 30,
              bottom: 30,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome",
                  style: poppins.copyWith(
                    fontWeight: bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Please register your credential",
                  style: poppins.copyWith(
                    fontWeight: light,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: poppins.copyWith(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.name,
                  cursorColor: backgroundColor1,
                  controller: userNameTextField,
                  decoration: InputDecoration(
                    hintText: "Masukkan username",
                    hintStyle: poppins.copyWith(
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: backgroundColor1,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: poppins.copyWith(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.name,
                  cursorColor: backgroundColor1,
                  controller: namaLengkapTextField,
                  decoration: InputDecoration(
                    hintText: "Masukkan nama lengkap",
                    hintStyle: poppins.copyWith(
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: backgroundColor1,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: poppins.copyWith(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: backgroundColor1,
                  controller: emailTextField,
                  decoration: InputDecoration(
                    hintText: "Masukkan Email",
                    hintStyle: poppins.copyWith(
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(Icons.email),
                    prefixIconColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: backgroundColor1,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: poppins.copyWith(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordTextField,
                  cursorColor: backgroundColor1,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Masukkan Password",
                    hintStyle: poppins.copyWith(
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(Icons.https),
                    prefixIconColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: isPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    suffixIconColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: backgroundColor1,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: poppins.copyWith(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  controller: confirmPasswordTextField,
                  cursorColor: backgroundColor1,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi Password",
                    hintStyle: poppins.copyWith(
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(Icons.https),
                    prefixIconColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: isConfirmPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                    suffixIconColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: backgroundColor1,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),

                // NOTE: Button Submit
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor1),
                    onPressed: registerHandler, //loginHandler,
                    child: const Text(
                      "REGISTER",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: poppins.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: const LoginPage(),
                                  type: PageTransitionType.leftToRight),
                              (route) => false);
                        },
                        child: Text(
                          "Login",
                          style: poppins.copyWith(
                            color: backgroundColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
