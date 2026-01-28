enum InquiryStatus { pending, sent, failed }

class Inquiry {
  final int? id;
  final int propertyId;
  final String message;
  final DateTime createdAt;
  final InquiryStatus status;

  const Inquiry({
    this.id,
    required this.propertyId,
    required this.message,
    required this.createdAt,
    this.status = InquiryStatus.pending,
  });

  Inquiry copyWith({
    int? id,
    int? propertyId,
    String? message,
    DateTime? createdAt,
    InquiryStatus? status,
  }) {
    return Inquiry(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  factory Inquiry.fromMap(Map<String, dynamic> map) {
    return Inquiry(
      id: map['id'] as int?,
      propertyId: map['propertyId'] as int,
      message: map['message'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int,
      ),
      status: InquiryStatus.values[map['status'] as int],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyId': propertyId,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status.index,
    };
  }
}
