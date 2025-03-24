import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razinsoft_task_management/configs/res/color.dart';
import 'package:razinsoft_task_management/provider/DarkAndLightTheme/theme_provider.dart';

class CustomTextFieldWithFormField extends StatefulWidget {
  final String ?titleText;
  final String? requiredStar;
  final String placeholder;
  final TextEditingController controller;
  final FocusNode? focusCurrent;
  final FocusNode? focusNext;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onEditingComplete;

  CustomTextFieldWithFormField({
    Key? key,
     this.titleText,
    this.requiredStar,
    required this.placeholder,
    required this.controller,
    this.focusCurrent,
    this.focusNext,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
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
          width: screenWidth * 0.80,
          child: Row(
            children: [

              Text(
                '${widget.titleText} ',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.whiteColor: AppColors.blackColor,
                    letterSpacing: 0.8,
                  )
              ),
              Text(
                "${widget.requiredStar ?? ''}",
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02,),
        FormField<String>(
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<String> fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.055,
                  width: screenWidth * 0.80,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color:AppColors.blackColor,
                      width: 2,
                    ),
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusCurrent,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: widget.placeholder,
                      hintStyle: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                      letterSpacing: 0.8,
                    ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.8,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 0.4,
                        ),
                      ),
                    ),
                    onFieldSubmitted: widget.onFieldSubmitted,
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
                    width: screenWidth * 0.80,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Text(
                        fieldState.errorText ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:AppColors.blackColor,
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
