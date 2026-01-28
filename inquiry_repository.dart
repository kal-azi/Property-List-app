import '../data/property_db.dart';
import '../model/inquiry.dart';

class InquiryRepository {
  final PropertyDb _db;

  InquiryRepository(this._db);

  Future<List<Inquiry>> getInquiriesForProperty(int propertyId) async {
    return _db.getInquiriesForProperty(propertyId);
  }

  Future<Inquiry> createInquiry(int propertyId, String message) async {
    final inquiry = Inquiry(
      propertyId: propertyId,
      message: message,
      createdAt: DateTime.now(),
      status: InquiryStatus.pending,
    );
    final id = await _db.insertInquiry(inquiry);
    return inquiry.copyWith(id: id);
  }

  Future<void> updateInquiryStatus(
    Inquiry inquiry,
    InquiryStatus status,
  ) async {
    await _db.updateInquiry(inquiry.copyWith(status: status));
  }

  Future<List<Inquiry>> getPendingInquiries() async {
    return _db.getPendingInquiries();
  }

  /// Simulates sending inquiries when online
  Future<void> syncPendingInquiries() async {
    final pending = await getPendingInquiries();
    for (final inquiry in pending) {
      // Simulate API call - in real app, this would be an HTTP request
      await Future.delayed(const Duration(milliseconds: 100));
      await updateInquiryStatus(inquiry, InquiryStatus.sent);
    }
  }
}
