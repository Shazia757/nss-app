import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
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
      c.setUpdateData(program!);
    } else {
      c.clearTextFields();
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
            CustomWidgets().textField(
              controller: c.nameController,
              label: "Name",
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: GetBuilder(
                  id: 'date',
                  builder: (AddProgramController c) =>
                      CustomWidgets().customDatePickerTextField(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: InputBorder.none,
                            labelStyle: TextStyle(fontSize: 14),
                          ),
                          padding: const EdgeInsets.only(left: 2, right: 8.0),
                          context: context,
                          controller: c.dateController,
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                          label: "Date",
                          selectedDate: (p0) {
                            c.date = p0;
                            c.update(['date', true]);
                          },
                          initialDate: c.date),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: CustomWidgets().textField(
                        controller: c.durationController,
                        label: "Duration",
                        keyboardType: TextInputType.numberWithOptions())),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomWidgets().textField(
                controller: c.descController,
                label: "Description",
                maxlines: 8),
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
                                ? CustomWidgets().showConfirmationDialog(
                                    title: "Update Program",
                                    message:
                                        "Are you sure you want to update the program?",
                                    onConfirm: () {
                                      c.updateProgram(program!.id!);
                                    })
                                : CustomWidgets().showConfirmationDialog(
                                    title: "Add Program",
                                    message:
                                        "Are you sure you want to add the program?",
                                    onConfirm: () {
                                      c.addProgram();
                                    })
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
                          onPressed: () {
                            CustomWidgets().showConfirmationDialog(
                                title: "Delete Program",
                                message:
                                    "Are you sure you want to delete the program?",
                                onConfirm: () {
                                  c.deleteProgram(program!.id!);
                                });
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red.shade900,
                          ),
                          child: c.isDeleteButtonLoading.isTrue
                              ? Center(child: CircularProgressIndicator())
                              : Text("Delete"),
                        )),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
