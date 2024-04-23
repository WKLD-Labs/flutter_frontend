import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month - 1, 1);
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  '${_currentMonth.month}/${_currentMonth.year}',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month + 1, 1);
                    });
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: _daysInMonth(_currentMonth),
              itemBuilder: (context, index) {
                final dayOfMonth = index - _firstDayOfMonth(_currentMonth) + 1;
                final day = DateTime(_currentMonth.year, _currentMonth.month, dayOfMonth);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = day;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _isSelectedDay(day) ? Colors.blue : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$dayOfMonth',
                      style: TextStyle(
                        color: _isCurrentMonth(day) ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan fungsi untuk menambahkan data di sini
        },
        tooltip: 'Add Data',
        child: Icon(Icons.add),
      ),
      endDrawer: NavDrawer(context),
    );
  }

  bool _isCurrentMonth(DateTime day) {
    return day.month == _currentMonth.month;
  }

  bool _isSelectedDay(DateTime day) {
    return day.year == _selectedDate.year &&
        day.month == _selectedDate.month &&
        day.day == _selectedDate.day;
  }

  int _firstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month, 1).weekday % 7;
  }

  int _daysInMonth(DateTime month) {
    final nextMonth = month.month < 12 ? month.month + 1 : 1;
    final nextYear = nextMonth == 1 ? month.year + 1 : month.year;
    return DateTime(nextYear, nextMonth, 0).day + _firstDayOfMonth(month);
  }
}
