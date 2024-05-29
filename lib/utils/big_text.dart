import 'package:flutter/cupertino.dart';
import 'package:untitled/utils/style.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  BigText({Key? key, this.color = const Color(0xFF595959), required this.text, this.size = 24, this.overflow = TextOverflow.ellipsis}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size
      ),
    );
  }
}
