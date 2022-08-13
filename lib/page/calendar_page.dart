import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../common/constraints.dart';
import '../widgets/sawayo_clipper.dart';

class CalendarPage extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const CalendarPage({
    Key? key,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //  MediaQueryData
  late MediaQueryData _mediaQuery;

  // Size
  late Size _screenSize;

  // DateTime
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
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
                height: _screenSize.height * 0.85,
                padding: const EdgeInsets.symmetric(
                  vertical: 45,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _calendarWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarWidget() {
    Widget vSpace25 = const SizedBox(
      height: 25,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
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
            SizedBox(
              height: _screenSize.height * 0.50,
              child: SfDateRangePicker(
                enablePastDates: false,
                navigationDirection:
                    DateRangePickerNavigationDirection.vertical,
                navigationMode: DateRangePickerNavigationMode.scroll,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    startDate = args.value.startDate;
                    endDate = args.value.endDate;
                  }
                },
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                  startDate,
                  endDate,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop({
              "start_date": startDate ?? "",
              "end_date": endDate ?? "",
            });
          },
          child: Container(
            width: _screenSize.width * 0.50,
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
                "Select",
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
