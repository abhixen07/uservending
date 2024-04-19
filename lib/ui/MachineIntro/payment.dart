// // import 'package:flutter/material.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// //
// // class QRCodeGenerator extends StatelessWidget {
// //
// //    QRCodeGenerator({
// //     Key? key,
// //     required this.selectedIds,
// //     required this.machineId,
// //    // required this.totalBill,
// //   }) : super(key: key);
// //
// //   final List<String> selectedIds;
// //   final String machineId;
// //  // double totalBill;
// //   @override
// //   Widget build(BuildContext context) {
// //    // String data = 'machineId: $machineId\nselectedIds: ${selectedIds.join(',')}\ntotalBill: $totalBill';
// //
// //     String data = 'machineId: $machineId\nselectedIds: ${selectedIds.join(',')}';
// //    // String data = selectedIds.join(', ');
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('QR'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             QrImageView(
// //               data: data,
// //               version: QrVersions.auto,
// //               gapless: false,
// //               size: 320,
// //             )
// //           ],
// //         )
// //
// //       ),
// //     );
// //   }
// // }
//
//
// /*
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class QRCodeGenerator extends StatelessWidget {
//
//    QRCodeGenerator({
//     Key? key,
//     required this.selectedIds,
//     required this.machineId,
//    // required this.totalBill,
//   }) : super(key: key);
//
//   final List<String> selectedIds;
//   final String machineId;
//  // double totalBill;
//   @override
//   Widget build(BuildContext context) {
//    // String data = 'machineId: $machineId\nselectedIds: ${selectedIds.join(',')}\ntotalBill: $totalBill';
//
//     String data = 'machineId: $machineId\nselectedIds: ${selectedIds.join(',')}';
//    // String data = selectedIds.join(', ');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             QrImageView(
//               data: data,
//               version: QrVersions.auto,
//               gapless: false,
//               size: 320,
//             )
//           ],
//         )
//
//       ),
//     );
//   }
// }
//
//  */
//
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:http/http.dart' as http;
//
// class QRCodeGenerator extends StatefulWidget {
//   QRCodeGenerator({
//     Key? key,
//     required this.selectedIds,
//     required this.machineId,
//   }) : super(key: key);
//
//   final List<String> selectedIds;
//   final String machineId;
//
//   @override
//   _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
// }
//
// class _QRCodeGeneratorState extends State<QRCodeGenerator> {
//   bool qrDecoded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     String data = 'machineId: ${widget.machineId}\nselectedIds: ${widget.selectedIds.join(',')}';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (!qrDecoded)
//               QrImageView(
//                 data: data,
//                 version: QrVersions.auto,
//                 size: 320,
//               ),
//             if (qrDecoded)
//               Text(
//                 'QR Code Decoded!',
//                 style: TextStyle(fontSize: 24),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void handleQRDecoding() async {
//     var response = await http.get(Uri.parse('http://arduino_ip_address/decoded'));
//     if (response.statusCode == 200) {
//       setState(() {
//         qrDecoded = true;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     handleQRDecoding();
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: QRCodeGenerator(selectedIds: ['item1', 'item2'], machineId: 'machine1'),
//   ));
// }