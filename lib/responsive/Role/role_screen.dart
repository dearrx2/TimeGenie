import 'package:flutter/material.dart';
import 'package:untitled/responsive/Role/role_screen_mobile.dart';
import 'package:untitled/responsive/Role/role_screen_web.dart';

import '../responsive_layout.dart';

class SelectRole extends StatefulWidget {
  final String image;
  final String name;
  final String email;
  final String phone;
  final String code;
  final String password;
  const SelectRole({
    Key? key,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.code,
    required this.password,
  }) : super(key: key);

  @override
  _SelectRolePageState createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SelectRoleMobile(
            image: widget.image,
            name: widget.name,
            email: widget.email,
            phone: widget.phone,
            code: widget.code,
            password: widget.password),
        desktopBody: SelectRoleWeb(
            image: widget.image,
            name: widget.name,
            email: widget.email,
            phone: widget.phone,
            code: widget.code,
            password: widget.password),
      ),
    );
  }
}
