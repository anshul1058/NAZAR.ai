import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_logger.dart';
import '../../services/channel_service.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;
  bool _hasScanned = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onQrDetected(String childId) async {
    // Prevent repeated scans
    if (_isProcessing || _hasScanned) return;
    setState(() {
      _isProcessing = true;
      _hasScanned = true;
    });

    HapticFeedback.mediumImpact();

    // Validate UUID format
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    if (!uuidRegex.hasMatch(childId)) {
      setState(() {
        _isProcessing = false;
        _hasScanned = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid QR Code. Try scanning again.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Save child_id & role to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('child_id', childId);
    await prefs.setString('role', 'child');

    if (!mounted) return;

    // Show the permission guide before asking for permission
    _showPermissionGuide(childId);
  }

  void _showPermissionGuide(String childId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Icon
                  const Center(
                    child: Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Permission Needed',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Nazar.Ai needs screen recording access\nto be able to protect this device.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Steps
                  const Text(
                    'How to allow:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildStep('1', 'A pop-up from the Android system will appear'),
                  const SizedBox(height: 12),
                  _buildStep('2', 'Choose "Entire Screen" (the full screen)'),
                  const SizedBox(height: 12),
                  _buildStep('3', 'Tap the "Start" button to begin'),

                  const SizedBox(height: 24),

                  // Note
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: AppColors.warning, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'If permission is not granted, Nazar.Ai can\'t run on this device.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(sheetCtx);
                        await _startServiceAndCheckPermission(childId);
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.buttonPrimaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /// Start the service and ask for permission
  Future<void> _startServiceAndCheckPermission(String childId) async {
    // Update status to online in Supabase via RPC
    try {
      await Supabase.instance.client.rpc('update_child_connection', params: {
        'p_child_id': childId,
        'p_status': 'online',
        'p_last_seen': DateTime.now().toUtc().toIso8601String(),
      });
      AppLogger.d('Status updated to online');
    } catch (e) {
      AppLogger.d('Failed to update status → $e');
    }

    // Start the service — the permission popup will appear over the camera
    // Navigation to /active is handled by _handleServiceStarted
    // after the permission is actually granted
    await ChannelService.startService(childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera scanner
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                _onQrDetected(barcode!.rawValue!);
              }
            },
          ),

          // UI overlay on top of the camera
          SafeArea(
            child: Column(
              children: [
                // Manual AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      const Text(
                        AppStrings.scanQR,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),

                      // Flash toggle
                      IconButton(
                        icon: const Icon(
                          Icons.flash_on_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => _scannerController.toggleTorch(),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Scanner frame
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Stack(
                    children: [
                      _Corner(top: 0, left: 0),
                      _Corner(top: 0, right: 0),
                      _Corner(bottom: 0, left: 0),
                      _Corner(bottom: 0, right: 0),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Instructions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    AppStrings.scanQRDesc,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Loading indicator while processing
                if (_isProcessing)
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Corner Widget ────────────────────────────────────
class _Corner extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _Corner({this.top, this.bottom, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom: bottom != null
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left: left != null
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right: right != null
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
