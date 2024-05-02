import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mhike_app/screen/sign_in_screen.dart';
import 'package:mhike_app/service/user_auth.dart';
import '../models/m_hike.dart';
import '../service/database/database_service.dart';
import '../service/get_x/get_x.dart';
import 'package:get/get.dart';
import 'setting.dart';
import 'detail_hike.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UserDataController userDataController = Get.put(UserDataController());

  final TextEditingController _textEditingControllerName=TextEditingController();
  final TextEditingController _textEditingControllerLocation=TextEditingController();
  final TextEditingController textEditingControllerLength=TextEditingController();
  final TextEditingController _textEditingControllerDescription=TextEditingController();

  bool _selectedValueParkingAvailable = true;
  bool statusVisibility = false;
  bool statusData = false;
  int _selectedValue = 1;
  String nameSearch= "";

  final user = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService=DatabaseService();
  @override
  Widget build(BuildContext context) {
    print(userDataController.getX());
    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      child: GestureDetector(
        onTap: () => AuthService().hideKeyBoard(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _appBar(),
          body: SafeArea(
            child: Column(
              children: [
                _messagesListView(),
              ],
            ),
          ),
          floatingActionButton: Localizations(
            locale: const Locale('en', 'US'),
            delegates: const <LocalizationsDelegate<dynamic>>[
              DefaultWidgetsLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
            ],
            child: FloatingActionButton(
              onPressed: _displayTextInputDialog,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add,color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Center(
        child: Text("M-Hike",
          style: TextStyle(color: Colors.white,),
          // textDirection: TextDirection.ltr,
        ),
      ),

      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: GetBuilder<UserDataController>(
          builder: (controller) {
            // Lấy hình ảnh từ controller
            Uint8List? imageData = controller.getX();
            // Kiểm tra xem imageData có dữ liệu không
            if (imageData != null) {
              // Nếu có dữ liệu, hiển thị hình ảnh
              return CircleAvatar(
                  radius: 60,
                  backgroundImage: MemoryImage(imageData));
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
      actions: [
        Row(
          children: [
            PopupMenuButton(
              iconColor: Colors.white,
              iconSize: 30,
              itemBuilder: (context) =>
              [
                PopupMenuItem(child:Column(
                  children: [
                    SizedBox(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("user_mhike_database").where("email",isEqualTo: user!.email).snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.hasData!=true){
                            return const Center(
                              child: Text("Add new location"),
                            );
                          }else{
                            userDataController.updateUserData(
                              snapshot.data?.docs[0].data()["displayName"],
                              snapshot.data?.docs[0].data()["password"],
                              "${user!.email}",
                            );
                          }
                          return Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 10,),
                              Text("${userDataController.displayName}"),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    )
                  ],
                ) ),
                PopupMenuItem(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage(),)),
                  child: const Row(
                  children: [
                    Text("Setting"),
                    SizedBox(width: 5,),
                    Icon(Icons.settings),
                  ],
                ),)),
                PopupMenuItem(child: InkWell(onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),));
                  // userDataController.updateUserData("","","");
                  Get.delete<UserDataController>();
                },
                  child: const Row(
                    children: [
                      Text("LogOut"),
                      SizedBox(width: 5,),
                      Icon(Icons.logout),
                    ],
                  ),)),
              ],),
          ],
        )
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20)
          )
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          margin: const EdgeInsets.only(top: 10,bottom: 20,left:20, right: 20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "search something ....",
              hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),
            ),
            onChanged: (value) {
              setState(() {
                nameSearch=value;
              });
            },
          ),
        ),
      ),
    );
  }
  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream:_databaseService.getfind('createdAccount', '${user?.email}'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var docs = snapshot.data?.docs;
          // Lọc danh sách dựa trên từ khóa tìm kiếm
          List<dynamic>? filteredDocs = docs
              ?.where((doc) =>
              doc!["name"]
                  .toString()
                  .toLowerCase()
                  .startsWith(nameSearch.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredDocs?.length,
            itemBuilder: (context, index) {
              var doc = filteredDocs?[index];
              String docId = doc.id;
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailHikePage(
                      id: docId,
                      name: doc?["name"],
                      locationOfHike: doc?["locationOfHike"],
                      lengthOfHike: doc?["lengthOfHike"],
                      description: doc?["description"],
                      levelOfHike: doc?["levelOfHike"],
                      date: doc?["date"],
                      parkingAvailable: doc?["parkingAvailable"],
                      createdAccount: doc?["createdAccount"],
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    tileColor: Colors.green,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          doc?['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pin_drop, color: Colors.white),
                            const SizedBox(width: 8),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Location: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: doc?["locationOfHike"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " - ${doc?["lengthOfHike"]}m",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              "Date start: ${DateFormat("MM-dd-yyyy h:mm a").format(doc?["date"].toDate())}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  void _displayTextInputDialog()async{
    showDialog(
      context: context,
      builder: (context){
        return Localizations(
          locale: const Locale('en', 'US'),
          delegates: const <LocalizationsDelegate<dynamic>>[
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
          child: AlertDialog(
            title: const Text("Add new location"),
            content: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height*0.4,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textEditingControllerName,
                        validator: (value) => value==null||value.isEmpty?'Please enter data.':null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(hintText: "Enter Name",hintStyle: TextStyle(fontSize: 18)),
                      ),
                    ),
                    Expanded(child:
                      TextFormField(
                        controller: _textEditingControllerLocation,
                        validator: (value) => value==null||value.isEmpty?'Please enter data.':null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(hintText: "Enter Location",hintStyle: TextStyle(fontSize: 18)),
                      ),
                     ),
                    Expanded(child:Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Text("Parking Available",  style: TextStyle(fontSize: 18),),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.blue.shade50,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(width: 1,color: Colors.blue)
                            ),
                            padding: const EdgeInsets.all(5),
                            child: DropdownButton<bool>(
                              iconEnabledColor: Colors.blue,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              value:_selectedValueParkingAvailable,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _selectedValueParkingAvailable = newValue!;
                                  print(_selectedValueParkingAvailable);
                                });

                              },
                              underline: Container(),
                              items: const [
                                DropdownMenuItem<bool>(
                                  value: true,
                                  child: Text('Yes'),
                                ),
                                DropdownMenuItem<bool>(
                                  value: false,
                                  child: Text('No'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),),
                    Expanded(child:
                      TextFormField(
                        controller: textEditingControllerLength,
                        validator: (value) => value==null||value.isEmpty||double.tryParse(value) == null?'Please enter a valid number.':null,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "Enter Length",hintStyle: TextStyle(fontSize: 18)),
                      ),),
                    Expanded(child:Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.leaderboard_outlined),
                          const SizedBox(width: 10,),
                          const Text("Level",  style: TextStyle(fontSize: 18),),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(width: 1,color: Colors.blue)
                            ),
                            padding: const EdgeInsets.all(5),
                            child: DropdownButton<int>(
                              iconEnabledColor: Colors.blue,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              value: _selectedValue,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedValue = newValue!;
                                  // print(_selectedValue);
                                });
                              },
                              underline: Container(),
                              items: const [
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('Easy'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text('Normal'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 3,
                                  child: Text('Hard'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),),
                    Expanded(child:
                      TextFormField(
                        controller: _textEditingControllerDescription,
                        validator: (value) => value==null||value.isEmpty?'Please enter data.':null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(hintText: "Enter Description",hintStyle: TextStyle(fontSize: 18)),
                      ),),
                    // customeTextField(_textEditingControllerDate,TextInputType.text,"Enter Date"),
                  ],
                ),
              ),
            ),
            actions: [
              MaterialButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Todo todo = Todo(
                    name: _textEditingControllerName.text,
                    description: _textEditingControllerDescription.text,
                    locationOfHike: _textEditingControllerLocation.text,
                    levelOfHike: _selectedValue,
                    lengthOfHike: int.parse(textEditingControllerLength.text),
                    date: Timestamp.now(),
                    parkingAvailable: true,
                    createdAccount: "${user!.email}",
                  );
                  try {
                    await _databaseService.addTodo(todo);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Update success'),
                    ));
                  } catch (error) {
                    print('Error updating todo: $error');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Update failed. Please try again.'),
                    ));
                  }
                  _textEditingControllerName.clear();
                  _textEditingControllerLocation.clear();
                  textEditingControllerLength.clear();
                  _textEditingControllerDescription.clear();
                }
              },
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                child: const Text('OK'),
              )
            ],
          ),
        );
      },
    );
  }
  TextField customeTextField(TextEditingController _controller,TextInputType keyboardType,String texthint){
    return   TextField(
      controller:_controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: texthint,hintStyle: const TextStyle(fontSize: 18)),
    );
  }
}
