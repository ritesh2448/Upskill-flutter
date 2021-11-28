import 'package:blog_app/widgets/constants/constants.dart';
import 'package:flutter/material.dart';


class CustomizedWidget extends StatelessWidget {
  final Widget child;

  const CustomizedWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.green,
          style: BorderStyle.solid,
          width: 2,),
        color: Colors.black,
        
      ),
      child: child,
    );
  }
}
