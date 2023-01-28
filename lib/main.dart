import 'package:flutter/material.dart';
import 'package:lyrics_viewer/addlyrics.dart';
import 'package:lyrics_viewer/showdeteil.dart';
import 'database/db_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileModel {
  late int id;
  late String nameSoung;
  late String name;
  late String image;

  profileMap() {
    var mapping = <String, dynamic>{};
    mapping['nameSoung'] = nameSoung;
    mapping['name'] = name;
    mapping['image'] = image;
    return mapping;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.maliTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'แอปดูเนื้อเพลง/คอร์ดกีตาร์'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProfileModel> entries = <ProfileModel>[];
  List<ProfileModel> list = <ProfileModel>[];

  void searchLyrics(String value) {
    setState(() {
      list = entries
          .where((element) =>
              element.nameSoung.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }  

  getAllData() async {
    entries = <ProfileModel>[];
    list = <ProfileModel>[];
    var service = DBService();
    var profile = await service.readData();
    // print(profile);
    profile.forEach((pro) {
      setState(() {
        var proModel = ProfileModel();
        proModel.id = pro['id'];
        proModel.nameSoung = pro['nameSoung'];
        proModel.name = pro['name'];
        proModel.image = pro['image'];
        entries.add(proModel);
        list = entries;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 60,
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) => searchLyrics(value),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue.shade100)),
              ),
            ),
          ),
          Expanded(
              child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final entriess = list[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(13, 3, 0, 3),
                  leading: const Icon(
                    Icons.my_library_music_sharp,
                    size: 50,
                    color: Colors.white,
                  ),
                  title: Text(entriess.nameSoung),
                  subtitle: Text(entriess.name),
                  tileColor: Colors.blue[700],
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShowDetial(
                              entriess: entriess,
                            )));
                  },
                  trailing: IconButton(
                      onPressed: () async {
                        var service = DBService();
                        // ignore: unused_local_variable
                        var result = await service.deleteData(entriess.id);
                        getAllData();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        size: 30,
                        color: Colors.white,
                      )),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ))
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Addlyricss()),
          ).then((value) {
            getAllData();
            setState(() {});
          });
        },
        icon: const Icon(
          Icons.add,
        ),
        label: const Text('เพิ่มเนื้อเพลง'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
