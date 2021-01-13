import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberAir/view_model/calendar_view_model.dart';
import 'package:uberAir/view_model/passenger_list_view_model.dart';
import 'package:uberAir/view_model/search_view_model.dart';
import 'package:uberAir/widget/flights_screen.dart';
import 'departure_calendar.dart';
import 'my_app_bar_widget.dart';
import 'return_caledar.dart';
import 'open_passenger_list_widget.dart';
import 'search_airports_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberAir/widget/return_caledar.dart';

class MyFlightInfoField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Container(
      padding: EdgeInsets.all(20),
      child: Expanded(
        child: Column(
          children: [
            MyAppBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartureCalendar()));
                  },
                  child: Text("Departure",
                      style: TextStyle(color: Colors.amberAccent)),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReturnCalendar()));
                  },
                  child: Text("Return",
                      style: TextStyle(color: Colors.amberAccent)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DepartureCalendar()));
                }, child: Consumer<CalendarViewModel>(
                    builder: (context, item, child) {
                  String departureDate = item.selectedDeparuteDate.toString();
                  _setDepartureDate(departureDate);
                  return Text(
                    item.selectedDeparuteDate != null
                        ? departureDate.substring(0, 10)
                        : "Select date",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  );
                })),
                Icon(Icons.calendar_today, color: Colors.amberAccent),
                FlatButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReturnCalendar()));
                }, child: Consumer<CalendarViewModel>(
                    builder: (context, item, child) {
                  String returnDate = item.selectedReturnDate.toString();
                  _setReturnDate(returnDate);
                  return Text(
                    item.selectedReturnDate != null
                        ? returnDate.substring(0, 10)
                        : "Select date",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  );
                })),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.amberAccent,
                  )),
                  Text("         "),
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.amberAccent,
                  )),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    showSearch(context: context, delegate: SearchAirports());
                  },
                  child: Text(
                    "From",
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showSearch(context: context, delegate: SearchAirports());
                  },
                  child:
                      Text("To", style: TextStyle(color: Colors.amberAccent)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<SearchViewModel>(builder: (context, item, child) {
                  return FlatButton(
                    onPressed: () {
                      item.searchNPrintResultInbound(
                        context,
                      );
                    },
                    child: FutureBuilder<String>(
                      future: _getInboundAirport(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return Text(
                          snapshot.data != null
                              ? snapshot.data
                              : "Select Airport",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                        );
                      },
                    ),
                  );
                }),
                Icon(
                  Icons.flight,
                  color: Colors.amberAccent,
                ),
                Consumer<SearchViewModel>(builder: (context, item, child) {
                  return FlatButton(
                    onPressed: () {
                      item.searchNPrintResultOutbound(
                        context,
                      );
                    },
                    child: FutureBuilder<String>(
                      future: _getOutboundAirport(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return Text(
                          snapshot.data != null
                              ? "${snapshot.data} "
                              : "Select Airport",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                        );
                      },
                    ),
                  );
                })
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.amberAccent,
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenPassengerList(),
                    ),
                  );
                },
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child:
                        Icon(Icons.person, size: 40, color: Colors.amberAccent),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "\nSelect Passenger            ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 200,
                              child: Consumer<ItemViewModel>(
                                  builder: (context, item, child) {
                                return FutureBuilder(
                                    future: item.readPassengerValue(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return snapshot.data.length == null
                                          ? Text("Select Passenger")
                                          : ListView.separated(
                                              addAutomaticKeepAlives: false,
                                              itemCount: snapshot.data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String key = snapshot.data.keys
                                                    .elementAt(index);
                                                return Text(
                                                  "${snapshot.data[key]} $key ",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      Divider(
                                                color: Colors.amberAccent,
                                                thickness: 1,
                                              ),
                                            );
                                    });
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            TextButton(
              child: Text(
                'SEARCH',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FligthScreen()));
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<String> _getInboundAirport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("inboundCity");
  }

  Future<String> _getOutboundAirport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("outboundCity");
  }

  void _setDepartureDate(String departureDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("inboundDate", departureDate);
    print("inboundDate spye eklendi");
  }

  void _setReturnDate(String returnDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("outboundDate", returnDate);
    print("outboundDate spye eklendi");
  }
}