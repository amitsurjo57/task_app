import 'package:flutter/material.dart';

class MySearchAnchor extends StatelessWidget {
  final String hintText;
  final SearchController searchController;
  final List<String> itemList;

  const MySearchAnchor({
    super.key,
    required this.hintText,
    required this.searchController,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      isFullScreen: false,
      searchController: searchController,
      barElevation: WidgetStatePropertyAll(0),
      barLeading: SizedBox(),
      barHintText: hintText,
      barBackgroundColor: WidgetStatePropertyAll(
        Theme.of(context).scaffoldBackgroundColor,
      ),
      viewBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      viewConstraints: BoxConstraints(maxHeight: 300),
      barTrailing: [Icon(Icons.keyboard_arrow_down)],
      onTap: () => searchController.openView(),
      suggestionsBuilder: (context, controller) {
        final String input = controller.value.text;

        if (input.isEmpty) {
          return itemList.map((value) {
            return ListTile(
              title: Text(value),
              onTap: () {
                controller.closeView(value);
                debugPrint("Selected city: $value");
              },
            );
          }).toList();
        }

        final filteredCities = itemList.where((value) {
          return value.contains(input);
        }).toList();

        return filteredCities.map((value) {
          return ListTile(
            title: Text(value),
            onTap: () {
              controller.closeView(value);
              debugPrint("Selected city: $value");
            },
          );
        }).toList();
      },
    );
  }
}
