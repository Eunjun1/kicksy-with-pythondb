// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:kicksy/vm/database_handler.dart';
// import 'package:http/http.dart'as http;

// class HqRequestManagement extends StatefulWidget {
//   const HqRequestManagement({super.key});

//   @override
//   State<HqRequestManagement> createState() => _HqRequestManagementState();
// }

// class _HqRequestManagementState extends State<HqRequestManagement> {
//   List managementList = [];
//   List requestList = [];
//   List storeList = [];

//   DatabaseHandler handler = DatabaseHandler();


//   @override
//   void initState() {
//     super.initState();
//     getJSONDataMag(); 
//     getJSONDataReq();
//     getJSONDataStore();
//   }

//   // '''  from management as mag
//   //     join request as req on req.store_code = mag.store_code
//   //     join store as str on str.str_code = mag.store_code
//   //     '''
//   getJSONDataMag()async{
//     var responseMag = await http.get(
//       Uri.parse('http://127.0.0.1:8000/management/'),
//     );
//     managementList.clear();
//     managementList.addAll(
//       json.decode(utf8.decode(responseMag.bodyBytes))['results'],
//     );
//     setState(() {});
//     print(managementList);
//   }


//   getJSONDataReq()async{
//     var responseReq = await http.get(
//       Uri.parse('http://127.0.0.1:8000/request'),
//     );
//     requestList.clear();
//     requestList.addAll(
//       json.decode(utf8.decode(responseReq.bodyBytes))['results'],
//     );
//     setState(() {});
//     print(requestList);
//   }


//   getJSONDataStore()async{
//     var responseStore = await http.get(
//       Uri.parse('http://127.0.0.1:8000/store'),
//     );
//     storeList.clear();
//     storeList.addAll(
//       json.decode(utf8.decode(responseStore.bodyBytes))['results'],
//     );
//     setState(() {});
//     print(storeList);
//   }
  
  


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
      
//       body: 
//       managementList.isEmpty && requestList.isEmpty && storeList.isEmpty
//       ? Center(child: CircularProgressIndicator())
//       :
//       Center(
//         child: 
//               ListView.builder(
//                 itemCount: managementList.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: Column(
//                       children: [
//                       Text(
//                         'data'
//                       )
//                     ],
//                   ),
//                 );
//               },
//           ),
//       ),
//     );
//   }
// }