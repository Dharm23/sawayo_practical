import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiver/time.dart';
import 'package:sawayo_practical/model/prefrence_utils.dart';
import '/common/constraints.dart';
import 'add_request_page.dart';
import '/widgets/sawayo_clipper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MediaQueryData
  late MediaQueryData _mediaQuery;

  // List
  List arrLeaves = [];

  // int
  int usedDay = 0;
  int allDay = 30;
  int availableDay = 30;

  @override
  void initState() {
    allDay = daysInMonth(DateTime.now().year, DateTime.now().month);
    super.initState();
    PrefrenceUtils.getStringValueFromKey(key: keyLeaveList).then((value) {
      if (value != null && value.isNotEmpty) {
        List leaves = jsonDecode(value);
        arrLeaves.clear();
        arrLeaves.addAll(leaves);
        _calculateDays();
        setState(() {});
      }
    });
  }

  _calculateDays() {
    var sum = arrLeaves.fold(0, (int i, el) {
      return i + int.parse(el['day_count'].toString());
    });
    usedDay = sum;
    availableDay = allDay - sum;
    if (availableDay < 0) {
      availableDay = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: null,
      backgroundColor: colorBgYellow,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            _getHeader(),
            _getBody(),
          ],
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 65),
            child: ClipPath(
              clipper: SawayoClipper(130),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 45,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                // height: _screenSize.height * 0.20,
                child: _headerInfoWidget(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  "https://randomuser.me/api/portraits/men/62.jpg",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerInfoWidget() {
    Widget vSpace10 = const SizedBox(
      height: 10,
    );

    Widget hDivider = Container(
      width: 1,
      color: Colors.grey[200],
      height: 50,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dorothy Boone",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "PHP Developer",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _clickAddLeave,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(27.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          vSpace10,
          const Divider(),
          vSpace10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _getLeaveInfoCell("Available", "$availableDay"),
              hDivider,
              _getLeaveInfoCell("All", "$allDay"),
              hDivider,
              _getLeaveInfoCell("Used", "$usedDay"),
            ],
          )
        ],
      ),
    );
  }

  _clickAddLeave() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => AddRequestPage(arrLeaves: arrLeaves),
      ),
    )
        .then(
      (value) {
        if (value != null && value is Map) {
          arrLeaves.add(value);
          _calculateDays();
          setState(() {});
        }
      },
    );
  }

  Widget _getLeaveInfoCell(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "$value Days",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _getBody() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 25,
        ),
        child: ListView.builder(
          itemCount: arrLeaves.length,
          padding: EdgeInsets.zero,
          itemBuilder: (itemContext, itemIndex) {
            return _leaveCell(itemIndex);
          },
        ),
      ),
    );
  }

  Widget _leaveCell(index) {
    Map leaveObject = Map.from(arrLeaves[index]);
    print(leaveObject);
    String leaveIcon = "";
    List leaveTypeObj = arrLeaveType.where(
      (element) {
        return (element["leave_type"] == leaveObject["leave_type"]);
      },
    ).toList();
    if (leaveTypeObj.isNotEmpty) {
      leaveIcon = leaveTypeObj.first["icon"];
    }

    DateTime startDate = formateOriginal.parse(leaveObject["start_date"]);
    DateTime? endDate = (leaveObject["end_date"].toString().isEmpty)
        ? null
        : formateOriginal.parse(leaveObject["end_date"]);

    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(
          8,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: colorSelectedBlack,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    child: (leaveIcon.isEmpty)
                        ? null
                        : SvgPicture.asset(
                            leaveIcon,
                          ),
                  ),
                  Text(
                    leaveObject["leave_type"],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Start Date : ${formateDisplay.format(startDate)}",
                ),
                Text(
                  (endDate != null)
                      ? "End Date : ${formateDisplay.format(endDate)}"
                      : "",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
