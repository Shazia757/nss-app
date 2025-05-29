import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/programs_model.dart';

import 'add_program_screen.dart';

class ProgramDetails extends StatelessWidget {
  const ProgramDetails({super.key, required this.data});
  final Program data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Program Details"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Visibility(
            visible: LocalStorage().readUser().role != 'vol',
            child: TextButton.icon(
              onPressed: () {
                Get.to(() => AddProgramScreen(isUpdate: true, program: data))
                    ?.then(
                  (value) {
                    Get.back();
                  },
                );
              },
              label: Text(
                "Edit",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer),
              ),
              icon: Icon(Icons.edit,
                  color: Theme.of(context).colorScheme.primaryContainer),
            ),
          )
        ],
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
                        "Date: ${DateFormat.yMMMd().format(DateTime.parse(data.date.toString()))}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Hours: ${data.duration.toString()}",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Text(
                data.name ?? "",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(data.description ?? "")
            ],
          ),
        ),
      ),
    );
  }
}
