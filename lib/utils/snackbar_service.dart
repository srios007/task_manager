import 'package:flutter/material.dart';

class SnackbarService {
  static final SnackbarService _instance = SnackbarService._internal();

  factory SnackbarService() {
    return _instance;
  }

  SnackbarService._internal();

  OverlayEntry? _overlayEntry;

  void showSuccessSnackbar(BuildContext context) {
    _removeCurrentOverlay();
    _overlayEntry = _createOverlayEntry(
        context, 'Action successfully completed', Colors.green[400]!);
    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(const Duration(seconds: 3), () {
      _removeCurrentOverlay();
    });
  }

  void showErrorSnackbar(BuildContext context, {String? message}) {
    _removeCurrentOverlay();
    _overlayEntry = _createOverlayEntry(
        context, message ?? 'An error occurred, please try again', Colors.red);
    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(const Duration(seconds: 3), () {
      _removeCurrentOverlay();
    });
  }

  void _removeCurrentOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry(
      BuildContext context, String message, Color backgroundColor) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _removeCurrentOverlay();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final snackbarService = SnackbarService();
