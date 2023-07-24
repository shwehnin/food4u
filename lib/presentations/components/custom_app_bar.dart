import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {

  const CustomAppBar({ Key? key , required this.title, this.leading, this.action, this.titleColor}) : super(key: key);

  final String title;
  final Widget? leading;
  final List<Widget>? action;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading!=null ?
        SizedBox(
          height: 40,
          width: 40,
          child: leading,
        ) : Container(),
        leading!=null ? SizedBox(width: 20,): Container(),
        Container(
          width: _getTitleWidth(context),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),)),
        Spacer(),
        Row(children: action!,)
        
      ],
    );
  }

  _getTitleWidth(context){
    if(action?.length == 1){
      return MediaQuery.of(context).size.width * 0.6;
    }else if(action?.length == 2){
      return MediaQuery.of(context).size.width * 0.5;
    }else{
      return MediaQuery.of(context).size.width - 100;
    }
  }
}