import 'package:flutter/material.dart';
import '../atoms/constants.dart';

/// A component that allows users to select multiple tags for a transaction.
/// This replaces the single category dropdown with a more flexible tagging system.
class TagSelector extends StatefulWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final bool canCreateNew;

  const TagSelector({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
    this.canCreateNew = true,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final TextEditingController _newTagController = TextEditingController();
  final FocusNode _newTagFocus = FocusNode();
  bool _showAddNew = false;

  @override
  void dispose() {
    _newTagController.dispose();
    _newTagFocus.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    final List<String> updatedTags = List.from(widget.selectedTags);
    if (updatedTags.contains(tag)) {
      updatedTags.remove(tag);
    } else {
      updatedTags.add(tag);
    }
    widget.onTagsChanged(updatedTags);
  }

  void _addNewTag() {
    final newTag = _newTagController.text.trim();
    if (newTag.isNotEmpty && !widget.availableTags.contains(newTag)) {
      final List<String> updatedTags = List.from(widget.selectedTags)
        ..add(newTag);
      widget.onTagsChanged(updatedTags);
      _newTagController.clear();
      setState(() => _showAddNew = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tags',
              style: BarakahTypography.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.canCreateNew)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAddNew = !_showAddNew;
                    if (_showAddNew) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _newTagFocus.requestFocus();
                      });
                    }
                  });
                },
                icon: Icon(_showAddNew ? Icons.close : Icons.add),
                label: Text(_showAddNew ? 'Cancel' : 'Add New'),
                style: TextButton.styleFrom(
                  foregroundColor: BarakahColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),

        const SizedBox(height: BarakahSpacing.sm),

        // New tag input field
        if (_showAddNew) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newTagController,
                  focusNode: _newTagFocus,
                  decoration: const InputDecoration(
                    hintText: 'Enter new tag',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addNewTag(),
                ),
              ),
              const SizedBox(width: BarakahSpacing.sm),
              ElevatedButton(
                onPressed: _addNewTag,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BarakahColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
        ],

        // Tag chips
        Wrap(
          spacing: BarakahSpacing.sm,
          runSpacing: BarakahSpacing.xs,
          children: [
            ...widget.availableTags.map((tag) {
              final isSelected = widget.selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) => _toggleTag(tag),
                selectedColor: BarakahColors.primary.withOpacity(0.2),
                checkmarkColor: BarakahColors.primary,
                side: BorderSide(
                  color: isSelected
                      ? BarakahColors.primary
                      : isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1.0,
                ),
              );
            }),

            // Show selected tags that aren't in available tags (custom ones)
            ...widget.selectedTags
                .where((tag) => !widget.availableTags.contains(tag))
                .map((tag) {
              return FilterChip(
                label: Text(tag),
                selected: true,
                onSelected: (_) => _toggleTag(tag),
                selectedColor: BarakahColors.primary.withOpacity(0.2),
                checkmarkColor: BarakahColors.primary,
                side: BorderSide(
                  color: BarakahColors.primary,
                  width: 1.5,
                ),
              );
            }),
          ],
        ),

        // Help text
        if (widget.selectedTags.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: BarakahSpacing.sm),
            child: Text(
              'Tags help organize your transactions better than categories',
              style: BarakahTypography.caption.copyWith(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
