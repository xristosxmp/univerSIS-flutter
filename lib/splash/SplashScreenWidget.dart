import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:universis/auth/auth.dart';
import 'package:universis/classes/Auth.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/exceptions/UnauthorizedException.dart';
import 'package:universis/loginWidgets/LoginPage.dart';
import 'package:universis/main/MainPage.dart';
import 'package:universis/main/StudentDashboard.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), (){
      route();
    });
  }



  route() async {

    bool isActive = await Auth.isStudentActive();
    if (isActive) {
          try {
            Auth? activeUser = await Auth.getStudent();
            if(activeUser == null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      
            AuthClient client = AuthClient();
            String token = await client.login(activeUser!.username, activeUser.password);
            Student student = await getStudentInfo(token);
            return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentDashboard(student: student)));
          } on UnauthorizedException {
              return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          } catch (e) {
              return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
    }
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: FadeInImage(
            image: AssetImage("assets/images/universis-logo-transp.png"), 
            height: MediaQuery.of(context).size.height * 0.11,
            fadeInDuration: const Duration(seconds: 1),
            placeholder: MemoryImage(kTransparentImage), 
          ),
        ),
      ),
    );
  }
}