import 'package:equatable/equatable.dart';

enum SupportTicketStatus { open, awaitingCustomer, resolved, closed }

enum SupportChannel { email, phone, chat }

class SupportTicket extends Equatable {
  const SupportTicket({
    required this.id,
    required this.reference,
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.status,
    required this.channel,
    this.assignee,
    this.updatedAt,
  });

  final String id;
  final String reference;
  final String subject;
  final String message;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SupportTicketStatus status;
  final SupportChannel channel;
  final String? assignee;

  SupportTicket copyWith({
    SupportTicketStatus? status,
    SupportChannel? channel,
    String? assignee,
    DateTime? updatedAt,
  }) {
    return SupportTicket(
      id: id,
      reference: reference,
      subject: subject,
      message: message,
      createdAt: createdAt,
      status: status ?? this.status,
      channel: channel ?? this.channel,
      assignee: assignee ?? this.assignee,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        reference,
        subject,
        message,
        createdAt,
        updatedAt,
        status,
        channel,
        assignee,
      ];
}
