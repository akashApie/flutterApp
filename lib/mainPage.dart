import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/main.dart';
import 'package:first_app/maps.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage(
    data: {},
  ));
}

class HomePage extends StatelessWidget {
  final Map<String, dynamic> data;
  const HomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: FirstPage(data: data),
    );
  }
}

class Items {
  String name;
  IconData icon;

  Items({required this.icon, required this.name});
}

class FirstPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const FirstPage({super.key, required this.data});

  @override
  LandingPage createState() => LandingPage();
}

class LandingPage extends State<FirstPage> with SingleTickerProviderStateMixin {
  bool selected = false;

  final auth = FirebaseAuth.instance;

  final List<Items> contents = [
    Items(name: 'My Orders', icon: Icons.contact_page),
    Items(name: 'Delivery Address', icon: Icons.location_on),
    Items(name: 'Payment History', icon: Icons.credit_card_outlined),
    Items(name: 'Notifications', icon: Icons.notifications),
  ];

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();

    contents.map((e) => {
          widgets.add(ListTile(
            title: Text(e.name),
            leading: Icon(e.icon),
          ))
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController pickupController = TextEditingController();
    final TextEditingController dropController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    MediaQueryData data = MediaQuery.of(context);
    var width = data.size.width;
    var height = data.size.height;

    final List<Items> things = [
      Items(name: 'Groceries', icon: Icons.store),
      Items(name: 'Medicine', icon: Icons.medical_information),
      Items(name: 'Documents', icon: Icons.edit_note_sharp),
      Items(name: 'Cakes', icon: Icons.cake),
      Items(name: 'Food', icon: Icons.fastfood),
    ];

    String Name = widget.data['Name'];
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: selected ? Colors.orangeAccent : Colors.blueAccent,
          title: const Text('Pickup Ninja'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                setState(() {
                  selected = !selected;
                });
              },
              icon: const Icon(Icons.menu)),
          actions: const [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ))
          ],
        ),
        body: Container(
            color: Colors.orangeAccent,
            child: Stack(children: [
              Container(
                color: selected ? Colors.orangeAccent : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                      child: Row(
                        children: [
                          const Image(
                              image: NetworkImage(
                                  'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png'),
                              height: 70,
                              width: 70),
                          Text(
                            Name.toString(),
                            style: const TextStyle(
                                fontFamily: AutofillHints.birthdayDay,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: contents.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: Icon(contents[index].icon),
                              title: Text(contents[index].name),
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          TextButton(
                            onPressed: () {
                              auth.signOut().then((value) =>
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Login())));
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: AutofillHints.birthdayDay,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                  // )
                ),
              ),
              Stack(
                children: <Widget>[
                  AnimatedPositioned(
                      duration: const Duration(seconds: 3),
                      left: selected ? 260.0 : 0.0,
                      top: selected ? 60.0 : 0.0,
                      bottom: selected ? 60.0 : 0.0,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            color: Colors.grey[600]?.withOpacity(0.3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                      )),
                  AnimatedPositioned(
                      left: selected ? 300.0 : 0.0,
                      top: selected ? 25.0 : 0.0,
                      bottom: selected ? 25.0 : 0.0,
                      curve: Easing.emphasizedAccelerate,
                      duration: const Duration(seconds: 2),
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: selected
                                ? const BorderRadius.all(Radius.circular(50))
                                : const BorderRadius.all(Radius.circular(0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: selected
                                      ? const BorderRadius.all(
                                          Radius.circular(50.0))
                                      : const BorderRadius.only(
                                          bottomLeft: Radius.circular(50.0),
                                          bottomRight: Radius.circular(50.0)),
                                  color: Colors.blueAccent),
                              child: Form(
                                key: formKey,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 80),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFormField(
                                          readOnly: true,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Address()));
                                          },
                                          controller: pickupController,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.store),
                                            hintText: 'Pickup Location',
                                            suffixIcon: Icon(
                                                Icons.arrow_forward_ios_sharp),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.purple),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                          ),
                                          // )
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Address()));
                                          },
                                          controller: dropController,
                                          decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.flag),
                                              suffixIcon: Icon(Icons
                                                  .arrow_forward_ios_sharp),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.purple),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                              ),
                                              hintText: 'Drop Location'),
                                          // )
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50),
                              child: SizedBox(
                                  height: 60,
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.sticky_note_2_outlined),
                                      suffixIcon:
                                          Icon(Icons.arrow_forward_ios_sharp),
                                      hintText: 'Add instructions',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                  width: 200,
                                  child: CarouselSlider(
                                      items: things.map((e) {
                                        return TextField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(e.icon),
                                            hintText: e.name,
                                          ),
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                          enlargeCenterPage: true,
                                          enlargeStrategy:
                                              CenterPageEnlargeStrategy.scale,
                                          enlargeFactor: 1))),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ])));
  }
}
