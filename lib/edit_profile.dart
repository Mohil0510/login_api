import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'login_page.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _image;
  final picker = ImagePicker();
  String _urlImage = "https://i.imgur.com/pXNW6nZ.jpg";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 20,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55, bottom: 30),
                  child: Stack(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image != null
                                    ? FileImage(_image)
                                    : NetworkImage("$_urlImage"))),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () => getImage(),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.lightBlue,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'User Name',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Email ',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      deleteUser();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Delete Profile',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    updateUserDetails();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await get(
        Uri.parse(
          "${AppConfig.baseUrl}/profile-detail",
        ),
        headers: {"Authorization": prefs.getString("TOKEN")});
    print(response.statusCode);
    if (response.statusCode == 200) {
      // loader true
      var decoded = jsonDecode(response.body);
      print(decoded);
      setState(() {
        _nameController.text = decoded["data"]["name"];
        _emailController.text = decoded["data"]["email"];
        _urlImage =
            decoded["data"]["profile"] ?? "https://i.imgur.com/pXNW6nZ.jpg";
      });
    }
  }

  updateUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var response = await post(
    //     Uri.parse(
    //       "${AppConfig.baseUrl}/profile-update",
    //     ),
    //     headers: {
    //       "Authorization": prefs.getString("TOKEN")
    //     },
    //     body: {
    //       "name": "${_nameController.text}",
    //       "email": "${_emailController.text}",
    //       "_method": "PUT",
    //     });

    // if (response.statusCode == 200) print('Uploaded!');

    // if (response.statusCode == 200) {
    //   // loader true
    //   var decoded = jsonDecode(response.body);

    //   Fluttertoast.showToast(
    //     msg: "${decoded["message"]}",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //   );
    // }

    var uri = Uri.parse('${AppConfig.baseUrl}/profile-update');
    var request = MultipartRequest('POST', uri)
      ..fields['name'] = "${_nameController.text}"
      ..fields['email'] = "${_emailController.text}"
      ..files.add(await MultipartFile.fromPath(
        'picture',
        '${_image?.path}',
      ));
    var res = await request.send();
    print(res.statusCode);
  }

  deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await delete(
        Uri.parse(
          "${AppConfig.baseUrl}/profile-delete",
        ),
        headers: {"Authorization": prefs.getString("TOKEN")});
    print(response.statusCode);
    if (response.statusCode == 200) {
      // loader true
      var decoded = jsonDecode(response.body);

      // clear creds
      prefs.clear();

      Fluttertoast.showToast(
        msg: "${decoded["message"]}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }
}
