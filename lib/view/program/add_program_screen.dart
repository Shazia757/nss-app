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

      (isUpdate) ? c.setUpdateData(program!) : c.clearTextFields();

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
                    builder: (AddProgramController c) => CustomWidgets()
                        .customDatePickerTextField(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                            context: context,
                            controller: c.dateController,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
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
              AbsorbPointer(
                absorbing: c.isUpdateButtonLoading.value ||
                    c.isDeleteButtonLoading.value,
                child: CustomWidgets().buildActionButton(
                  icon: Icons.add,
                  color: Theme.of(context).primaryColor,
                  context: context,
                  onPressed: () => c.onSubmitProgramValidation()
                      ? isUpdate
                          ? CustomWidgets().showConfirmationDialog(
                              title: "Update Program",
                              message:
                                  "Are you sure you want to update the program?",
                              onConfirm: () {
                                c.updateProgram(program!.id!);
                              },
                              data: Obx(
                                () => c.isUpdateButtonLoading.value
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Confirm",
                                        style: TextStyle(color: Colors.red),
                                      ),
                              ))
                          : CustomWidgets().showConfirmationDialog(
                              title: "Add Program",
                              message:
                                  "Are you sure you want to add the program?",
                              onConfirm: () => c.addProgram(),
                              data: Obx(
                                () => c.isUpdateButtonLoading.value
                                    ? CircularProgressIndicator()
                                    : Text("Confirm",
                                        style: TextStyle(color: Colors.red)),
                              ))
                      : () {},
                  text: isUpdate ? "Update" : "Add",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              isUpdate
                  ? AbsorbPointer(
                      absorbing: c.isDeleteButtonLoading.value ||
                          c.isUpdateButtonLoading.value,
                      child: CustomWidgets().buildActionButton(
                          context: context,
                          text: "Delete Program",
                          icon: Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                          onPressed: () => CustomWidgets().showConfirmationDialog(
                              title: "Delete Program",
                              message:
                                  "Are you sure you want to delete this program?",
                              onConfirm: () => c.deleteProgram(program!.id!),
                              data: Obx(
                                () => c.isDeleteButtonLoading.value
                                    ? CircularProgressIndicator()
                                    : Text("Confirm",
                                        style: TextStyle(color: Colors.red)),
                              ))),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    }
  }
