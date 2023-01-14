import 'dart:developer';

import 'package:guide_sqflite/database/category_operations.dart';
import 'package:guide_sqflite/database/database.dart';

class ContactOperations {
  ContactOperations? contactOperations;

  final dbProvider = DatabaseRepository.instance;

  createContact(Contact contact) async {
    final db = await dbProvider.database;
    db.insert('contact', contact.toMap());
    log('contact inserted');
  }

  updateContact(Contact contact) async {
    final db = await dbProvider.database;
    db.update('contact', contact.toMap(),
        where: "contactId=?", whereArgs: [contact.id]);
  }

  deleteContact(Contact contact) async {
    final db = await dbProvider.database;
    await db.delete('contact', where: 'contactId=?', whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('contact');
    List<Contact> contacts =
        allRows.map((contact) => Contact.fromMap(contact)).toList();
    return contacts;
  }

  Future<List<Contact>> getAllContactsByCategory(Category category) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.rawQuery('''
    SELECT * FROM contact 
    WHERE contact.FK_contact_category = ${category.id}
    ''');
    List<Contact> contacts =
        allRows.map((contact) => Contact.fromMap(contact)).toList();
    return contacts;
  }

  Future<List<Contact>> searchContacts(String keyword) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('contact',
        where: 'contactName LIKE ?', whereArgs: ['%$keyword%']);
    List<Contact> contacts =
        allRows.map((contact) => Contact.fromMap(contact)).toList();
    return contacts;
  }
}

//WHERE name LIKE 'keyword%'
//--Finds any values that start with "keyword"
//WHERE name LIKE '%keyword'
//--Finds any values that end with "keyword"
//WHERE name LIKE '%keyword%'
//--Finds any values that have "keyword" in any position

class Contact {
   int? id;
  late String name;
  late String surname;
  late int? category;

  Contact({
    this.id,
    required this.name,
    required this.surname,
    required this.category,
  });

  Contact.fromMap(dynamic obj) {
    id = obj['contactId'];
    name = obj['contactName'];
    surname = obj['contactSurname'];
    category = obj['FK_contact_category'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'contactName': name,
      'contactSurname': surname,
      'FK_contact_category': category,
    };

    return map;
  }
}
