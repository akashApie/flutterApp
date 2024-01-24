import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(const Maps());
}

class Maps extends StatelessWidget {
  const Maps({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MapPage',
      home: Address(),
    );
  }
}

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  Location createState() => Location();
}

class Location extends State<Address> {
  @override
  void initState() {
    super.initState();
    readJson();
  }

  List file = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    Map<String, dynamic> data = await json.decode(response);
    setState(() {
      file = data["items"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ReorderableListView.builder(
            itemBuilder: (context, index) {
               return ListTile(
                  key: ValueKey(file[index]['id']),
                          leading: ReorderableDragStartListener(index: index,
                          child: const Icon(Icons.drag_indicator),
                          ),
                          title: Text(file[index]['description']),
                 
              );
            },
            itemCount: file.length,
            onReorder: (start, curr) {
              if (start < curr) {
                int end = curr - 1;
                String startItem = file[start];
                int i = 0;
                int local = start;
                do {
                  file[local] = file[++local];
                  i++;
                } while (i < end - start);
                file[end] = startItem;
              } else if (start > curr) {
                String startItem = file[start];
                for (int i = start; i > curr; i--) {
                  file[i] = file[i - 1];
                }
                file[curr] = startItem;
              }
            },
          ),
        ));
  }
}
