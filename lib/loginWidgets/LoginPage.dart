import 'package:flutter/material.dart';
import 'package:universis/auth/auth.dart';
import 'package:universis/classes/Auth.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/exceptions/UnauthorizedException.dart';
import 'package:universis/main/StudentDashboard.dart';
import 'package:universis/widgets/ScaffoldMessengerBottom.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLaunching = false;
  bool usernameTextFieldError = false;
  bool passwordTextFieldError = false;
  String? errorMessage;

  bool _isLoading = false;
  @override Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    void _handleResetPassword() async{
            if (_isLaunching) return;
            setState(() {_isLaunching = true;});
            const url = 'https://mypassword.uop.gr/reset_password.php';
            final uri = Uri.parse(url);
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                  showCustomSnackBar(
                    context: context,
                    message: 'Προέκυψε σφάλμα δοκιμάστε αργότερα.',
                  );
              }
            } finally {
              await Future.delayed(Duration(seconds: 3));
              setState(() {
                _isLaunching = false;
              });
            }
    }

    Widget _resetPasswordWidget(){
        return 
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                        onTap:() async => _handleResetPassword(),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      'Ξέχασες τον κωδικό;',
                      style: TextStyle(
                        color: Color(0xFF5C6BC0),
                      ),
                    ),
                  ),
                ),
              );
    }

    Widget _passwordFieldWidget() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: passwordController,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          hintText: 'Κωδικός Πρόσβασης',
          prefixIcon: Icon(
            Icons.lock,
            color: Color(0xFF5C6BC0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF5C6BC0),
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: passwordTextFieldError == true ? Color(0xffDE3163) : Color(0xFF5C6BC0),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: passwordTextFieldError == true ? Color(0xffDE3163) : Color(0xFF5C6BC0),
              width: 1,
            ),
          ),
        ),
      ),
    ],
  );
}


    Widget _usernameFieldWidget(){
      return  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Όνομα Χρήστη',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xFF5C6BC0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: usernameTextFieldError  == true ?Color(0xffDE3163):Color(0xFF5C6BC0),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: usernameTextFieldError  == true ?Color(0xffDE3163):Color(0xFF5C6BC0),
                          width: 1,
                        ),
                      ),
                    ),
                  );
    }
    Widget _loginButtonWidget(){
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:  ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Color(0xFF5C6BC0);  // same color when disabled
                  }
                  return Color(0xFF5C6BC0); // normal state
                }),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

                onPressed: _isLoading ? null : () async {  // disable button when loading
                usernameController.text = "xristosxmp";
                passwordController.text = "wolckcho54!";
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isLoading = true;
                    errorMessage = null;
                  });

                  AuthClient client = AuthClient();

                  if (usernameController.text.isEmpty && passwordController.text.isEmpty) {
                    setState(() {
                      usernameTextFieldError = true;
                      passwordTextFieldError = true;
                      _isLoading = false;
                    });
                    return;
                  }

                  if (usernameController.text.isEmpty) {
                    setState(() {
                      usernameTextFieldError = true;
                      _isLoading = false;
                    });
                    return;
                  } else setState(() { usernameTextFieldError = false; });

                  if (passwordController.text.isEmpty) {
                    setState(() {
                      passwordTextFieldError = true;
                      _isLoading = false;
                    });
                    return;
                  } else setState(() {passwordTextFieldError = false;});

                  try {
                    String token = await client.login(usernameController.text, passwordController.text);
                    setState(() {errorMessage = null;});
                    Student student = await getStudentInfo(token);
                    await Auth.saveStudent(Auth(username: usernameController.text, password: passwordController.text));
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentDashboard(student: student)));
                  } on UnauthorizedException {
                    setState(() {
                      errorMessage = "Ο λογαριασμός σας δεν αναγνωρίζεται και δεν μπορείτε να συνδεθείτε αυτήν τη στιγμή";
                    });
                  } catch (e) {
                    setState(() {
                      errorMessage = "Προέκυψε κάποιο σφάλμα, παρακαλώ δοκιμάστε ξανά αργότερα";
                    });
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Σύνδεση',
                      style: TextStyle(color: Colors.white),
                    ),
                    if (_isLoading) ...[
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }



    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Top 35% with logo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.35,
            child: Center(
              child: Image.asset(
                'assets/images/universis-logo-transp.png',
                height: screenHeight * 0.15,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bottom 65% with form
          Positioned(
            top: screenHeight * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _usernameFieldWidget(),
                  const SizedBox(height: 20),
                  _passwordFieldWidget(),
                  const SizedBox(height: 30),
                  _loginButtonWidget(),
                  _resetPasswordWidget(),

                        // Reserve space for the error message with fixed height
                    Expanded(
                      child: errorMessage != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Align(  // optional, to keep text at top-left
                                alignment: Alignment.topLeft,
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xffDE3163),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
