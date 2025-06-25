import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/volunteer_model.dart';

class StudentsEnrolled extends StatelessWidget {
  const StudentsEnrolled({super.key, this.data, this.enrolledStudents});
  final Program? data;
  final Users? enrolledStudents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students Enrolled"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Card.outlined(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Date: ${DateFormat.yMMMd().format(DateTime.parse(data!.date.toString()))}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Hours: ${data!.duration.toString()}",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Text(
                data!.name ?? "",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // ListTile(
              //   leading: Text('0'),
              //   title: Text('Name'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
