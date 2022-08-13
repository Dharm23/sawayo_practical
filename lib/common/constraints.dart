import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Strings
const String appTitle = "Sawayo";

// Colors
const Color colorBgYellow = Color.fromRGBO(247, 206, 90, 1);
const Color colorSelectedBlack = Color.fromRGBO(52, 47, 44, 1);
const Color colorOrange = Color.fromRGBO(254, 131, 27, 1);

// Icons
const String iconSpecial = 'assets/images/icon_special.svg';
const String iconUnpaid = 'assets/images/icon_unpaid.svg';
const String iconParential = 'assets/images/icon_parential.svg';
const String iconAnnual = 'assets/images/icon_annual.svg';

// DateFormat
final DateFormat formateDisplay = DateFormat('dd-MM-yyyy');
final DateFormat formateOriginal = DateFormat('yyyy-MM-dd');

// List
List<Map<String, dynamic>> arrLeaveType = [
  {
    "leave_type": "Annual",
    "icon": iconAnnual,
  },
  {
    "leave_type": "Parential",
    "icon": iconParential,
  },
  {
    "leave_type": "Unpaid",
    "icon": iconUnpaid,
  },
  {
    "leave_type": "Special",
    "icon": iconSpecial,
  },
];
