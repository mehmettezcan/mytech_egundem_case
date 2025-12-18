import 'package:flutter/material.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';

class EgundemButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFlat;
  const EgundemButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.isFlat = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
          onPressed?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isFlat ? Colors.transparent : AppColors.primaryColor,
          disabledBackgroundColor: isFlat ? Colors.transparent : const Color(0xFF3B82F6).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isFlat
                ? const BorderSide(color: AppColors.greyColor, width: 0.5)
                : BorderSide.none,
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                : child,
      ),
    );
  }
}
