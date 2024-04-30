import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/colors.dart';

class CustomField extends StatefulWidget {
  final String label;
  final bool isPass;
  final IconData icon;
  final TextEditingController controller;
  const CustomField({
    super.key, required this.label, required this.icon, required this.controller,  this.isPass=false,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool obscure=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: widget.isPass?obscure:false,
        validator: (value)=>value!.isEmpty? "required" : null,
        controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon:widget.isPass? IconButton(onPressed: (){
              setState(() {
                obscure=!obscure;
              });
            },icon: const Icon(Iconsax.eye) )
                : const SizedBox(),
              contentPadding: const EdgeInsets.all(16),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kPrimaryColor)
              ),
              labelText:widget.label,
              prefixIcon: Icon(widget.icon),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
              )
          )
      ),
    );
  }
}