/// Connection status of the child's phone
enum ConnectionStatus {
  /// Connected — service is active and sending heartbeats
  online,

  /// Disconnected because the internet/connection is down
  offlineInternet,

  /// Disconnected because the child turned off the service on purpose
  offlineManual,
}

class Child {
  final String id;
  final String parentId;
  final String childName;
  final int age;
  final String? phone;
  final String? avatarUrl;
  final DateTime createdAt;
  final ConnectionStatus connectionStatus;
  final DateTime? lastSeen;

  /// If set and > now(), monitoring is paused temporarily by the parent.
  final DateTime? pausedUntil;

  Child({
    required this.id,
    required this.parentId,
    required this.childName,
    required this.age,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
    this.connectionStatus = ConnectionStatus.online,
    this.lastSeen,
    this.pausedUntil,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as String,
      parentId: json['parent_id'] as String,
      childName: json['child_name'] as String,
      age: json['age'] as int,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      connectionStatus: _parseStatus(json['connection_status'] as String?),
      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'] as String)
          : null,
      pausedUntil: json['paused_until'] != null
          ? DateTime.tryParse(json['paused_until'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'child_name': childName,
      'age': age,
      'phone': phone,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'connection_status': connectionStatus.name,
      'last_seen': lastSeen?.toIso8601String(),
      'paused_until': pausedUntil?.toIso8601String(),
    };
  }

  /// True if monitoring is currently paused by the parent.
  bool get isPaused =>
      pausedUntil != null && pausedUntil!.isAfter(DateTime.now().toUtc());

  /// Parse string from the DB to enum, defaults to online if null
  static ConnectionStatus _parseStatus(String? raw) {
    switch (raw) {
      case 'offline_internet':
        return ConnectionStatus.offlineInternet;
      case 'offline_manual':
        return ConnectionStatus.offlineManual;
      case 'online':
        return ConnectionStatus.online;
      default:
        return ConnectionStatus.online;
    }
  }

  // ─── Computed helpers ─────────────────────────────────
  String get firstName => childName.split(' ').first;
  String get greeting => "Hey, this is $childName's phone 👋";

  /// Effective status — if the DB says online but the heartbeat is stale
  /// (>2 minutes) or never existed, treat it as disconnected
  ConnectionStatus get effectiveStatus {
    if (connectionStatus == ConnectionStatus.online) {
      // Never sent a heartbeat — old/stale data
      if (lastSeen == null) {
        return ConnectionStatus.offlineManual;
      }
      // Heartbeat stale > 10 minutes — internet is likely down
      // (use a longer window to avoid false positives on freshly paired devices)
      final staleness = DateTime.now().toUtc().difference(lastSeen!);
      if (staleness.inMinutes >= 10) {
        return ConnectionStatus.offlineInternet;
      }
    }
    return connectionStatus;
  }

  bool get isOnline => effectiveStatus == ConnectionStatus.online;

  String get connectionLabel {
    switch (effectiveStatus) {
      case ConnectionStatus.online:
        return 'Connected';
      case ConnectionStatus.offlineInternet:
        return 'Offline';
      case ConnectionStatus.offlineManual:
        return 'Paused';
    }
  }

  String get connectionDescription {
    switch (effectiveStatus) {
      case ConnectionStatus.online:
        return "The child's phone is connected and being monitored by Nazar.Ai";
      case ConnectionStatus.offlineInternet:
        return "The child's internet connection is down. Nazar.Ai can't monitor until the internet is stable again";
      case ConnectionStatus.offlineManual:
        return 'The child turned off the Nazar.Ai service manually. Contact your child to turn it back on';
    }
  }

  /// "Last seen X minutes/hours/days ago" text
  String get lastSeenText {
    if (lastSeen == null) return 'Unknown';
    final diff = DateTime.now().difference(lastSeen!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  /// Copy-with helper for updating status.
  /// `clearPausedUntil: true` sets pausedUntil to null (on resume),
  /// because a plain `pausedUntil: null` can't be distinguished from "not changed".
  Child copyWith({
    String? childName,
    int? age,
    String? phone,
    String? avatarUrl,
    ConnectionStatus? connectionStatus,
    DateTime? lastSeen,
    DateTime? pausedUntil,
    bool clearPausedUntil = false,
  }) {
    return Child(
      id: id,
      parentId: parentId,
      childName: childName ?? this.childName,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      lastSeen: lastSeen ?? this.lastSeen,
      pausedUntil: clearPausedUntil ? null : (pausedUntil ?? this.pausedUntil),
    );
  }
}
