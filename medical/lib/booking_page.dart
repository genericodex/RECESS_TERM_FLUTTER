import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusDay,
            calendarFormat: _format,
            selectedDayPredicate: (day) => isSameDay(_currentDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _currentDay = selectedDay;
                _focusDay = focusedDay;
                _dateSelected = true;
                _isWeekend = selectedDay.weekday == DateTime.saturday ||
                    selectedDay.weekday == DateTime.sunday;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _format = format;
              });
            },
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (_dateSelected) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Center(
                child: Text(
                  'Selected Consultation Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _isWeekend
                ? SliverToBoxAdapter(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      alignment: Alignment.center,
                      child: Text(
                        'Weekend is not available, please select another date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {},
                        child:Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                ?Colors.white
                                :Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index
                              ?Colors.green
                              :null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index +9}:00 ${index +9 > 11 ? "PM" :"AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _currentIndex == index ?Colors.white :null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 8,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,
                      childAspectRatio: 1.5,),
                    ),
          ],
        ],
      ),
      bottomNavigationBar: _dateSelected && _timeSelected
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement booking logic here
                  },
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
