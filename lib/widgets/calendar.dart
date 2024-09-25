import 'dart:convert';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/calendar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  Calendar(this.prefs,{super.key});
  SharedPreferences prefs;
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>> events = {};
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay pickedTime = TimeOfDay.now();


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForday(_selectedDay!));
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (newTime != null) {
      setState(() {
        pickedTime = newTime;
      });
    }
  }    

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForday(DateTime day) {
      return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents.value = _getEventsForday(selectedDay);
      });
      
    }
  }
  
  final _locationController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  void clearController() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child:Column(
        children: [
          SizedBox(
            height: 235,
            child: TableCalendar(
              focusedDay: _focusedDay, 
              firstDay: DateTime.utc(2000, 12, 31),
              lastDay: DateTime.utc(2030, 01, 01),
              rowHeight: 35,
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false
              ),
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary
                )
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForday,
              onDaySelected: _onDaySelected,
              rangeSelectionMode: _rangeSelectionMode,
              onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
              },
            ),
          ),
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(flex: 3,),
              const Text("Events", textScaler: TextScaler.linear(1.4),), 
              const Spacer(flex: 2,),
              TextButton(
                onPressed:  (){
                  showDialog(
                    context: context, builder: (BuildContext context) {
                      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                        return AlertDialog.adaptive(
                          scrollable: true,
                          title: const Text('New Event'),
                          content: Padding(
                            padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(helperText: 'Title'),
                                  ),
                                  Row(
                                    children: [
                                      const Text("Time:"),
                                      TextButton(
                                        onPressed: () async {
                                          final TimeOfDay? newTime = await showTimePicker(
                                            context: context,
                                            initialTime: pickedTime,
                                          );
                                          if (newTime != null) {
                                            setState(() {
                                              pickedTime = newTime;
                                            });
                                          }    
                                        }, 
                                        child: Text(pickedTime.format(context))
                                      ),
                                    ],
                                  ),
                                  TextField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(helperText: 'Location'),
                                  ),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(helperText: 'Description'),
                                  ),
                                ],
                              ),
                            ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                events.addAll({
                                  _selectedDay!: [
                                    ..._selectedEvents.value,
                                    Event(
                                      location: _locationController.text,
                                      starttime: pickedTime,
                                      date: _selectedDay.toString(),
                                      title: _titleController.text,
                                      description: _descriptionController.text
                                    )
                                  ]
                                });
                                _selectedEvents.value = _getEventsForday(_selectedDay!);
                                clearController();
                                Navigator.pop(context);
                              },
                              child: const Text('Submit')
                            )
                          ],
                        );
                      });
                    }
                  );
                },
                child: const Icon(Icons.add)
              )
            ],
          ),
          SizedBox(
            height: 200,
            child: ValueListenableBuilder(valueListenable: _selectedEvents, builder: (context, value,_){
              return ListView.builder(itemCount: value.length, itemBuilder: (context, index){
                var _grabDate = DateTime.parse(value[index].date!.toString().split(' ')[0]);
                String month = formatDate(_grabDate, [M]);
                String eventDay = formatDate(_grabDate, [d]);
                if (value.isNotEmpty){
                  return SizedBox(
                    height: 65,
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(month, textScaler: const TextScaler.linear(1.5)),
                            Text(' $eventDay', textScaler: const TextScaler.linear(1.4)),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(right: 15)),
                        VerticalDivider(
                          indent: 4,
                          endIndent: 4,
                          width: 2, 
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Padding(
                          padding: const EdgeInsets.only( left: 10, right: 10),
                          child: SizedBox(
                            width: 335,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        value[index].title, 
                                        textScaler: const TextScaler.linear(1.2), 
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text('${value[index].starttime?.format(context)}  -  8:45 PM',overflow: TextOverflow.ellipsis,),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(value[index].description),
                                )
                              ],
                            )
                          ) 
                        ),
                      ],
                    ) 
                  );
                } else {
                  return  const Center(
                    child:Text("No Events")
                  );
                }
              });
            }),
          )
        ]
      )
    );
  }
}