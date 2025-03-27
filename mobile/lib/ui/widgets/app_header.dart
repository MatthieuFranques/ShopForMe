// app_header.dart
import 'package:flutter/material.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:mobile/models/shopping_list.dart';

class AppHeader extends StatelessWidget {
  final List<ShoppingList> shoppingLists;
  final int currentIndex;
  final Function(int) onIndexChanged;
  final VoidCallback onAddList;

  const AppHeader({
    super.key,
    required this.shoppingLists,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onAddList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getResponsiveSize(140),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(context.getResponsiveSize(8)),
      ),
      child: Row(
        children: [
          if (shoppingLists.isNotEmpty && currentIndex > 0)
            _buildArrow(context, Icons.arrow_back_ios,
                () => onIndexChanged(currentIndex - 1)),
          Expanded(
            child: shoppingLists.isEmpty
                ? _buildAddButton(context)
                : _buildPageView(context),
          ),
          if (shoppingLists.isNotEmpty &&
              currentIndex < shoppingLists.length - 1)
            _buildArrow(context, Icons.arrow_forward_ios,
                () => onIndexChanged(currentIndex + 1)),
        ],
      ),
    );
  }

  Widget _buildArrow(BuildContext context, IconData icon, VoidCallback onTap) {
    return Semantics(
      label: icon == Icons.arrow_back ? "Autre liste" : "Autre liste",
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: context.getResponsiveSize(40),
          color: Colors.transparent,
          child: Icon(
            icon,
            color: Colors.white,
            size: context.getResponsiveSize(24),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Semantics(
      label: "Ajouter une liste",
      button: true,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: context.getResponsiveSize(24),
        ),
        onPressed: onAddList,
      ),
    );
  }

  Widget _buildPageView(BuildContext context) {
    return PageView.builder(
      itemCount: shoppingLists.length,
      controller: PageController(initialPage: currentIndex),
      onPageChanged: onIndexChanged,
      itemBuilder: (context, index) {
        final list = shoppingLists[index];
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                list.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.getResponsiveFontSize(30),
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${list.products.length} produits',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: context.getResponsiveFontSize(20),
                ),
              ),
              Text(
                list.date,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: context.getResponsiveFontSize(20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
