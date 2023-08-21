
import 'package:flutter/material.dart';
import 'package:weather_app_test/functions/auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final color0 = Colors.indigoAccent.shade700;
  bool hidePass = false;
  final AuthService authService = AuthService();
  bool trying = false;
  String errorMsg = '';

  void passwordVisibilitySwitch() {
    setState(() {
      hidePass = !hidePass;
    });
  }

  void login() async {
    errorMsg = '';
    setState(() {
      trying = true;
    });
    var result = await authService.signInFunction(emailController.text, passwordController.text);
    if(result == null) {
      errorMsg = 'Ошибка аутентификации';
      setState(() {
        trying = false;
      });
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// title and description
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Вход',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Ubuntu'
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Введите данные для входа',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontFamily: 'RobotoRegular'
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// email text field
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey.shade500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color0),
                    ),
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.redAccent,
                  onChanged: (val) {},
                ),
              ),

              /// password text field
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: TextFormField(
                  obscureText: hidePass,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      color: color0,
                      icon: hidePass ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      onPressed: passwordVisibilitySwitch,
                    ),
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: Colors.grey.shade500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color0),
                    ),
                  ),
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Colors.redAccent,
                  onChanged: (val) {},
                ),
              ),

              /// login button
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                child: !trying ? InkWell(
                  onTap: login,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color0,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Войти',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'RobotoBold'
                        ),
                      ),
                    ),
                  ),
                ) : Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color0,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white,)
                    ),
                  ),
                ),
              ),

              /// error message
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Text(
                    errorMsg,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'RobotoRegular'
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
