import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mhike_app/screen/home_screen.dart';
import 'package:mhike_app/screen/sign_up_screen.dart';
import 'package:get/get.dart';
import '../service/get_x/get_x.dart';
import '../service/user_auth.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final UserDataController userDataController = Get.put(UserDataController());
  late bool obscurrentText=true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String validPassword="";
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () => AuthService().hideKeyBoard(),
        child: SingleChildScrollView(
          child:Column(
            children: [
              SizedBox(
                height: height,
                child: Stack(
                  children: [
                    Container(height: height*0.4,width: width,color: Colors.green,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 40),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo1.jpg"),
                          fit: BoxFit.fill
                        )
                      ),
                      ),
                    ),
                    Align(alignment: Alignment.bottomCenter,
                        child: Container(
                          height: height*0.65,
                          width: width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Sign In",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
                                Form(
                                  key: _formkey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:8.0),
                                        child: SizedBox(
                                          width: width*0.85,
                                          child: TextFormField(
                                            validator:(value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                                            keyboardType: TextInputType.emailAddress,
                                            controller: _emailController,
                                            decoration: const InputDecoration(
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(width: 1),
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                              ),
                                              prefixIcon: Icon(Icons.email_outlined,size: 30,),
                                              hintText: "Enter E-mail",
                                              labelText: "E-mail",
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:8.0),
                                        child: SizedBox(
                                          width: width*0.85,
                                          child: TextFormField(
                                            validator:(value) => validPassword=="" ? null :"Wong Password",
                                            keyboardType: TextInputType.emailAddress,
                                              obscureText: obscurrentText,
                                              controller: _passwordController,
                                            decoration:  InputDecoration(
                                              alignLabelWithHint: true,
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(width: 1),
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                              ),
                                              prefixIcon: Icon(Icons.lock_outline,size: 30,),
                                              hintText: "Enter Password",
                                              labelText: "Password",
                                              suffixIcon: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    obscurrentText=!obscurrentText;
                                                  });
                                                },
                                                child: Icon(obscurrentText?Icons.visibility_off_outlined:Icons.visibility_outlined),
                                            ),)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // customTextField(width,"E-mail",Icons.email_outlined,_emailController),
                                // customTextField(width,"Password",Icons.lock_outline,_passwordController ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: ()async {
                                    final message = await AuthService().login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    if (message!.contains('Success')) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const HomeScreen(),
                                        ),
                                      );
                                    }
                                    setState(() {
                                      validPassword=message;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message),
                                      ),
                                    );
                                    _formkey.currentState!.validate();
                                  },
                                  child: Container(
                                    height:height*0.06,
                                    margin: const EdgeInsets.symmetric(vertical: 25,horizontal: 35),
                                    decoration: BoxDecoration(
                                      // color: Color(0xFF00B6F0),
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Theme.of(context).colorScheme.primary
                                                .withOpacity(0.5),
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Sign In',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          letterSpacing: 0.0,
                                          color: Color(0xFFffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("You don't have an account?",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15)),
                                      TextButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                                      },
                                          child: const Text("Create account.",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.blue,fontSize: 15)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
  Padding customTextField(double width,String title,IconData icon,TextEditingController _controller){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:13.0),
      child: SizedBox(
        width: width*0.85,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            prefixIcon: Icon(icon,size: 30,),
            hintText: "Enter $title",
            labelText: title,
          ),
        ),
      ),
    );
  }
}
