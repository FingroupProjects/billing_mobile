import 'package:flutter/material.dart';

const Color kFilterBackgroundColor = Color(0xFFF4F7FD);
const Color kFilterTextColor = Color(0xFF1E2E52);
const Color kFilterActionColor = Color(0xFF6EA7E8);

InputDecoration buildFilterDropdownDecoration() {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide.none,
  );

  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8FAFF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: Colors.red, width: 1.2),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: Colors.red, width: 1.2),
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: Colors.red,
      fontWeight: FontWeight.w500,
      fontFamily: 'Gilroy',
    ),
  );
}

class FilterSectionCard extends StatelessWidget {
  final Widget child;

  const FilterSectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1E2E52),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class FilterActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const FilterActionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          backgroundColor: const Color(0xFFF3F7FF),
          side: const BorderSide(color: Color(0xFF9FC2EE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kFilterActionColor,
            fontFamily: 'Gilroy',
          ),
        ),
      ),
    );
  }
}

class FilterErrorBadge extends StatelessWidget {
  final String text;

  const FilterErrorBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x141E2E52),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF47351F),
            fontFamily: 'Gilroy',
          ),
        ),
      ),
    );
  }
}
