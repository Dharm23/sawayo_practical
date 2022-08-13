import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '/model/prefrence_utils.dart';
import '../common/constraints.dart';
import '../widgets/sawayo_clipper.dart';
import 'calendar_page.dart';

class AddRequestPage extends StatefulWidget {
  final List arrLeaves;
  const AddRequestPage({
    Key? key,
    required this.arrLeaves,
  }) : super(key: key);

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  //  MediaQueryData
  late MediaQueryData _mediaQuery;

  // Size
  late Size _screenSize;

  // String
  String selectedLeaveType = '';

  //TextEditingController
  final TextEditingController _txtFromDate = TextEditingController();
  final TextEditingController _txtToDate = TextEditingController();

  // DateTime
  DateTime? startDate;
  DateTime? endDate;

  //GlobalKey<FormState>
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _screenSize = _mediaQuery.size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: null,
        backgroundColor: colorBgYellow,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _getHeader(),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets
  Widget _getHeader() {
    return Container(
      margin: EdgeInsets.only(
        top: _mediaQuery.padding.top,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 55,
                    height: 55,
                    color: Colors.transparent,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    "https://randomuser.me/api/portraits/men/62.jpg",
                  ),
                ),
              ),
              const SizedBox(
                width: 55,
                height: 55,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 65),
            child: ClipPath(
              clipper: SawayoClipper(130),
              child: Container(
                width: double.infinity,
                // height: _screenSize.height * 0.85,
                padding: const EdgeInsets.symmetric(
                  vertical: 45,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _getBody(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    Widget vSpace25 = const SizedBox(
      height: 25,
    );
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace25,
              const Text(
                "New Request",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              vSpace25,
              _leaveTypeWidget(),
              vSpace25,
              _getTextFiledButton(
                controller: _txtFromDate,
                hintText: "From",
                onTap: openCalendarView,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Select Start Date";
                  }
                  return null;
                },
              ),
              vSpace25,
              _getTextFiledButton(
                  controller: _txtToDate,
                  hintText: "To",
                  onTap: openCalendarView),
            ],
          ),
          vSpace25,
          GestureDetector(
            onTap: _clickConfirm,
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    colorOrange,
                    colorBgYellow,
                  ],
                  begin: FractionalOffset(1.0, 0.0),
                  end: FractionalOffset(0.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: const Center(
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveTypeWidget() {
    return Container(
      height: 225,
      color: Colors.transparent,
      child: FormField<bool>(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3, // Horizontal Space
                    mainAxisSpacing: 3, // Vertical Space
                    childAspectRatio: 1.5,
                  ),
                  itemCount: arrLeaveType.length,
                  itemBuilder: (itemContext, itemIndex) {
                    Map leaveTypeObj = Map.from(arrLeaveType[itemIndex]);
                    return GestureDetector(
                      onTap: () {
                        if (selectedLeaveType == leaveTypeObj["leave_type"]) {
                          selectedLeaveType = '';
                        } else {
                          selectedLeaveType = leaveTypeObj["leave_type"];
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              (selectedLeaveType == leaveTypeObj["leave_type"])
                                  ? colorSelectedBlack
                                  : Colors.grey[350],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  22.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                leaveTypeObj["icon"],
                              ),
                            ),
                            Text(
                              leaveTypeObj["leave_type"],
                              style: TextStyle(
                                fontSize: 14,
                                color: (selectedLeaveType ==
                                        leaveTypeObj["leave_type"])
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              state.errorText != null
                  ? Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          );
        },
        validator: (val) {
          if (selectedLeaveType.isEmpty) {
            return "Select Leave Type";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _getTextFiledButton({
    required TextEditingController controller,
    required String hintText,
    required Function() onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        label: Text(hintText),
      ),
      onTap: onTap,
      validator: validator,
    );
  }

  void openCalendarView() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => CalendarPage(
          startDate: startDate,
          endDate: endDate,
        ),
      ),
    )
        .then((value) {
      if (value != null) {
        if (value["start_date"].toString().isNotEmpty) {
          startDate = value["start_date"];
          if (startDate != null) {
            _txtFromDate.text = formateDisplay.format(startDate!);
          }
        }

        if (value["end_date"].toString().isNotEmpty) {
          endDate = value["end_date"];
          if (endDate != null) {
            _txtToDate.text = formateDisplay.format(endDate!);
          }
        }

        setState(() {});
      }
    });
  }

  _clickConfirm() async {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      List leaves = List.from(widget.arrLeaves);
      Map leaveObj = {
        "start_date": startDate.toString(),
        "end_date": (endDate != null) ? endDate.toString() : "",
        "day_count": (endDate == null)
            ? 1
            : (endDate!.difference(startDate!).inDays + 1),
        "leave_type": selectedLeaveType,
      };
      leaves.add(leaveObj);
      await PrefrenceUtils.setStringValueWithKey(
          key: keyLeaveList, value: json.encode(leaves));
      if (mounted) Navigator.of(context).pop(leaveObj);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _txtFromDate.dispose();
    _txtToDate.dispose();
  }
}
