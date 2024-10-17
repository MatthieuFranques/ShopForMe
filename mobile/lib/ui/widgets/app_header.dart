import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final List<String> shoppingLists;
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
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (shoppingLists.isNotEmpty && currentIndex > 0)
            _buildArrow(Icons.arrow_back_ios, () => onIndexChanged(currentIndex - 1)),
          Expanded(
            child: shoppingLists.isEmpty
                ? _buildAddButton()
                : _buildPageView(),
          ),
          if (shoppingLists.isNotEmpty && currentIndex < shoppingLists.length - 1)
            _buildArrow(Icons.arrow_forward_ios, () => onIndexChanged(currentIndex + 1)),
        ],
      ),
    );
  }

  Widget _buildArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        color: Colors.transparent,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.white),
      onPressed: onAddList,
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      itemCount: shoppingLists.length,
      controller: PageController(initialPage: currentIndex),
      onPageChanged: onIndexChanged,
      itemBuilder: (context, index) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Text(
                shoppingLists[index],
                style: const TextStyle(color: Colors.white, fontSize: 75, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        );
      },
    );
  }
}