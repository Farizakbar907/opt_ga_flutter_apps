import 'package:flutter/material.dart';
// import 'package:opt_ga_flutter_apps/model/car/Car.dart';
import '../models/car.dart';

class PoliceNoDropDown extends StatefulWidget {
  List<Car>? cars;

  Function(Car) callback;

  PoliceNoDropDown(
    this.cars,
    this.callback, {
    Key? key,
  }) : super(key: key);

  @override
  _PoliceNoDropDownState createState() => _PoliceNoDropDownState();
}

class _PoliceNoDropDownState extends State<PoliceNoDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Car>(
      hint: const Text('Select No Police'),
      items: widget.cars?.map((car) {
        return DropdownMenuItem(
          value: car,
          child: Text(car.police_no!),
        );
      }).toList(),
      onChanged: (Car? value) {
        setState(() {
          widget.callback(value!);
        });
      },
    );
  }
}
