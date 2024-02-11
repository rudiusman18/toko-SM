import 'package:e_shop/pages/main_page.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passswordTextEditingController =
      TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
                    50,
                  ),
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/bag.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome Back",
                  style: poppins.copyWith(
                    fontWeight: bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Please enter your credential",
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
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: backgroundColor1,
                  controller: emailTextEditingController,
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
                  controller: passswordTextEditingController,
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
                // NOTE: Button Submit
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor1),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const MainPage(),
                              type: PageTransitionType.fade));
                    },
                    child: const Text(
                      "LOGIN",
                    ),
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
