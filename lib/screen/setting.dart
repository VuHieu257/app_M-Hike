import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhike_app/screen/home_screen.dart';
import '../service/get_x/get_x.dart';
import '../service/user_auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final UserDataController userDataController = Get.put(UserDataController());

  late bool obsCurrentText=true;
  late bool obsCurrentTextOldPassword=true;
  late bool obsCurrentTextNewPassword=true;
  late bool statusEditProfile=true;
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController textEditingControllerName=TextEditingController();
  TextEditingController textEditingControllerOldPassword=TextEditingController();
  TextEditingController textEditingControllerNewPassword=TextEditingController();

  Uint8List?_img;
  void selectImage() async{
    Uint8List img=await AuthService().pickImage(ImageSource.gallery);
    setState(() {
      userDataController.setX(img);
      _img=img;
    });
  }
  @override
  Widget build(BuildContext context) {
    // print(userDataController.getX());
    // print(user.)
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: ()=>AuthService().hideKeyBoard(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: InkWell(onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen(),)),child: const Icon(Icons.arrow_back_rounded,color: Colors.white,),),
          title: const Text("Setting",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        ),
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(20),
            child: statusEditProfile?
            Column(
              children: [
                const Text("My Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black),),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: height*0.2,
                    width: width*0.4,
                    margin: const EdgeInsets.symmetric(vertical: 35),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: GetBuilder<UserDataController>(
                            builder: (controller) {
                              // Lấy hình ảnh từ controller
                              Uint8List? imageData = controller.getX();
                              // Kiểm tra xem imageData có dữ liệu không
                              if (imageData != null) {
                                // Nếu có dữ liệu, hiển thị hình ảnh
                                return SizedBox(
                                  height: height*0.18,
                                  width: height*0.18,
                                  child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: MemoryImage(imageData)),
                                );
                              } else {
                                // Nếu không có dữ liệu, hiển thị một thông báo hoặc widget khác
                                return const CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage("assets/images/avatar.png"),
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: InkWell(
                            onTap: selectImage,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              child: const Icon(Icons.add_a_photo_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                costomTextField("Full Name","${userDataController.displayName}",textEditingControllerName,Icons.account_circle_outlined,statusEditProfile),
                costomTextField("E-mail","${userDataController.email}",textEditingControllerName,Icons.email_outlined,statusEditProfile),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: "${userDataController.password}"),
                    keyboardType:  TextInputType.visiblePassword,
                    obscureText: obsCurrentText,
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      labelStyle: TextStyle(color:Theme.of(context).colorScheme.primary),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.lock_outline,color: Theme.of(context).colorScheme.primary,size: 30,),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            obsCurrentText=!obsCurrentText;
                          });
                        },
                        child: Icon(obsCurrentText?Icons.visibility_off_outlined:Icons.visibility_outlined),
                      ),

                    ),),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      statusEditProfile=!statusEditProfile;
                    });
                  },
                  child: Container(
                    height: height*0.06,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Text("Edit Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                  ),
                )
              ],
            ):
            Column(
              children: [
                const Text("My Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black),),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: height*0.2,
                    width: width*0.4,
                    margin: const EdgeInsets.symmetric(vertical: 35),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: GetBuilder<UserDataController>(
                            builder: (controller) {
                              // Lấy hình ảnh từ controller
                              Uint8List? imageData = controller.getX();
                              // Kiểm tra xem imageData có dữ liệu không
                              if (imageData != null) {
                                // Nếu có dữ liệu, hiển thị hình ảnh
                                return SizedBox(
                                  height: height*0.18,
                                  width: height*0.18,
                                  child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: MemoryImage(imageData)),
                                );
                              } else {
                                // Nếu không có dữ liệu, hiển thị một thông báo hoặc widget khác
                                return const CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage("assets/images/avatar.png"),
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            child: const Icon(Icons.add_a_photo_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller:textEditingControllerName,
                    keyboardType:  TextInputType.text,
                    decoration: InputDecoration(
                      label: const Text("User Name"),
                      hintText: "Enter User Name",
                      labelStyle: TextStyle(color:Theme.of(context).colorScheme.primary),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.lock_outline,color: Theme.of(context).colorScheme.primary,size: 30,),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller:textEditingControllerOldPassword,
                    keyboardType:  TextInputType.visiblePassword,
                    obscureText: obsCurrentTextOldPassword,
                    decoration: InputDecoration(
                      label: const Text("Old Password"),
                      hintText: "Enter Old password",
                      labelStyle: TextStyle(color:Theme.of(context).colorScheme.primary),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.lock_outline,color: Theme.of(context).colorScheme.primary,size: 30,),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            obsCurrentTextOldPassword=!obsCurrentTextOldPassword;
                          });
                        },
                        child: Icon(obsCurrentTextOldPassword?Icons.visibility_off_outlined:Icons.visibility_outlined),
                      ),

                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    controller:textEditingControllerNewPassword,
                    keyboardType:  TextInputType.visiblePassword,
                    obscureText: obsCurrentTextNewPassword,
                    decoration: InputDecoration(
                      label: const Text("New Password"),
                      hintText: "Enter New password",
                      labelStyle: TextStyle(color:Theme.of(context).colorScheme.primary),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.lock_outline,color: Theme.of(context).colorScheme.primary,size: 30,),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            obsCurrentTextNewPassword=!obsCurrentTextNewPassword;
                          });
                        },
                        child: Icon(obsCurrentTextNewPassword?Icons.visibility_off_outlined:Icons.visibility_outlined),
                      ),

                    ),),
                ),
                InkWell(
                  onTap: () async {
                    await AuthService().changePassword(
                      email: "${userDataController.email}",
                      oldPassword: textEditingControllerOldPassword.text,
                      newPassword: textEditingControllerNewPassword.text,
                    );

                    setState(() {
                      statusEditProfile=!statusEditProfile;
                      userDataController.updateUserData(
                        textEditingControllerName.text,
                      textEditingControllerNewPassword.text,
                        "${user!.email}",
                      );
                    });
                    textEditingControllerName.clear();
                    textEditingControllerOldPassword.clear();
                    textEditingControllerNewPassword.clear();
                  },
                  child: Container(
                    height: height*0.06,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Text("Save",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Padding costomTextField(String title,String description,TextEditingController controller,IconData icon,bool status){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextField(
        controller: status?TextEditingController(text: description):controller,
        readOnly:status?true:false,
        decoration: InputDecoration(
            label: Text(title),
            hintText: status?"":"Previous name: $description",
            labelStyle: TextStyle(color:Theme.of(context).colorScheme.primary),
            alignLabelWithHint: true,
            prefixIcon: Icon(icon,color: Theme.of(context).colorScheme.primary,size: 30,),
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(20))
            )
        ),),
    );
  }
}

