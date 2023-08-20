import 'package:flutter/material.dart';

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


  void passwordVisibilitySwitch() {
    setState(() {
      hidePass = !hidePass;
    });
  }

  void login() {
    print('Login');
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
        child: Column(
          children: [

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
                onChanged: (val) {

                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: TextFormField(
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
                onChanged: (val) {

                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              child: InkWell(
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
              ),
            ),

          ],
        ),
      ),
    );
  }
}
