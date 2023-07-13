import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';

enum MoonPhase {
  growingMoon,
  fullMoon,
  waningMoon,
  newMoon,
}

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    Key? key,
    required this.pathEkadashi,
    required this.pathFullMoon,
    required this.pathGrowingMoon,
    required this.pathWaningMoon,
    required this.headerLeftArrowButton,
    required this.headerRightArrowButton,
    required this.onPageChanged,
    required this.onHeaderTapped,
    required this.locale,
    required this.initialDate,
  }) : super(key: key);
  final String pathEkadashi;
  final String pathFullMoon;
  final String pathGrowingMoon;
  final String pathWaningMoon;
  final String headerLeftArrowButton;
  final String headerRightArrowButton;
  final Function(DateTime) onPageChanged;
  final Function(DateTime) onHeaderTapped;
  final String locale;
  final DateTime initialDate;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  void initState() {
    selectedDate = widget.initialDate;
    super.initState();
  }

  int calculateLunarDay(
      {required int day, required int month, required int year}) {
    int lunarYear = (year - 2000) + 6; // Вычисляем лунный год
    while (lunarYear > 19) {
      lunarYear = lunarYear - 19;
    }
    //N=(L*11)-14+D+M,
    int lunarDay =
        ((lunarYear * 11) - 14 + day + month) % 30; // Вычисляем лунный день
    return lunarDay;
  }

  MoonPhase getLunarPhase(int lunarDay) {
    if (lunarDay >= 0 && lunarDay < 15) {
      return MoonPhase.growingMoon;
    } else if (lunarDay == 15) {
      return MoonPhase.fullMoon;
    } else {
      return MoonPhase.waningMoon;
    }
  }

  bool getEkadashiDay(DateTime date) {
    int lunarDay =
        calculateLunarDay(day: date.day, month: date.month, year: date.year);
    if (lunarDay == 11 || lunarDay == 26) return true;
    return false;
  }

  String getMoonPhaseSvgPath(DateTime date) {
    int lunarDay =
        calculateLunarDay(day: date.day, month: date.month, year: date.year);
    String moonPhaseSvgPath = '';
    switch (getLunarPhase(lunarDay)) {
      case MoonPhase.growingMoon:
        moonPhaseSvgPath = widget.pathGrowingMoon;
        break;
      case MoonPhase.fullMoon:
        moonPhaseSvgPath = widget.pathFullMoon;
        break;
      case MoonPhase.waningMoon:
        moonPhaseSvgPath = widget.pathWaningMoon;
        break;
      case MoonPhase.newMoon:
        moonPhaseSvgPath = widget.pathEkadashi;
        break;
    }
    return moonPhaseSvgPath;
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDate = day;
    });
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F033A),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TableCalendar(
                currentDay: widget.initialDate,
                locale: widget.locale,
                onPageChanged: widget.onPageChanged,
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                onHeaderTapped: widget.onHeaderTapped,
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date1, date2) {
                    return CalendarDayTile(
                      pathFullMoon: getMoonPhaseSvgPath(date1),
                      pathEkadashi: widget.pathEkadashi,
                      date: date1,
                      ekadashiDay: getEkadashiDay(date1),
                      todayDate: true,
                    );
                  },
                  outsideBuilder: (context, date, _) {
                    return CalendarDayTile(
                      isOutsideDate: true,
                      pathFullMoon: getMoonPhaseSvgPath(date),
                      pathEkadashi: widget.pathEkadashi,
                      date: date,
                      ekadashiDay: getEkadashiDay(date),
                    );
                  },
                  todayBuilder: (context, date, _) {
                    return CalendarDayTile(
                      pathFullMoon: getMoonPhaseSvgPath(date),
                      pathEkadashi: widget.pathEkadashi,
                      date: date,
                      ekadashiDay: getEkadashiDay(date),
                      todayDate: true,
                    );
                  },
                  defaultBuilder: (context, date, _) {
                    return CalendarDayTile(
                      pathFullMoon: getMoonPhaseSvgPath(date),
                      pathEkadashi: widget.pathEkadashi,
                      date: date,
                      ekadashiDay: getEkadashiDay(date),
                    );
                  },
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF2B6FF),
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF2B6FF),
                  ),
                ),
                daysOfWeekHeight: 26,
                calendarStyle: CalendarStyle(
                  tablePadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  outsideTextStyle: const TextStyle(
                    color: Color(0xFF41245C),
                  ),
                  todayTextStyle: const TextStyle(
                    color: Color(0xFF1F033A),
                  ),
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFFF2B6FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                headerStyle: HeaderStyle(
                  headerMargin: const EdgeInsets.only(bottom: 40),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leftChevronIcon:
                      SvgPicture.asset('assets/svg/left_chevron.svg'),
                  rightChevronIcon:
                      SvgPicture.asset('assets/svg/right_chevron.svg'),
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF2B6FF),
                  ),
                ),
                focusedDay: selectedDate,
                firstDay: DateTime.utc(2012, 10, 16),
                lastDay: DateTime.utc(2030, 01, 01),
              ),
            ),
          ],
        ),
        Positioned(
          top: 64,
          left: 20,
          right: 17,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoMoonTile(
                title: 'Растущая луна',
                svgPath: widget.pathGrowingMoon,
              ),
              InfoMoonTile(
                title: 'Полнолуние',
                svgPath: widget.pathFullMoon,
              ),
              InfoMoonTile(
                title: 'Убывающая луна',
                svgPath: widget.pathWaningMoon,
              ),
              InfoMoonTile(
                title: 'Экадеши',
                svgPath: widget.pathEkadashi,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CalendarDayTile extends StatelessWidget {
  const CalendarDayTile({
    super.key,
    required this.pathFullMoon,
    this.pathEkadashi,
    required this.date,
    this.isOutsideDate = false,
    required this.ekadashiDay,
    this.todayDate = false,
  });

  final bool? todayDate;
  final bool? isOutsideDate;

  final DateTime date;
  final String pathFullMoon;
  final String? pathEkadashi;
  final bool ekadashiDay;

  Color getTextColor(bool todayDate, bool isOutsideDate) {
    if (todayDate == true) {
      return const Color(0xFF1F033A);
    }
    if (isOutsideDate == true) {
      return const Color(0xFF41245C);
    }

    return const Color(0xFFFFFFFF);
  }

  Color getBoxBgColor(bool todayDate, bool isOutsideDate) {
    if (todayDate == true) {
      return const Color(0xFFF2B6FF);
    }
    return const Color(0xFF1F033A);
  }

  Color getBorderColor(bool todayDate, bool isOutsideDate) {
    if (todayDate == true) {
      return const Color(0xFFF2B6FF);
    }
    if (isOutsideDate == true) {
      return const Color(0xFF41245C);
    }
    return const Color(0xFF2A084A);
  }

  Color getIconColor(bool todayDate, bool isOutsideDate) {
    if (todayDate == true) {
      return const Color(0xFF1F033A);
    }
    if (isOutsideDate == true) {
      return const Color(0xFF41245C);
    }

    return const Color(0xFFFFF172);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 2, 7.5, 8),
      margin: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: getBoxBgColor(todayDate ?? false, isOutsideDate ?? false),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            width: 1,
            color: getBorderColor(todayDate ?? false, isOutsideDate ?? false)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: getTextColor(todayDate ?? false, isOutsideDate ?? false),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                pathFullMoon,
                width: 10,
                height: 10,
                color: getIconColor(todayDate ?? false, isOutsideDate ?? false),
              ),
              const SizedBox(
                width: 3,
              ),
              if (pathEkadashi != null && ekadashiDay == true)
                SvgPicture.asset(
                  pathEkadashi!,
                  width: 10,
                  height: 10,
                  color: todayDate == true ? const Color(0xFF1F033A) : null,
                )
            ],
          )
        ],
      ),
    );
  }
}

class InfoMoonTile extends StatelessWidget {
  const InfoMoonTile({Key? key, required this.title, required this.svgPath})
      : super(key: key);
  final String title;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          svgPath,
          height: 10,
          width: 10,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
