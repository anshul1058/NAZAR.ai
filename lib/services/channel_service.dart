import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/utils/app_logger.dart';

class ChannelService {
  static const EventChannel _channel = EventChannel(
    'com.nazar.ai/detection_stream',
  );

  static const MethodChannel _methodChannel = MethodChannel(
    'com.nazar.ai/service_control',
  );

  static Future<void> startService(String childId) async {
    try {
      await _methodChannel.invokeMethod('startService', {
        'child_id': childId,
      });
    } catch (e) {
      AppLogger.d('Error startService → $e');
    }
  }

  static Future<void> stopService() async {
    try {
      await _methodChannel.invokeMethod('stopService');
    } catch (e) {
      AppLogger.d('Error stopService → $e');
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static bool _isListening = false;

  /// Heartbeat timer — update last_seen every 30 seconds while the service is active
  static Timer? _heartbeatTimer;

  // Start listening for events from the native side
  static void startListening() {
    if (_isListening) return;
    _isListening = true;

    _channel.receiveBroadcastStream().listen(
      (dynamic event) {
        try {
          // Parse JSON from the native side
          final Map<String, dynamic> data = event is String
              ? jsonDecode(event)
              : Map<String, dynamic>.from(event);

          final String eventType = data['event_type'] ?? '';

          switch (eventType) {
            case 'gambling_detected':
              _handleGamblingDetected(data);
              break;
            case 'service_started':
              _handleServiceStarted(data);
              break;
            case 'service_stopped':
              _handleServiceStopped(data);
              break;
            case 'permission_denied':
              _handlePermissionDenied();
              break;
            default:
              AppLogger.d('Unknown event type → $eventType');
          }
        } catch (e) {
          AppLogger.d('Error parse event → $e');
        }
      },
      onError: (dynamic error) {
        AppLogger.d('Channel error → $error');
        _isListening = false;
      },
    );
  }

  // ─── Update connection status in Supabase ──────────────
  static Future<void> _updateConnectionStatus(String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role') ?? '';
      if (role != 'child') return; // Only the child's phone may update

      final childId = prefs.getString('child_id');
      if (childId == null || childId.isEmpty) {
        AppLogger.d('Cannot update status — child_id is empty');
        return;
      }

      await Supabase.instance.client.rpc('update_child_connection', params: {
        'p_child_id': childId,
        'p_status': status,
        'p_last_seen': DateTime.now().toUtc().toIso8601String(),
      });

      AppLogger.d('Connection status updated → $status');
    } catch (e) {
      AppLogger.d('Failed to update connection status → $e');
    }
  }

  // ─── Heartbeat — update last_seen periodically ────────────
  static void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _sendHeartbeat(),
    );
    // Send once immediately
    _sendHeartbeat();
  }

  static void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  static Future<void> _sendHeartbeat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final childId = prefs.getString('child_id');
      if (childId == null || childId.isEmpty) return;

      await Supabase.instance.client.rpc('update_child_connection', params: {
        'p_child_id': childId,
        'p_status': 'online',
        'p_last_seen': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      // Heartbeat failed = internet may be down — stay quiet
      AppLogger.d('Heartbeat failed → $e');
    }
  }

  // ─── Handler gambling_detected ──────────────────────
  static void _handleGamblingDetected(Map<String, dynamic> data) {
    final keywords = List<String>.from(data['keywords'] ?? []);
    final triggeredBy = data['triggered_by']?.toString() ?? '';
    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;

    AppLogger.d('Gambling detected! confidence=$confidence');

    // Navigate to the Education screen
    final context = navigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).push(
        '/education',
        extra: {
          'keywords': keywords,
          'triggeredBy': triggeredBy,
          'confidence': confidence,
        },
      );
    }
  }

  // ─── Handler service_started ────────────────────────
  static void _handleServiceStarted(Map<String, dynamic> data) async {
    AppLogger.d('Service started');

    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';

    // Only process on the child's phone
    if (role != 'child') {
      AppLogger.d('Not child mode — skip status update');
      return;
    }

    // Update status to Supabase → online
    _updateConnectionStatus('online');

    // Start heartbeat
    _startHeartbeat();

    final context = navigatorKey.currentContext;
    if (context != null) {
      // Navigate to the active screen — permissions already granted
      GoRouter.of(context).go('/active');
    }
  }

  // ─── Handler service_stopped ────────────────────────
  static void _handleServiceStopped(Map<String, dynamic> data) async {
    AppLogger.d('Service stopped ⚠️');

    // Check if this phone is in child mode — only show the warning in child mode
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getString('child_id');

    // Update status to Supabase → offline_manual
    _updateConnectionStatus('offline_manual');

    // Stop heartbeat
    _stopHeartbeat();

    // Only show the warning if this is the child's phone
    if (childId == null || childId.isEmpty) return;

    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child:
                    Text("Nazar.Ai is inactive ⚠️ The child's phone is not protected!"),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // ─── Handler permission_denied ────────────────────────
  static void _handlePermissionDenied() async {
    AppLogger.d('Permission denied — reverting status to offline_manual');

    // Revert status via RPC
    _updateConnectionStatus('offline_manual');
    _stopHeartbeat();

    // Remove child_id from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('child_id');
    await prefs.remove('role');

    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.block_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text('Permission denied — Nazar.Ai is inactive'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Go back to role-select — the active screen must not show
      GoRouter.of(context).go('/role-select');
    }
  }
}
