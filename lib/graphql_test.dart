// import 'package:flutter/material.dart';
// // import 'package:graphql_flutter/graphql_flutter.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   @override
//   Widget build(BuildContext context) {
//     final String query = """""";
//     return Scaffold(
//       body: Query(
//         options: QueryOptions(
//           document: gql(query),
//           variables: {
//             'nRepositories': 50,
//           },
//           pollInterval: const Duration(seconds: 10),
//         ),
//         builder: (result, {fetchMore, refetch}) {
//           if (result.isLoading) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (result.data == null) return Text("No Data Found");
//           return ListView.builder(
//               itemCount: result.data?['continent']['countries'].length,
//               itemBuilder: ((context, index) {
//                 return ListTile(
//                   title: Text(
//                       result.data?['continent']['countries'][index]['name']),
//                 );
//               }));
//         },
//       ),
//     );
//   }
// }
