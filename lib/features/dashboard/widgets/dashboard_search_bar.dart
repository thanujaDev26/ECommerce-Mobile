import 'package:flutter/material.dart';
import 'package:e_commerce/features/dashboard/viewmodels/handcraft_model.dart';

class DashboardSearchBar extends StatefulWidget {
  final List<HandcraftProduct> allProducts;
  final Function(HandcraftProduct) onProductSelected;

  const DashboardSearchBar({
    Key? key,
    required this.allProducts,
    required this.onProductSelected,
  }) : super(key: key);

  @override
  State<DashboardSearchBar> createState() => _DashboardSearchBarState();
}

class _DashboardSearchBarState extends State<DashboardSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<HandcraftProduct> _suggestions = [];

  void _onSearchChanged(String query) {
    setState(() {
      _suggestions = widget.allProducts
          .where((product) => (product.title ?? '')
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _clearSuggestions() {
    setState(() {
      _suggestions.clear();
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void unfocusSearchBar() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final bgColor = isDark ? Colors.grey[850] : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            autofocus: false,
            onChanged: _onSearchChanged,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Search products...",
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Icon(Icons.search, color: textColor),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: () {
                  _controller.clear();
                  _clearSuggestions();
                  _focusNode.unfocus();
                },
              )
                  : null,
              filled: true,
              fillColor: bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Suggestions list
        if (_suggestions.isNotEmpty)
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final product = _suggestions[index];
                  return ListTile(
                    tileColor: isDark ? Colors.grey[900] : Colors.grey[100],
                    title: Text(
                      product.title ?? '',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      _controller.clear();
                      _clearSuggestions();
                      _focusNode.unfocus();
                      widget.onProductSelected(product);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
