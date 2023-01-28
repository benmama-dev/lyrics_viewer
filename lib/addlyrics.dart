import 'dart:convert';
import 'database/db_service.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Addlyricss extends StatefulWidget {
  const Addlyricss({Key? key}) : super(key: key);

  @override
  State<Addlyricss> createState() => _AddlyricssState();
}

class _AddlyricssState extends State<Addlyricss> {
  var nameSoung = TextEditingController();
  var name = TextEditingController();
  var image = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('เพิ่มเนื้อเพลง - คอร์ดเพลง'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Form(
              child: SingleChildScrollView(
            child: Column(
              children: [
                TextFromF('ชื่อเพลง', 'ยาพิษ', nameSoung),
                TextFromF('ศิลปิน', 'Bodyslam', name),
                // TextFromF('time', 'Time'),
                (img == null)
                    ? Icon(
                        Icons.insert_photo,
                        size: 300,
                      )
                    : Image.file(img),
                IconButton(
                    onPressed: () async {
                      PickedFile? pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          maxWidth: 1800,
                          maxHeight: 1800);
                      String bit =
                          base64Encode(await pickedFile!.readAsBytes());
                      image.text = bit;
                      if (pickedFile != null) {
                        setState(() {
                          img = File(pickedFile.path);
                        });
                      }
                    },
                    icon: const Icon(Icons.camera_alt)),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: RaisedButton(
                          color: Colors.blue,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: const Text(
                            'เพื่มข้อมูล',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            DBService service = DBService();
                            ProfileModel profile = ProfileModel();
                            profile.nameSoung = nameSoung.text;
                            profile.name = name.text;
                            profile.image = image.text;
                            var data = profile.profileMap();
                            service.insertData(data);
                            print(service);
                            Navigator.pop(context);
                          }),
                          
                    ),
                    
                  ],
                )
              ],
            ),
          ))),
    );
  }


  Padding TextFromF(
      String lText, String hText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: lText,
            hintText: hText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
