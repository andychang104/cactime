//import 'package:flutter/material.dart';
//
//
//class _MyDialog extends StatefulWidget {
//  _MyDialog({
//    this.cities,
//    this.selectedCities,
//    this.onSelectedCitiesListChanged,
//  });
//
//  final List<String> cities;
//  final List<String> selectedCities;
//  final ValueChanged<List<String>> onSelectedCitiesListChanged;
//
//  @override
//  _MyDialogState createState() => _MyDialogState();
//}
//
//class _MyDialogState extends State<_MyDialog> {
//  List<String> _tempSelectedCities = [];
//
//  @override
//  void initState() {
//    _tempSelectedCities = widget.selectedCities;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Dialog(
//      child: Column(
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text(
//                'CITIES',
//                style: TextStyle(fontSize: 18.0, color: Colors.black),
//                textAlign: TextAlign.center,
//              ),
//              RaisedButton(
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                color: Color(0xFFfab82b),
//                child: Text(
//                  'Done',
//                  style: TextStyle(color: Colors.white),
//                ),
//              ),
//            ],
//          ),
//          Expanded(
//            child: ListView.builder(
//                itemCount: widget.cities.length,
//                itemBuilder: (BuildContext context, int index) {
//                  final cityName = widget.cities[index];
//                  return Container(
//                    child: CheckboxListTile(
//                        title: Text(cityName),
//                        value: _tempSelectedCities.contains(cityName),
//                        onChanged: (bool value) {
//                          if (value) {
//                            if (!_tempSelectedCities.contains(cityName)) {
//                              setState(() {
//                                _tempSelectedCities.add(cityName);
//                              });
//                            }
//                          } else {
//                            if (_tempSelectedCities.contains(cityName)) {
//                              setState(() {
//                                _tempSelectedCities.removeWhere(
//                                        (String city) => city == cityName);
//                              });
//                            }
//                          }
//                          widget
//                              .onSelectedCitiesListChanged(_tempSelectedCities);
//                        }),
//                  );
//                }),
//          ),
//        ],
//      ),
//    );
//  }
//}