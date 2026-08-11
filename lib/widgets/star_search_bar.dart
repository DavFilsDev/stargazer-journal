import 'package:flutter/material.dart';

/// Reusable search field with a leading search icon and a clear button.
///
/// Named `StarSearchBar` (rather than `SearchBar`) to avoid colliding
/// with Flutter's own Material 3 `SearchBar` widget.
class StarSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const StarSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search stars, planets, nebulae…',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            );
          },
        ),
      ),
    );
  }
}
