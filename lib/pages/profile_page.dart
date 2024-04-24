import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/pages/login_page.dart';
import 'package:tokoSM/pages/profile_page/edit_profile_page.dart';
import 'package:tokoSM/providers/cabang_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/profile_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:placeholder_images/placeholder_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  get type => null;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    LoginModel userLogin = loginProvider.loginModel;
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    CabangProvider cabangProvider = Provider.of<CabangProvider>(context);

    _loading(){
      showDialog(context: context, builder: (BuildContext context){
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                      height: MediaQuery.sizeOf(context).width * 0.3,
                      child: CircularProgressIndicator(
                        color: backgroundColor3,
                      ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Loading...",style: poppins),
                ],
              ),
            ),
          ),
        );
      });
    }

    _handleTapEditProfil()async{
      setState(() {
        _loading();
      });
      if(await profileProvider.getProfile(token: loginProvider.loginModel.token ?? "", userId: "${loginProvider.loginModel.data?.id}")){
        if(await cabangProvider.getCabang(token: loginProvider.loginModel.token ?? "")){
          Navigator.push(
            context,
            PageTransition(
              child: const EditProfilePage(),
              type: PageTransitionType.rightToLeft,
            ),
          ).then((value) async{
            Navigator.pop(context);
            setState(() {
              _loading();
            });
            if(await profileProvider.getProfile(token: loginProvider.loginModel.token ?? "", userId: "${loginProvider.loginModel.data?.id}")){

            }else{}
            setState(() {
              Navigator.pop(context);
            });
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Gagal mendapatkan data profile", style: poppins,),
            duration: const Duration(seconds: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ));
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal mendapatkan data profile", style: poppins,),
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      }
    }

    String getInitials(String name) {
      // Split the name into individual words
      List<String> words = name.split(' ');

      // Initialize an empty string to store initials
      String initials = '';

      // Iterate through each word and extract the first letter
      for (int i = 0; i < words.length && i < 2; i++) {
        // Get the first letter of the word and add it to the initials string
        initials += words[i][0];
      }

      // Return the initials string
      return initials;
    }

    void showAlertDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "Warning!",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                    fontWeight: semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: backgroundColor1,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            content: Text(
              "Anda yakin untuk melakukan logout?",
              style: poppins.copyWith(color: backgroundColor1),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Batal",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: backgroundColor1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.remove('loginData');
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          child: const LoginPage(),
                          type: PageTransitionType.fade),
                      (route) => false);
                },
                child: Text(
                  "Lanjutkan",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: backgroundColor1,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    Widget profileData({required String title}) {
      return Text(
        title,
        style: poppins.copyWith(
          fontWeight: medium,
          fontSize: 14,
        ),
      );
    }

    Widget actionWidget({
      required IconData icon,
      required String title,
      required onTap,
    }) {
      return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: poppins.copyWith(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: poppins,
        ),
        centerTitle: true,
        backgroundColor: backgroundColor3,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: backgroundColor3,
                        ),
                        child: Center(
                          child: Text(
                            getInitials(
                              profileProvider.profileModel.data?.namaPelanggan ??
                                  "-".toUpperCase(),
                            ),
                            style: poppins.copyWith(
                              fontWeight: bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileData(
                              title: profileProvider.profileModel.data?.namaPelanggan ?? "-",
                            ),
                            profileData(
                                title: profileProvider.profileModel.data?.emailPelanggan ?? "-"),
                            profileData(
                                title: profileProvider.profileModel.data?.telpPelanggan ?? "-"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  actionWidget(
                    icon: Icons.edit,
                    title: "Edit Profil",
                    onTap: (){
                      _handleTapEditProfil();
                    },
                  ),
                  actionWidget(
                    icon: Icons.lock,
                    title: "Ubah Kata Sandi",
                    onTap: () {},
                  ),
                  actionWidget(
                    icon: Icons.house,
                    title: "Daftar Alamat",
                    onTap: () {},
                  ),
                  actionWidget(
                    icon: Icons.receipt,
                    title: "daftar transaksi",
                    onTap: () {},
                  ),
                  actionWidget(
                    icon: Icons.star,
                    title: "Ulasan",
                    onTap: () {},
                  ),
                  actionWidget(
                    icon: Icons.favorite,
                    title: "Favorit",
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        showAlertDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout),
                          Text(
                            "LOGOUT",
                            style: poppins,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
