import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/card_replacement_bloc.dart';
import '../bloc/card_replacement_event.dart';
import '../bloc/card_replacement_state.dart';

class AcknowledgmentScreen extends StatelessWidget {
 const AcknowledgmentScreen({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(
       backgroundColor: Colors.white,
       elevation: 0,
       leading: IconButton(
         onPressed: () => Navigator.pop(context),
         icon: const Icon(Icons.arrow_back, color: Colors.black),
       ),
       title: const Text(
         'Request a Replacement Card',
         style: TextStyle(
           color: Colors.black,
           fontSize: 18,
           fontWeight: FontWeight.w600,
         ),
       ),
       centerTitle: true,
     ),
     body: BlocListener<CardReplacementBloc, CardReplacementState>(
       listener: (context, state) {
         if (state.status == CardReplacementStatus.success) {
           Navigator.pop(context); // Go back to card replacement form
         } else if (state.status == CardReplacementStatus.initial) {
           Navigator.pop(context); // User canceled
         }
       },
       child: Padding(
         padding: const EdgeInsets.all(20),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Expanded(
               child: SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const SizedBox(height: 20),
                     
                     // Main content
                     const Text(
                       'This request will be reviewed to confirm replacement request meets eligible criteria, please note that a Call Center Agent may call at the number you provided to discuss or confirm information.',
                       style: TextStyle(
                         fontSize: 16,
                         color: Colors.black87,
                         height: 1.5,
                       ),
                     ),
                     
                     const SizedBox(height: 24),
                     
                     const Text(
                       'The replacement card will be available to activate online via CVS OTCHS portal within 24-48 business hours. Once activated, you\'re able to shop on-line at CVS via this portal. Your physical card should arrive via USPS mail in 7 - 10 days.',
                       style: TextStyle(
                         fontSize: 16,
                         color: Colors.black87,
                         height: 1.5,
                       ),
                     ),
                     
                     const SizedBox(height: 32),
                     
                     // Warning section
                     Container(
                       width: double.infinity,
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         color: const Color(0xFFFFF3CD),
                         border: Border.all(color: const Color(0xFFFFE69C)),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Text(
                             'WARNING:',
                             style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                               color: Color(0xFF856404),
                             ),
                           ),
                           const SizedBox(height: 8),
                           const Text(
                             'If a replacement card is confirmed and ordered, your current card will be closed/cancelled and can no longer be activated or used',
                             style: TextStyle(
                               fontSize: 16,
                               color: Color(0xFF856404),
                               height: 1.4,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             
             // Bottom buttons
             Column(
               children: [
                 Row(
                   children: [
                     Expanded(
                       child: OutlinedButton(
                         onPressed: () {
                           context.read<CardReplacementBloc>().add(
                             const CancelAcknowledgmentEvent(),
                           );
                         },
                         style: OutlinedButton.styleFrom(
                           side: const BorderSide(color: Color(0xFF007BFF)),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8),
                           ),
                           padding: const EdgeInsets.symmetric(vertical: 16),
                         ),
                         child: const Text(
                           'Cancel',
                           style: TextStyle(
                             color: Color(0xFF007BFF),
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(width: 16),
                     Expanded(
                       flex: 2,
                       child: BlocBuilder<CardReplacementBloc, CardReplacementState>(
                         builder: (context, state) {
                           return ElevatedButton(
                             onPressed: state.status == CardReplacementStatus.submitting 
                                 ? null 
                                 : () {
                                     context.read<CardReplacementBloc>().add(
                                       const ConfirmAcknowledgmentEvent(),
                                     );
                                   },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFF007BFF),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               padding: const EdgeInsets.symmetric(vertical: 16),
                               elevation: 0,
                             ),
                             child: state.status == CardReplacementStatus.submitting
                                 ? const SizedBox(
                                     height: 20,
                                     width: 20,
                                     child: CircularProgressIndicator(
                                       strokeWidth: 2,
                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                     ),
                                   )
                                 : const Text(
                                     'I Acknowledge',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 16,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                           );
                         },
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 16),
                 const Text(
                   '2024 CVS Health',
                   style: TextStyle(
                     fontSize: 12,
                     color: Colors.grey,
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
     ),
   );
 }
}
