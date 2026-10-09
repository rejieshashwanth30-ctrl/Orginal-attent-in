import 'package:flutter/material.dart';
import '../models/transport_models.dart';
import '../services/transport_service.dart';

class TransportAssistantMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  TransportAssistantMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class TransportProvider extends ChangeNotifier {
  TransportRoute? _selectedRoute;
  TransportSearchResult? _searchResult;
  String _searchQuery = '';
  bool _isAssistantLoading = false;

  final List<TransportAssistantMessage> _chatHistory = [
    TransportAssistantMessage(
      text: 'Hello! I am your ATTENT-IN Campus Transport Assistant 🚍. Ask me about shuttle routes, timings, or how to reach any building on campus.',
      isUser: false,
    ),
  ];

  TransportRoute get activeRoute => _selectedRoute ?? TransportService.routes.first;
  List<TransportRoute> get allRoutes => TransportService.routes;
  TransportSearchResult? get searchResult => _searchResult;
  String get searchQuery => _searchQuery;
  List<TransportAssistantMessage> get chatHistory => List.unmodifiable(_chatHistory);
  bool get isAssistantLoading => _isAssistantLoading;

  void selectRoute(TransportRoute route) {
    _selectedRoute = route;
    notifyListeners();
  }

  void searchDestination(String query) {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResult = null;
    } else {
      _searchResult = TransportService.searchDestination(query);
    }
    notifyListeners();
  }

  Future<void> sendAssistantMessage(String message) async {
    if (message.trim().isEmpty) return;

    _chatHistory.add(TransportAssistantMessage(text: message, isUser: true));
    _isAssistantLoading = true;
    notifyListeners();

    try {
      final reply = await TransportService.askTransportAssistant(message);
      _chatHistory.add(TransportAssistantMessage(text: reply, isUser: false));
    } catch (e) {
      _chatHistory.add(TransportAssistantMessage(
        text: 'Sorry, I could not retrieve route details right now. Please try again.',
        isUser: false,
      ));
    } finally {
      _isAssistantLoading = false;
      notifyListeners();
    }
  }

  void clearAssistantChat() {
    _chatHistory.clear();
    _chatHistory.add(TransportAssistantMessage(
      text: 'Chat history cleared. How can I help you with campus transport today?',
      isUser: false,
    ));
    notifyListeners();
  }
}
