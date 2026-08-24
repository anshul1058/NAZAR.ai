import 'dart:convert';

class Detection {
  final String id;
  final String childId;
  final String screenshotUrl;
  final double confidence;
  final String triggeredBy;
  final List<String> keywords;
  final Map<String, dynamic> details;
  final DateTime createdAt;

  Detection({
    required this.id,
    required this.childId,
    required this.screenshotUrl,
    required this.confidence,
    required this.triggeredBy,
    required this.keywords,
    required this.details,
    required this.createdAt,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    // Handle details that can be a String or a Map
    Map<String, dynamic> details = {};
    final rawDetails = json['details'];
    if (rawDetails is String && rawDetails.isNotEmpty) {
      try {
        details = Map<String, dynamic>.from(jsonDecode(rawDetails) as Map);
      } catch (_) {}
    } else if (rawDetails is Map) {
      details = Map<String, dynamic>.from(rawDetails);
    }

    // Handle confidence that can be a String or a num
    final rawConfidence = json['confidence'];
    final confidence = rawConfidence is String
        ? double.tryParse(rawConfidence) ?? 0.0
        : (rawConfidence as num?)?.toDouble() ?? 0.0;

    // Handle screenshotUrl that can be null
    final screenshotUrl = json['screenshot_url'] as String? ?? '';

    // Handle triggeredBy that can be null
    final triggeredBy = json['triggered_by'] as String? ?? '';

    return Detection(
      id: json['id'] as String,
      childId: json['child_id'] as String,
      screenshotUrl: screenshotUrl,
      confidence: confidence,
      triggeredBy: triggeredBy,
      keywords: List<String>.from(json['keywords'] ?? []),
      details: details,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'screenshot_url': screenshotUrl,
      'confidence': confidence,
      'triggered_by': triggeredBy,
      'keywords': keywords,
      'details': details,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(0)}%';

  String get triggeredByLabel {
    switch (triggeredBy) {
      case 'ocr':
        return 'Read Text';
      case 'mobilenet':
        return 'Look at Image';
      case 'trustpositif':
        return 'Check URL';
      case 'combined':
        return 'Caught from everywhere';
      default:
        return triggeredBy;
    }
  }

  bool get isHighConfidence => confidence >= 0.8;
}
