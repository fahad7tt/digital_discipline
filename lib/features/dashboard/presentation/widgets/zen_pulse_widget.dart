import 'dart:async';
import 'package:flutter/material.dart';

class ZenPulseFAB extends StatefulWidget {
  const ZenPulseFAB({super.key});

  @override
  State<ZenPulseFAB> createState() => _ZenPulseFABState();
}

class _ZenPulseFABState extends State<ZenPulseFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _isBreathing = false;
  String _message = 'Breathe';
  int _secondsLeft = 16;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    if (_isBreathing) return;

    setState(() {
      _isBreathing = true;
      _secondsLeft = 16;
      _message = 'Breathe In';
    });

    _pulseController.duration = const Duration(seconds: 4);
    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsLeft--;
          if (_secondsLeft <= 0) {
            timer.cancel();
            _reset();
          } else {
            // Logic: 0-4s: In, 4-8s: Out, 8-12s: In, 12-16s: Out
            int elapsed = 16 - _secondsLeft;
            if (elapsed % 8 < 4) {
              _message = 'Breathe in';
            } else {
              _message = 'Breathe out';
            }
          }
        });
      }
    });

    _showTopNotification(
      context,
      'Zen Session Started: Focus on your breath',
      isSuccess: false,
    );
  }

  void _reset() {
    if (mounted) {
      setState(() {
        _isBreathing = false;
        _message = 'Breathe';
      });
    }

    _pulseController.duration = const Duration(seconds: 4);
    _pulseController.repeat(reverse: true);

    _showTopNotification(
      context,
      'Session Complete. Stay Mindful',
      isSuccess: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: 42,
        child: FloatingActionButton.extended(
          heroTag: 'hero_zen_pulse',
          onPressed: _startBreathing,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          label: Text(
            _isBreathing
                ? (_secondsLeft > 0 ? '$_message (${_secondsLeft}s)' : _message)
                : 'Zen Pulse',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
    );
  }

  void _showTopNotification(BuildContext context, String message,
      {bool isSuccess = false}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSuccess
                  ? Colors.green
                  : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black54),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                  color: (isSuccess ||
                          Theme.of(context).brightness == Brightness.light)
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
