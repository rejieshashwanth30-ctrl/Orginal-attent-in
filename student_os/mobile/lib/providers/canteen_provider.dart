import 'dart:async';
import 'package:flutter/material.dart';
import '../models/canteen_models.dart';
import '../services/canteen_service.dart';

class CanteenProvider extends ChangeNotifier {
  Canteen? _selectedCanteen;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _onlyVeg = false;

  // Cart state
  final List<CartItem> _cart = [];
  PickupSlot _selectedPickupSlot = CanteenService.pickupSlots.first;
  TimeOfDay _customPickupTime = const TimeOfDay(hour: 12, minute: 30);
  String _specialInstructions = '';
  bool _isPlacingOrder = false;

  // Tracking
  CanteenOrder? _activeTrackingOrder;
  Timer? _simulationTimer;

  CanteenProvider() {
    // Select first canteen by default
    if (CanteenService.canteens.isNotEmpty) {
      _selectedCanteen = CanteenService.canteens.first;
    }
  }

  // Getters
  List<Canteen> get canteens => CanteenService.canteens;
  Canteen? get selectedCanteen => _selectedCanteen ?? (canteens.isNotEmpty ? canteens.first : null);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get onlyVeg => _onlyVeg;

  List<CartItem> get cart => List.unmodifiable(_cart);
  PickupSlot get selectedPickupSlot => _selectedPickupSlot;
  TimeOfDay get customPickupTime => _customPickupTime;
  String get specialInstructions => _specialInstructions;
  bool get isPlacingOrder => _isPlacingOrder;

  CanteenOrder? get activeTrackingOrder => _activeTrackingOrder;
  List<CanteenOrder> get allOrders => CanteenService.orders;
  List<CanteenOrder> get activeOrders => CanteenService.activeOrders;
  List<CanteenOrder> get pastOrders => CanteenService.pastOrders;

  int get cartCount => _cart.fold(0, (sum, i) => sum + i.quantity);
  double get cartSubtotal => _cart.fold(0.0, (sum, i) => sum + i.totalPrice);
  double get cartTax => double.parse((cartSubtotal * 0.05).toStringAsFixed(2));
  double get cartDiscount => cartSubtotal >= 100 ? 15.0 : 0.0;
  double get cartGrandTotal => cartSubtotal + cartTax - cartDiscount;

  // Menu filtering
  List<FoodItem> get filteredMenu {
    if (selectedCanteen == null) return [];
    final allItems = CanteenService.getMenuForCanteen(selectedCanteen!.id);

    return allItems.where((item) {
      // Category filter
      if (_selectedCategory != 'All' && item.category != _selectedCategory) {
        return false;
      }
      // Veg filter
      if (_onlyVeg && !item.isVeg) {
        return false;
      }
      // Search filter
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final nameMatch = item.name.toLowerCase().contains(q);
        final descMatch = item.description.toLowerCase().contains(q);
        final catMatch = item.category.toLowerCase().contains(q);
        final tagMatch = item.tags.any((t) => t.toLowerCase().contains(q));
        if (!nameMatch && !descMatch && !catMatch && !tagMatch) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  int getItemQuantityInCart(String foodItemId) {
    final idx = _cart.indexWhere((i) => i.foodItem.id == foodItemId);
    return idx != -1 ? _cart[idx].quantity : 0;
  }

  // Setters & Actions
  void selectCanteen(Canteen canteen) {
    if (_selectedCanteen?.id != canteen.id) {
      _selectedCanteen = canteen;
      _selectedCategory = 'All';
      _searchQuery = '';
      // If switching canteen with items in cart, keep or notify
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleVegOnly() {
    _onlyVeg = !_onlyVeg;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Cart modifications
  void addToCart(FoodItem item) {
    // If cart has items from different canteen, clear first to avoid mixed kitchen orders
    if (_cart.isNotEmpty && _cart.first.foodItem.canteenId != item.canteenId) {
      _cart.clear();
    }

    final idx = _cart.indexWhere((i) => i.foodItem.id == item.id);
    if (idx != -1) {
      _cart[idx].quantity++;
    } else {
      _cart.add(CartItem(foodItem: item, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(FoodItem item) {
    final idx = _cart.indexWhere((i) => i.foodItem.id == item.id);
    if (idx != -1) {
      if (_cart[idx].quantity > 1) {
        _cart[idx].quantity--;
      } else {
        _cart.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeEntireItem(FoodItem item) {
    _cart.removeWhere((i) => i.foodItem.id == item.id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setPickupSlot(PickupSlot slot) {
    _selectedPickupSlot = slot;
    notifyListeners();
  }

  void setCustomPickupTime(TimeOfDay time) {
    _customPickupTime = time;
    notifyListeners();
  }

  void setSpecialInstructions(String notes) {
    _specialInstructions = notes;
    notifyListeners();
  }

  void setActiveTrackingOrder(CanteenOrder order) {
    _activeTrackingOrder = order;
    notifyListeners();
  }

  Future<CanteenOrder?> placeOrder({
    required String studentName,
    required String studentRollNumber,
    required String studentPhone,
    String paymentMethod = 'Campus Student Pay',
  }) async {
    if (_cart.isEmpty || selectedCanteen == null) return null;

    _isPlacingOrder = true;
    notifyListeners();

    // Simulated short network/prep latency
    await Future.delayed(const Duration(milliseconds: 600));

    // Determine pickup slot details
    PickupSlot finalSlot = _selectedPickupSlot;
    if (_selectedPickupSlot.type == PickupSlotType.customTime) {
      final hourStr = _customPickupTime.hourOfPeriod.toString().padLeft(2, '0');
      final minStr = _customPickupTime.minute.toString().padLeft(2, '0');
      final period = _customPickupTime.period == DayPeriod.am ? 'AM' : 'PM';
      final formatted = '$hourStr:$minStr $period';
      finalSlot = PickupSlot(
        type: PickupSlotType.customTime,
        label: 'Preferred Slot ($formatted)',
        timeRange: formatted,
        description: 'Order prepared for student-selected custom pickup time.',
      );
    }

    final newOrder = CanteenService.createOrder(
      canteen: selectedCanteen!,
      items: _cart,
      pickupSlot: finalSlot,
      studentName: studentName,
      studentRollNumber: studentRollNumber,
      studentPhone: studentPhone,
      paymentMethod: paymentMethod,
      specialInstructions: _specialInstructions,
    );

    _activeTrackingOrder = newOrder;
    _cart.clear();
    _specialInstructions = '';
    _isPlacingOrder = false;

    // Start auto simulation for prototype experience
    _startSimulatedProgression(newOrder.id);

    notifyListeners();
    return newOrder;
  }

  void _startSimulatedProgression(String orderId) {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      final order = allOrders.firstWhere((o) => o.id == orderId, orElse: () => allOrders.first);
      if (order.status == OrderStatus.placed) {
        CanteenService.advanceOrderStatus(orderId);
        notifyListeners();
      } else if (order.status == OrderStatus.preparing) {
        CanteenService.advanceOrderStatus(orderId);
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void advanceOrderStage(String orderId) {
    CanteenService.advanceOrderStatus(orderId);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    CanteenService.cancelOrder(orderId);
    notifyListeners();
  }

  void reorder(CanteenOrder pastOrder) {
    final canteen = CanteenService.getCanteenById(pastOrder.canteenId);
    if (canteen != null) {
      _selectedCanteen = canteen;
      _cart.clear();
      for (var item in pastOrder.items) {
        _cart.add(CartItem(foodItem: item.foodItem, quantity: item.quantity));
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
