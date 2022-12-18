import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class AddLokasiPage extends StatefulWidget {
  const AddLokasiPage({Key? key}) : super(key: key);

  @override
  State<AddLokasiPage> createState() => _AddLokasiPageState();
}

class _AddLokasiPageState extends State<AddLokasiPage> {
  TextEditingController textNode = TextEditingController();
  TextEditingController textNama = TextEditingController();
  TextEditingController textLat = TextEditingController();
  TextEditingController textLng = TextEditingController();
  Future<List<dynamic>> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/no-banjir/get.php"));
    return json.decode(response.body);
  }

  Future<List<dynamic>> getDetail(String nodeid) async {
    final response = await http
        .get(Uri.parse("http://10.0.2.2/no-banjir/detail.php?node_id=$nodeid"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    String username = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
        appBar: AppBar(
          title: const Text("NO BANJIR"),
        ),
        drawer: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox.shrink(); //<---here
            } else {
              if (snapshot.hasData) {
                return DrawList(list: snapshot.data!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          },
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: textNode,
                    decoration: InputDecoration(
                      labelText: 'Node Id',
                      hintText: 'Masukkan Node ID',
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: textNama,
                    decoration: InputDecoration(
                      labelText: 'Nama Lokasi',
                      hintText: 'Masukkan Nama Lokasi',
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: textLat,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      hintText: 'Masukkan Latitude',
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: textLng,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      hintText: 'Masukkan Longitude',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    child: Text('Submit Data'),
                    onPressed: () {
                      tambahData(
                          textNode.text,
                          textNama.text,
                          double.parse(textLat.text),
                          double.parse(textLng.text));
                      Navigator.pushNamed(context, '/dashboard',
                          arguments: username);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void tambahData(String nodeid, String namaloc, double lat, double lng) async {
    String sql =
        "http://10.0.2.2/no-banjir/add.php?node_id=$nodeid&nama_loc=$namaloc&latitude=$lat&longitude=$lng";
    await http.get(Uri.parse(sql));
  }
}

class DrawList extends StatefulWidget {
  final List<dynamic> list;
  const DrawList({super.key, required this.list});

  @override
  State<DrawList> createState() => _DrawListState();
}

class _DrawListState extends State<DrawList> {
  @override
  Widget build(BuildContext context) {
    String username = ModalRoute.of(context)!.settings.arguments.toString();
    if (widget.list != null) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    )
                  ],
                )),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => Navigator.pushNamed(context, '/dashboard',
                  arguments: username),
            ),
            ExpansionTile(
              leading: Icon(Icons.auto_graph),
              title: Text('Grafik'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(widget.list[index]['nama_loc']),
                      onTap: () => Navigator.pushNamed(context, '/detail',
                          arguments: [widget.list[index], username]),
                    );
                  },
                )
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.file_copy),
              title: Text('Data'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(widget.list[index]['nama_loc']),
                      onTap: () => Navigator.pushNamed(context, '/log',
                          arguments: [widget.list[index], username]),
                    );
                  },
                )
              ],
            ),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('Tambah Lokasi'),
              onTap: () => Navigator.pushNamed(context, '/add'),
            )
          ],
        ),
      );
    } else {
      return Text(" No Data");
    }
  }
}
