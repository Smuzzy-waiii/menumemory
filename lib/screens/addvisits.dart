import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menumemory/models/order.dart';
import 'package:menumemory/models/restaurant.dart';

import '../models/dish.dart';

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Restaurant restaurant = Restaurant(
    id: "05b729d0-74de-11ef-920e-76e1daf4cd58",
    name: "Chaatimes",
    area: "Basavanagudi",
    address:
    "39, 3rd Main,4th Cross, Hanumanth Nagar, Near, Basavanagudi, Bangalore",
  );

  DateTime? visitDateTime;
  final List<VisitOrder> orders = [];
  final TextEditingController _dishController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  double? _rating;

  Future<void> _saveVisit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _firestore.collection('users/${FirebaseAuth.instance.currentUser!.uid}/visits').add({
          'restaurant_id': restaurant.id,
          'restaurant_info': restaurant.toMap(),
          'datetime': visitDateTime,
          'order': orders.map((o) => o.toMap()).toList(),
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Visit added successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add visit: $e')));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: visitDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        visitDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          visitDateTime?.hour ?? 0,
          visitDateTime?.minute ?? 0,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: visitDateTime != null
          ? TimeOfDay(hour: visitDateTime!.hour, minute: visitDateTime!.minute)
          : TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        visitDateTime = DateTime(
          visitDateTime?.year ?? DateTime.now().year,
          visitDateTime?.month ?? DateTime.now().month,
          visitDateTime?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _addDish() {
    if (_dishController.text.isNotEmpty && _rating != null) {
      setState(() {
        orders.add(
          VisitOrder(
            dish: Dish(id: "foo", name: _dishController.text),
            rating: _rating!,
            review_text: _reviewController.text,
          ),
        );
        _dishController.clear();
        _reviewController.clear();
        _rating = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Visit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      restaurant.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${restaurant.area}\n${restaurant.address}'),
                    isThreeLine: true,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () => _selectDate(context),
                        controller: TextEditingController(
                          text: visitDateTime != null
                              ? "${visitDateTime!.toLocal()}".split(' ')[0]
                              : '',
                        ),
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () => _selectTime(context),
                        controller: TextEditingController(
                          text: visitDateTime != null
                              ? TimeOfDay(
                              hour: visitDateTime!.hour,
                              minute: visitDateTime!.minute)
                              .format(context)
                              : '',
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(thickness: 2),
                SizedBox(height: 20),
                TextFormField(
                  controller: _dishController,
                  decoration: InputDecoration(
                    labelText: 'Dish Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Rate the Dish: ${_rating != null ? _rating!.toStringAsFixed(1) : 'Not rated'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _rating ?? 0,
                  min: 0,
                  max: 5,
                  divisions: 50,
                  label: _rating?.toStringAsFixed(1) ?? 'Not rated',
                  onChanged: (value) {
                    setState(() {
                      _rating = double.parse(value.toStringAsFixed(1));
                    });
                  },
                ),
                TextFormField(
                  controller: _reviewController,
                  decoration: InputDecoration(
                    labelText: 'Review',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _addDish,
                  icon: Icon(Icons.add),
                  label: Text('Add Dish'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                SizedBox(height: 10),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Text('Dishes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                ...orders.map(
                      (order) => ListTile(
                    leading: Icon(Icons.restaurant, color: Colors.blueAccent),
                    title: Text(order.dish.name),
                    subtitle: Text(
                      'Rating: ${order.rating}, Review: ${order.review_text}',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveVisit,
                    icon: Icon(Icons.save),
                    label: Text('Save Visit'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      textStyle: TextStyle(fontSize: 18),
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
}
