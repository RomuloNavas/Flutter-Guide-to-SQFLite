import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guide_sqflite/database/category_operations.dart';
import 'package:guide_sqflite/database/contact_operations.dart';
import 'package:guide_sqflite/database/database.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CategoryOperations categoryOperations = CategoryOperations();
  ContactOperations contactOperations = ContactOperations();
  // List<String> categories = [
  //   'none',
  //   'family',
  //   'work',
  //   'store',
  //   'friend',
  //   'chick'
  // ];
  List<String> categories = [];
  Category selectedCategory = Category(name: '');

  // SIDE PANEL
  final sidePanelWidth = 360.0;
  // TEXT FIELD VARIABLES
  late TextEditingController _textEditingController;
  FocusNode _focusNode = FocusNode();
  Color _fieldFillColor = Color(0xffffffff);
  Color _fieldTextColor = Color(0xff202c46);

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _fieldFillColor = Color(0xffffffff);
          _fieldTextColor = Color(0xff202c46);
        });
      } else {
        setState(() {
          _fieldFillColor = Color(0xffffffff);
          _fieldTextColor = Color(0xff202c46);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: sidePanelWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff071430),
                  Color(0xff032058),
                  Color(0xff032058),
                ],
              ),
              border: Border(
                right: BorderSide(
                  width: 1.0,
                  color: Color(0xff2a3c61),
                ),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 32 + 32,
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: IconButton(
                                  tooltip: 'Back',
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 32,
                                  ),
                                  onPressed: () => null,
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Romulo Navas',
                                          style: TextStyle(
                                              color: Color(0xff838997))),
                                      Text('16 contacts',
                                          style: TextStyle(
                                              color: Color(0xff6b707c))),
                                    ],
                                  ),
                                  SizedBox(width: 12),
                                  ContactCircleAvatar(
                                    radius: 27,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  width: sidePanelWidth,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _textEditingController,
                          style: TextStyle(color: _fieldTextColor),
                          cursorColor: Colors.grey,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _fieldFillColor,
                            contentPadding: const EdgeInsets.all(0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Add contact',
                            hintStyle: const TextStyle(
                                color: Color(0xff838997), fontSize: 18),
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(15),
                              width: 18,
                              child: Icon(
                                Icons.search,
                                size: 26,
                                color: _fieldTextColor,
                              ),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (_textEditingController.text != '') {
                                  // searchedClients.clear();
                                  _textEditingController.text = '';
                                  FocusManager.instance.primaryFocus?.unfocus();
                                } else {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                setState(() {});
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 26,
                                color: _fieldTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(64),
                          color: Color(0xffffffff),
                          child: InkWell(
                            splashColor: const Color(0xff0f41b4),
                            borderRadius: BorderRadius.circular(64),
                            radius: 22,
                            onTap: () {
                              if (_textEditingController.text.isNotEmpty) {
                                final contact = Contact(
                                    name: _textEditingController.text,
                                    surname: '',
                                    category: selectedCategory.id);
                                setState(() {
                                  contactOperations.createContact(contact);
                                });
                              } else {
                                log('ADD A NAME TO CONTACT');
                              }
                            },
                            child: Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  size: 22,
                                  color: Color(0xff071430),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 6, right: 6),
                  child: Container(
                    width: sidePanelWidth,
                    child: FutureBuilder(
                      future: categoryOperations.getAllCategories(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return Wrap(
                            children: [
                              for (var c in snapshot.data!)
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 4),
                                  child: ChoiceChip(
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: c == selectedCategory
                                                ? const Color(0xff0f41b4)
                                                : const Color(0xff14203a))),
                                    selected: c.name == selectedCategory.name,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedCategory = c;
                                      });
                                    },
                                    selectedColor: const Color(0xff0f41b4),
                                    label:
                                        Text('${c.id} ${c.name.toUpperCase()}',
                                            style: const TextStyle(
                                              color: Color(0xffffffff),
                                            )),
                                    backgroundColor: const Color(0xff202c46),
                                    elevation: 0,
                                  ),
                                ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: ChoiceChip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Colors.white)),
                                  selected: false,
                                  onSelected: (value) {
                                    setState(() {
                                      categoryOperations.createCategory(
                                          Category(name: 'family'));
                                    });
                                  },
                                  selectedColor: const Color(0xffffffff),
                                  label: Icon(
                                    Icons.add,
                                    size: 22,
                                    color: Color(0xff071430),
                                  ),
                                  backgroundColor: const Color(0xffffffff),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text(snapshot.connectionState.toString());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(32, 64, 32, 32),
                color: Color(0xff071430),
                child: ListView(
                  children: [
                    Text(
                      'Contacts',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    FutureBuilder(
                      future: contactOperations.getAllContacts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return Text(
                            snapshot.data.toString(),
                            style: TextStyle(color: Colors.white),
                          );
                        } else {
                          return Text(snapshot.connectionState.toString());
                        }
                      },
                    )
                  ],
                ),
              ))
        ],
      ),
    ));
  }
}

class ContactCircleAvatar extends StatelessWidget {
  final double? _radius;
  final EdgeInsets? _padding;
  final EdgeInsets? _margin;

  const ContactCircleAvatar({
    double? radius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Key? key,
  })  : _radius = radius,
        _padding = padding,
        _margin = margin,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      margin: _margin,
      // margin: const EdgeInsets.only(left: 6, right: 6), // big
      // margin: const EdgeInsets.all(8), // small
      child: CircleAvatar(
        radius: _radius, //big 27, small 25
        backgroundColor: Color.fromARGB(
            ((10 + math.Random().nextInt(100 - 10))).toInt(), 150, 150, 150),
        child: Icon(Icons.person, color: const Color(0xff878787)),
      ),
    );
  }
}
