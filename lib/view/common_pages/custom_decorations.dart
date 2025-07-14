import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/config/urls.dart';
import 'package:nss/config/utils.dart';
import 'package:nss/view/home_screen.dart';
import 'package:nss/view/issues/user_issues_screen.dart';
import 'package:nss/view/volunteers/profile_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef StringValueOf<T> = String Function(T item);

class CustomWidgets {
  static InputDecoration textFieldDecoration({
    required String label,
    String? errorText,
    Widget? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      label: Text(label),
      prefix: prefix,
      suffix: suffix,
      border: const OutlineInputBorder(),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
      errorText: errorText,
    );
  }

  SearchBar searchBar(
      {BoxConstraints? constraints,
      Widget? leading,
      TextEditingController? controller,
      String? hintText,
      void Function(String)? onChanged,
      bool visible = true,
      void Function()? onPressedCancel}) {
    return SearchBar(
        constraints: constraints,
        leading: Icon(Icons.search),
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
        trailing: [
          Visibility(
            visible: visible,
            child:
                IconButton(onPressed: onPressedCancel, icon: Icon(Icons.close)),
          )
        ]);
  }

  static Padding searchableDropDown<T>({
    required TextEditingController controller,
    required StringValueOf<T> stringValueOf,
    required void Function(T) onSelected,
    void Function(String)? onChanged,
    required List<T> selectionList,
    TextInputType? keyboardType,
    required String label,
    bool show = true,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    double elevation = 2,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10),
  }) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: margin,
        elevation: elevation,
        child: Padding(
          padding: padding,
          child: Visibility(
            visible: show,
            child: TypeAheadField<T>(
              hideKeyboardOnDrag: true,
              debounceDuration: const Duration(milliseconds: 500),
              builder: (context, controller, focusNode) {
                return TextField(
                  keyboardType: keyboardType,
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) {
                    if (onChanged != null) {
                      onChanged(value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                  ),
                );
              },
              suggestionsCallback: (search) => selectionList
                  .where((element) =>
                      stringValueOf(element).toLowerCase().contains(
                            search.trim().toLowerCase(),
                          ))
                  .toList(),
              itemBuilder: (context, itemData) =>
                  ListTile(title: Text(stringValueOf(itemData))),
              controller: controller,
              onSelected: (value) => onSelected(value),
            ),
          ),
        ),
      ),
    );
  }

  Padding datePickerTextField({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    required String label,
    required TextEditingController controller,
    DateTime? currentDate,
    DateTime? initialDate,
    required void Function(DateTime) selectedDate,
    bool disableTap = false,
    InputDecoration? decoration,
  }) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          if (!disableTap) {
            DateTime pickedDate = await showDatePicker(
                  context: context,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  currentDate: currentDate,
                  initialDate: initialDate,
                ) ??
                lastDate;

            controller.text = DateFormat.yMMMd().format(pickedDate);

            selectedDate(pickedDate);
          }
        },
        decoration: decoration ?? textFieldDecoration(label: label),
      ),
    );
  }

  Card textField({
    required TextEditingController controller,
    required String label,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10),
    TextInputType? keyboardType,
    bool isEnabled = true,
    bool readOnly = false,
    bool? hideText,
    TextStyle? labelStyle,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    double elevation = 2,
    String? errorText,
    Widget? suffix,
    Color? color,
    int maxlines = 1,
    String? hintText,
    Widget? prefix,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: padding,
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          enabled: isEnabled,
          onTap: onTap,
          obscureText: hideText ?? false,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          maxLines: maxlines,
          decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
              labelText: label,
              border: InputBorder.none,
              labelStyle: labelStyle,
              suffix: suffix,
              prefix: prefix),
        ),
      ),
    );
  }

  Padding customDatePickerTextField({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    required String label,
    required TextEditingController controller,
    DateTime? currentDate,
    DateTime? initialDate,
    required void Function(DateTime) selectedDate,
    bool disableTap = false,
    InputDecoration? decoration,
  }) {
    return Padding(
      padding: padding,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              if (!disableTap) {
                DateTime pickedDate = await showDatePicker(
                      context: context,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      currentDate: currentDate,
                      initialDate: initialDate,
                    ) ??
                    lastDate;

                controller.text = DateFormat.yMMMd().format(pickedDate);

                selectedDate(pickedDate);
              }
            },
            decoration: decoration ?? textFieldDecoration(label: label),
          ),
        ),
      ),
    );
  }

  static Padding textWidget(
    MapEntry<String, dynamic> entry, {
    TextStyle? keyStyle,
    TextStyle? valueStyle,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
  }) {
    return Padding(
      padding: padding,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${formatKey(entry.key)} : ",
              style: keyStyle ?? Theme.of(Get.context!).textTheme.titleMedium,
            ),
            TextSpan(
              text: "${entry.value ?? ""}",
              style: valueStyle ?? Theme.of(Get.context!).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  static Padding salesRow({label, amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  color: Theme.of(Get.context!).colorScheme.primary)),
          Text(amount, style: Theme.of(Get.context!).textTheme.labelMedium),
        ],
      ),
    );
  }

  static void showSnackBar(
    String title,
    String message, {
    Widget? icon = const Icon(Icons.info_outline, color: Colors.white),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    Get.showSnackbar(GetSnackBar(
      titleText: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: textColor.withValues(alpha: 0.9),
        ),
      ),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      icon: icon,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 15,
      backgroundColor: backgroundColor,
      boxShadows: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 4),
        )
      ],
    ));
  }

  static void showToast(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 14.0,
    int toastLength = 3, // in seconds
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      timeInSecForIosWeb: toastLength,
    );
  }

  Expanded menuBuilder(
      {required List<Widget> menuChildren,
      required String label,
      required IconData icon,
      TextStyle? style}) {
    return Expanded(
      child: MenuAnchor(
        menuChildren: menuChildren,
        builder: (context, controller, child) {
          return InkWell(
            onTap: () =>
                (controller.isOpen) ? controller.close() : controller.open(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.grey.shade900,
                ),
                Text(label, style: style)
              ],
            ),
          );
        },
      ),
    );
  }

  void showConfirmationDialog(
      {required String title,
      String? message,
      Widget? content,
      required VoidCallback onConfirm,
      required Widget data}) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title),
          content: (message != null) ? Text(message) : content,
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(
              onPressed: () => onConfirm(),
              child: data,
            ),
          ],
        );
      },
    );
  }

  Widget buildActionButton({
    IconData? icon,
    required BuildContext context,
    required String text,
    Color? color,
    required VoidCallback onPressed,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    Color foregroundColor = Colors.white,
  }) {
    return Padding(
      padding: padding,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: color,
          minimumSize: Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Column footer() {
    return Column(
      children: [
        Text(
          "Developed by Bvoc Software Development",
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Text(
          "version ${Details.appVersion}",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
        ),
        SizedBox(height: 50)
      ],
    );
  }
}

class CustomNavBar extends StatelessWidget {
  CustomNavBar({super.key, required this.currentIndex});
  final int currentIndex;
  final pages = [HomeScreen(), ScreenIssues(), VolunteerAddScreen()];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        if (currentIndex != value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => pages[value],
          ));
        }
      },
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        navBarItem("Home", icon: Icon(Icons.home)),
        navBarItem("Issue", icon: Icon(Icons.bug_report_outlined)),
        navBarItem("Profile", icon: Icon(Icons.person_2)),
      ],
    );
  }

  BottomNavigationBarItem navBarItem(String label, {required Widget icon}) {
    return BottomNavigationBarItem(
        icon: icon,
        label: label,
        backgroundColor: Color.fromARGB(255, 25, 6, 71));
  }
}
