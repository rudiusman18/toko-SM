import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tokoSM/pages/login_page.dart';
import 'package:tokoSM/theme/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = false;
  bool isLoading = false;

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
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: backgroundColor1,
                  // controller: emailTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Masukkan username",
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
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: backgroundColor1,
                  // controller: emailTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Masukkan nama lengkap",
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
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: backgroundColor1,
                  // controller: emailTextEditingController,
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
                  // controller: passswordTextEditingController,
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
                  // controller: passswordTextEditingController,
                  cursorColor: backgroundColor1,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi Password",
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
                    onPressed: () {}, //loginHandler,
                    child: const Text(
                      "LOGIN",
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
