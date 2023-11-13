// ignore_for_file: prefer_const_constructors, unused_import, sort_child_properties_last, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_element, file_names

import 'package:flutter/material.dart';

import 'package:skan/pages/home/screen/home_screen.dart';




class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Log in Page",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
          ),
           leadingWidth: 100,
        leading: Container(
          color: Color(0x0fffffff),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Image.asset(
              "assets/icons/back-arrow.png",
              width: 60,
              height: 60,
            ),
          ),
        ),
        ),
        
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _hello(),
              const SizedBox(height: 50),
              _inputField("Email", emailController),
              const SizedBox(height: 20),
              _inputField("Password", passwordController, isPassword: true),
              const SizedBox(height: 20),
              _loginBtn(),
              SizedBox(height: 5),
              _ContinueWGoogle(),
              SizedBox(height: 5),
              _GoogleBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(247, 92, 92, 92)));

    return TextField(
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _ContinueWGoogle() {
    return Positioned(
      left: 31,
      top: 323,
      child: Container(
        width: 260,
        height: 70,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 19,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the elements horizontally
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/minus-horizontal-straight-line.png",
              color: Color(0xFF4B5768),
              height: 60,
            ),
            Text(
              '  Or Login With    ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4B5768),
                fontSize: 15,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            Image.asset(
              "assets/icons/minus-horizontal-straight-line.png",
              color: Color(0xFF4B5768),
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
        child: ElevatedButton(
      onPressed: () {
         Navigator.push(context,MaterialPageRoute(builder: (context)=> HomeScreen()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF5858),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Positioned(
        left: 22,
        top: 498,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 90,
            vertical: 19,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Agree and Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _GoogleBtn() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          // Add your onPressed action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE4E7EB), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 1,
              color: Color(0xFFE4E7EB),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 19),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/google.png",
              height: 20,
              width: 20,
              alignment: Alignment.centerLeft,
            ),
            Text(
              '     Continue with google ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4B5768),
                fontSize: 15,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hello() {
    return Padding(
      padding: const EdgeInsets.only(top: 145.0, left: 21.0),
      child: Text(
        'Welcome back! Glad to see you, Again!',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Urbanist',
          color: Color(0xFF1e232c), // Use 0xFF for the alpha value
        ),
      ),
    );
  }
}
