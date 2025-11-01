import '../../models/support_ticket.dart';
import '../../services/mock_data_service.dart';
import '../support_repository.dart';

class MockSupportRepository implements SupportRepository {
  MockSupportRepository(this._mockDataService);

  final MockDataService _mockDataService;

  @override
  Future<List<SupportTicket>> fetchTickets({required String userId}) async {
    return _mockDataService.tickets;
  }

  @override
  Future<SupportTicket> createTicket({
    required String userId,
    required String subject,
    required String message,
  }) async {
    final ticket = SupportTicket(
      id: 'sup-${DateTime.now().millisecondsSinceEpoch}',
      reference: 'SUP-${_mockDataService.tickets.length + 1000}',
      subject: subject,
      message: message,
      createdAt: DateTime.now(),
      status: SupportTicketStatus.open,
      channel: SupportChannel.email,
    );
    _mockDataService.upsertTicket(ticket);
    return ticket;
  }

  @override
  Future<SupportTicket> updateTicketStatus({
    required String ticketId,
    required SupportTicketStatus status,
  }) async {
    final ticket = _mockDataService.findTicketById(ticketId);
    if (ticket == null) {
      throw StateError('Ticket not found');
    }
    final updated = ticket.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    _mockDataService.upsertTicket(updated);
    return updated;
  }
}
