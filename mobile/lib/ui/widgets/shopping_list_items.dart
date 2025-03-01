import 'package:flutter/material.dart';
import 'package:mobile/blocs/shopping_list/shopping_list_export.dart';
import 'package:mobile/ui/widgets/action_button.dart';
import 'package:mobile/utils/screen_utils.dart';

class ShoppingListItems extends StatelessWidget {
  final ShoppingListLoaded state;
  final Function(int) onDeleteProduct;

  const ShoppingListItems({
    super.key,
    required this.state,
    required this.onDeleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: context.getResponsiveSize(16),
        vertical: context.getResponsiveSize(8),
      ),
      itemCount: state.currentList.products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = state.currentList.products[index];
        final isInvalid = state.invalidProducts.contains(product);

        return Container(
          height: context.getResponsiveSize(80),
          decoration: BoxDecoration(
            color: isInvalid 
              ? Colors.red.shade100 
              : Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.getResponsiveSize(16),
                    vertical: context.getResponsiveSize(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.getResponsiveFontSize(19),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.rayon,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: context.getResponsiveFontSize(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isInvalid)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            state.validationErrors.firstWhere(
                              (error) => error.contains(product.name),
                              orElse: () => 'Produit invalide',
                            ),
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontSize: context.getResponsiveFontSize(12),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              ActionButton(
                icon: Icons.close,
                onPressed: () => onDeleteProduct(int.parse(product.id)),
                color: isInvalid 
                  ? Colors.red.shade400
                  : Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        );
      },
    );
  }
}