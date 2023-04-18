import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({required this.title, required this.onClick, super.key});
  final Function onClick;
  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: Color(0xFF2C83A0),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () => {onClick()},
      child: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.bold),
      ),
    );
  }
}
