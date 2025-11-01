import '../models/support_ticket.dart';

abstract class SupportRepository {
  Future<List<SupportTicket>> fetchTickets({required String userId});

  Future<SupportTicket> createTicket({
    required String userId,
    required String subject,
    required String message,
  });

  Future<SupportTicket> updateTicketStatus({
    required String ticketId,
    required SupportTicketStatus status,
  });
}
