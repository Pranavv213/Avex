// import 'dart:convert';
// import 'dart:developer';

// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
// import 'package:test_project/getTokens.dart';
// import 'package:http/http.dart' as http;

// import 'constants.dart';

// class TestScreen extends StatefulWidget {
//   const TestScreen({super.key});

//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }

// var httpClient = http.Client();
// final searchController = TextEditingController();

// class _TestScreenState extends State<TestScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Padding(
//         padding: const EdgeInsets.all(28.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             CustomDropdown.searchRequest(
//                 // canCloseOutsideBounds: true,
//                 // fillColor: Colors.blue,
//                 hintText: "Search",
//                 controller: searchController,
//                 listItemStyle: TextStyle(
//                   color: Colors.red,
//                 ),
//                 hintStyle: TextStyle(color: Colors.blue),
//                 futureRequest: search),
//             TextField(
//               controller: searchController,
//               onChanged: (value) {
//                 if (value != null) {
//                   // log(search(value));
//                   search(value);
//                 }
//               },
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   Constants().simluate();
//                 },
//                 child: Text("Simulate"))
//           ],
//         ),
//       )),
//     );
//   }

//   Future<List<String>> search(String text) async {
//     var search = await Constants().index.search(text);
//     var results = search.hits;
//     List<String> names = [];

//     results?.forEach((element) {
//       var name = element['name'];
//       names.add(name.toString());
//     });
//     log(names.toString());
//     return names;
//   }
// }
