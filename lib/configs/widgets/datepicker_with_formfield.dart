import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';

class CustomDatePickerFormField extends StatelessWidget {
  final String title;
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomDatePickerFormField({
    Key? key,
    required this.title,
    required this.labelText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth * 0.4,
          child: Text(
            title,
            style:AppTextStyles.poppins16Medium
          ),
        ),
        SizedBox(height: 8),
        FormField<String>(
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: screenHeight * 0.055,
                  width: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: AppColors.textgreyColor,
                      width: 0.5,
                    ),
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    decoration: InputDecoration(
                      hintText: labelText,
                      hintStyle: AppTextStyles.poppins12Regular,
                      errorMaxLines: 3,
                      errorStyle: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 0.8,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 0.4,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.blueViolet,
                      ),
                    ),
                      onTap: () async {
                        DateTime? initialDate = controller.text.isNotEmpty
                            ? DateFormat('dd/MM/yyyy').parse(controller.text)
                            : DateTime.now();

                        DateTime? pickedDate = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.blueViolet,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          controller.text = formattedDate;
                          state.didChange(formattedDate);
                        }
                      }


                  ),
                ),
                if (state.hasError)
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 10),
                      child: Text(
                        state.errorText ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                else
                  Text("No Error",style:TextStyle(color: Colors.transparent) ,),
              ],
            );
          },
        ),
      ],
    );
  }
}
