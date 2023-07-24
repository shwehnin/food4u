import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

getOrderSlotDay(int count, double time) {
  DateTime _startDate = DateTime.now();
  if (time > 12.0) {
    _startDate = DateTime.now();
  } else if (time >= 24.0) {
    _startDate = DateTime.now().add(Duration(days: 1));
  } else {
    _startDate = DateTime.now();
  }

  DateTime _calcDate = _startDate.add(Duration(days: count));
  //String _day = DateFormat('E').format(_calcDate);
  //String _month = DateFormat('MMM').format(_calcDate);

  return DateFormat("yyyy-MM-dd").format(_calcDate);
}

/*
getOrderSlotTime(int index, int startHour){
  DateTime _calcDate = DateTime.now();
  DateTime _initialDate = DateTime(_calcDate.year, _calcDate.month, _calcDate.day, startHour).add(Duration(minutes: (index - 1) * 15));
  String _time = DateFormat('jm').format(_initialDate);

  if(index == 0 && _calcDate.hour >8 && _calcDate.hour < 18){
    return 'Now';
  }else{
    return '$_time';
  }
}*/

getPhoneNumberFormat(String number) {
  if (int.parse(number[0].toString()) == 0) {
    return number.replaceFirst('0', '');
  } else {
    return number;
  }
}

getPhoneNumberWithCountryCodeFormat(String number) {
  if (int.parse(number[0].toString()) == 0) {
    number = number.replaceFirst('0', '');
  }
  return '+95$number';
}

void launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}
