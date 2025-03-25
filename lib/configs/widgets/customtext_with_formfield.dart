import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/configs/res/text_styles.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';

class CustomTextFieldWithFormField extends StatefulWidget {
  final String ?titleText;
  final String? requiredStar;
  final String placeholder;
  final double? dynamicheight;
  final TextEditingController controller;
  final FocusNode? focusCurrent;
  final FocusNode? focusNext;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType keyboardType;

  CustomTextFieldWithFormField({
    Key? key,
     this.titleText,
    this.requiredStar,
    this.dynamicheight,
    required this.placeholder,
    required this.controller,
    this.focusCurrent,
    this.focusNext,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<CustomTextFieldWithFormField> createState() => _CustomTextFieldWithFormFieldState();
}

class _CustomTextFieldWithFormFieldState extends State<CustomTextFieldWithFormField> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Column(
      children: [
        Container(
          width: screenWidth * 0.9,
          child:  Text(
              '${widget.titleText} ',
              style: AppTextStyles.poppins16Medium
          ),
        ),
        SizedBox(height: screenHeight * 0.01,),
        FormField<String>(
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<String> fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: widget.dynamicheight,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:AppColors.textgreyColor,
                      width: 0.5,
                    ),
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusCurrent,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.keyboardType == TextInputType.multiline ? 5 : 1,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: widget.placeholder,
                      hintStyle:  AppTextStyles.poppins12Regular,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.8,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 0.4,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      fieldState.didChange(value);
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    },
                  ),
                ),
                if (fieldState.hasError)
                  Container(
                    width: screenWidth * 0.90,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 10.0),
                      child: Text(
                        fieldState.errorText ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                            color: Colors.red,
                          letterSpacing: 0.2
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
