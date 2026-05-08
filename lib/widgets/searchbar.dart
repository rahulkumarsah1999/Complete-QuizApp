import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/controllers/search_controller.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final MySearchController controller = Get.find();
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOverlayShown = false;

  @override
  void initState() {
    super.initState();
    // Rebuild overlay whenever suggestions change
    ever(controller.suggestions, (_) {
      if (mounted) _updateOverlay();
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
        controller.suggestions.clear();
      }
    });
  }

  void _updateOverlay() {
    if (!mounted) return;

    if (controller.suggestions.isEmpty) {
      _removeOverlay();
      return;
    }

    _removeOverlay();

    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    _isOverlayShown = true;
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _isOverlayShown) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isOverlayShown = false;
    }
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (_) => Positioned(
        width: MediaQuery.of(context).size.width - 40, // 20px padding each side
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56), // just below the search bar
          child: Material(
            color: Colors.transparent,
            child: Obx(() {
              if (controller.suggestions.isEmpty) return const SizedBox();
              return Container(
                constraints: const BoxConstraints(maxHeight: 260),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: controller.suggestions.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Colors.white10,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (_, i) {
                    final s = controller.suggestions[i];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        s.isCategory
                            ? Icons.category_outlined
                            : Icons.auto_awesome,
                        color: s.isCategory
                            ? Colors.cyanAccent
                            : Colors.purpleAccent,
                        size: 18,
                      ),
                      title: Text(
                        s.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        s.isCategory ? 'Category' : 'AI-generated quiz',
                        style: TextStyle(
                          color: s.isCategory
                              ? Colors.cyanAccent.withValues(alpha: 0.6)
                              : Colors.purpleAccent.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      onTap: () {
                        textController.text = s.isCategory
                            ? s.label
                            : (s.customTopic ?? s.label);
                        _focusNode.unfocus();
                        _removeOverlay();
                        controller.selectSuggestion(s);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24),
        ),
        child: TextField(
          controller: textController,
          focusNode: _focusNode,
          style: const TextStyle(color: Colors.white),
          onChanged: controller.onSearchChanged,
          onSubmitted: (val) {
            _focusNode.unfocus();
            _removeOverlay();
            controller.onSearchSubmit(val);
          },
          decoration: InputDecoration(
            icon: const Icon(Icons.search, color: Colors.white70),
            hintText: 'Search or enter any topic...',
            hintStyle: const TextStyle(color: Colors.white38),
            border: InputBorder.none,
            suffixIcon: Obx(() => controller.query.value.isNotEmpty
                ? GestureDetector(
              onTap: () {
                textController.clear();
                controller.onSearchChanged('');
                _focusNode.unfocus();
              },
              child: const Icon(Icons.close,
                  color: Colors.white38, size: 18),
            )
                : const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }
}