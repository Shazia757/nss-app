import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/program_controller.dart';
import '../../model/programs_model.dart';

class AddProgramScreen extends StatelessWidget {
  final Program? program;

  final bool isUpdate;

  const AddProgramScreen({super.key, required this.isUpdate, this.program});

  @override
  Widget build(BuildContext context) {
    AddProgramController c = Get.put(AddProgramController());
    if (isUpdate) {
      c.nameController.text = program?.name ?? '';
      c.descController.text = program?.description ?? '';
      c.date = program?.date;
      log(c.date.toString());
      c.dateController.text = (program?.date) != null
          ? DateFormat.yMMMd().format(program!.date!)
          : '';
      c.durationController.text = (program?.duration) != null
          ? (program?.duration ?? 0).toString()
          : '';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${isUpdate ? "Update" : "Add"} Program"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Name"),
              controller: c.nameController,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                          initialDate: c.date,
                          context: context,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 30)),
                          lastDate: DateTime.now().add(Duration(days: 365)));

                      c.dateController.text = (selectedDate != null)
                          ? DateFormat.yMMMd().format(selectedDate)
                          : "";
                      c.date = selectedDate;
                      log(c.date.toString());
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Date"),
                    controller: c.dateController,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Duration", border: OutlineInputBorder()),
                    controller: c.durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Description"),
              controller: c.descController,
              maxLines: 8,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => c.isUpdateButtonLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : AbsorbPointer(
                      absorbing: c.isUpdateButtonLoading.value ||
                          c.isDeleteButtonLoading.value,
                      child: FilledButton(
                        onPressed: () => c.onSubmitProgramValidation()
                            ? isUpdate
                                ? c.updateProgram(program!.id!)
                                : c.addProgram()
                            : () {},
                        child: Text(isUpdate ? "Update" : "Add"),
                      ),
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            isUpdate
                ? Obx(
                    () => AbsorbPointer(
                      absorbing: c.isDeleteButtonLoading.value ||
                          c.isUpdateButtonLoading.value,
                      child: FilledButton(
                        onPressed: () => c.deleteProgram(program!.id!),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                        ),
                        child: c.isDeleteButtonLoading.isTrue
                            ? Center(child: CircularProgressIndicator())
                            : Text("Delete"),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
