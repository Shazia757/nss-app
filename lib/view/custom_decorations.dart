import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/view/home_screen.dart';
import 'package:nss/view/volunteers/profile_screen.dart';

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

  static Padding searchableDropDown<T>({
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    required TextEditingController controller,
    required StringValueOf<T> stringValueOf,
    required void Function(T) onSelected,
    void Function(String)? onChanged,
    required List<T> selectionList,
    TextInputType? keyboardType,
    required String label,
    bool show = true,
  }) {
    return Padding(
      padding: padding,
      child: Visibility(
        visible: show,
        child: TypeAheadField<T>(
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
              decoration: textFieldDecoration(label: label),
            );
          },
          suggestionsCallback: (search) => selectionList
              .where((element) => stringValueOf(element).toLowerCase().contains(
                    search.trim().toLowerCase(),
                  ))
              .toList(),
          itemBuilder: (context, itemData) =>
              ListTile(title: Text(stringValueOf(itemData))),
          controller: controller,
          onSelected: (value) => onSelected(value),
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
    Widget? icon = const Icon(Icons.abc),
  }) {
    Get.showSnackbar(GetSnackBar(
      title: title,
      isDismissible: true,
      duration: const Duration(milliseconds: 2000),
      icon: icon,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 20,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      snackStyle: SnackStyle.GROUNDED,
      barBlur: 30,
    ));
  }
}

String formatKey(String key) {
  String formattedKey = key.replaceAllMapped(
      RegExp(r'(?<!^)([A-Z])'), (Match match) => ' ${match.group(0)}');
  formattedKey =
      formattedKey.replaceFirst(formattedKey[0], formattedKey[0].toUpperCase());
  formattedKey = formattedKey
      .replaceAll('P N R', 'PNR ')
      .replaceAll('Crs', 'CRS ')
      .replaceAll('P A N', 'PAN ')
      .replaceAll('Agent G S T', 'Agent GST')
      .replaceAll('O D ', 'OD ')
      .replaceAll('Or', "/")
      .replaceAll('I D', "ID")
      .replaceAll('Of', "of")
      .replaceAll('Y Q', 'YQ');
  return formattedKey;
}

class CustomNavBar extends StatelessWidget {
  CustomNavBar({super.key, required this.currentIndex});
  final int currentIndex;
  final pages = [HomeScreen(), HomeScreen(), ProfileScreen()];

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
