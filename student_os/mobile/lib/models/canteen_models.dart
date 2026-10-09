import 'package:flutter/material.dart';

enum OrderStatus {
  placed,
  preparing,
  readyForPickup,
  collected,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing Food';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.collected:
        return 'Collected';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.placed:
        return 'Your pre-order has been received by the kitchen';
      case OrderStatus.preparing:
        return 'Chef is actively cooking & packing your meal';
      case OrderStatus.readyForPickup:
        return 'Your hot meal is waiting at the express pickup counter';
      case OrderStatus.collected:
        return 'Order completed and handed over';
      case OrderStatus.cancelled:
        return 'This order was cancelled';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.readyForPickup:
        return 2;
      case OrderStatus.collected:
        return 3;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

enum PickupSlotType {
  upcomingBreak,
  lunchBreak,
  customTime;

  String get title {
    switch (this) {
      case PickupSlotType.upcomingBreak:
        return 'Upcoming Break';
      case PickupSlotType.lunchBreak:
        return 'Lunch Break';
      case PickupSlotType.customTime:
        return 'Custom Time';
    }
  }

  IconData get icon {
    switch (this) {
      case PickupSlotType.upcomingBreak:
        return Icons.coffee_rounded;
      case PickupSlotType.lunchBreak:
        return Icons.lunch_dining_rounded;
      case PickupSlotType.customTime:
        return Icons.schedule_rounded;
    }
  }
}

class PickupSlot {
  final PickupSlotType type;
  final String label;
  final String timeRange;
  final String description;

  const PickupSlot({
    required this.type,
    required this.label,
    required this.timeRange,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'label': label,
        'timeRange': timeRange,
        'description': description,
      };

  factory PickupSlot.fromJson(Map<String, dynamic> json) {
    return PickupSlot(
      type: PickupSlotType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PickupSlotType.upcomingBreak,
      ),
      label: json['label'] ?? '',
      timeRange: json['timeRange'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class FoodItem {
  final String id;
  final String canteenId;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final bool isVeg;
  final String category;
  final String emoji;
  final bool isAvailable;
  final bool isBestSeller;
  final int prepTimeMinutes;
  final int calories;
  final double rating;
  final int reviewCount;
  final List<String> tags;

  const FoodItem({
    required this.id,
    required this.canteenId,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.isVeg,
    required this.category,
    required this.emoji,
    this.isAvailable = true,
    this.isBestSeller = false,
    this.prepTimeMinutes = 10,
    this.calories = 250,
    this.rating = 4.5,
    this.reviewCount = 50,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'canteenId': canteenId,
        'name': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'isVeg': isVeg,
        'category': category,
        'emoji': emoji,
        'isAvailable': isAvailable,
        'isBestSeller': isBestSeller,
        'prepTimeMinutes': prepTimeMinutes,
        'calories': calories,
        'rating': rating,
        'reviewCount': reviewCount,
        'tags': tags,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '',
      canteenId: json['canteenId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      isVeg: json['isVeg'] ?? true,
      category: json['category'] ?? '',
      emoji: json['emoji'] ?? '🍽️',
      isAvailable: json['isAvailable'] ?? true,
      isBestSeller: json['isBestSeller'] ?? false,
      prepTimeMinutes: json['prepTimeMinutes'] ?? 10,
      calories: json['calories'] ?? 200,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: json['reviewCount'] ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class CartItem {
  final FoodItem foodItem;
  int quantity;
  String? customizationNote;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    this.customizationNote,
  });

  double get totalPrice => foodItem.price * quantity;

  Map<String, dynamic> toJson() => {
        'foodItem': foodItem.toJson(),
        'quantity': quantity,
        'customizationNote': customizationNote,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'] ?? 1,
      customizationNote: json['customizationNote'],
    );
  }
}

class Canteen {
  final String id;
  final String name;
  final String code;
  final String subtitle;
  final String description;
  final String location;
  final String counterInfo;
  final double rating;
  final int totalReviews;
  final String operatingHours;
  final int averagePrepMinutes;
  final bool isOpen;
  final String emoji;
  final Color themeColor;
  final String bannerGradientStart;
  final String bannerGradientEnd;
  final List<String> categories;
  final List<String> highlights;

  const Canteen({
    required this.id,
    required this.name,
    required this.code,
    required this.subtitle,
    required this.description,
    required this.location,
    required this.counterInfo,
    required this.rating,
    required this.totalReviews,
    required this.operatingHours,
    required this.averagePrepMinutes,
    this.isOpen = true,
    required this.emoji,
    required this.themeColor,
    required this.bannerGradientStart,
    required this.bannerGradientEnd,
    required this.categories,
    required this.highlights,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'subtitle': subtitle,
        'description': description,
        'location': location,
        'counterInfo': counterInfo,
        'rating': rating,
        'totalReviews': totalReviews,
        'operatingHours': operatingHours,
        'averagePrepMinutes': averagePrepMinutes,
        'isOpen': isOpen,
        'emoji': emoji,
        'themeColor': themeColor.value,
        'categories': categories,
        'highlights': highlights,
      };
}

class CanteenOrder {
  final String id;
  final String orderNumber;
  final String tokenNumber;
  final String canteenId;
  final String canteenName;
  final String canteenLocation;
  final String counterInfo;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double totalAmount;
  final PickupSlot pickupSlot;
  OrderStatus status;
  final DateTime orderedAt;
  final DateTime estimatedReadyTime;
  final String studentName;
  final String studentRollNumber;
  final String studentPhone;
  final String paymentMethod;
  final String paymentStatus;
  final String specialInstructions;

  CanteenOrder({
    required this.id,
    required this.orderNumber,
    required this.tokenNumber,
    required this.canteenId,
    required this.canteenName,
    required this.canteenLocation,
    required this.counterInfo,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.pickupSlot,
    required this.status,
    required this.orderedAt,
    required this.estimatedReadyTime,
    required this.studentName,
    required this.studentRollNumber,
    required this.studentPhone,
    this.paymentMethod = 'Campus Student Pay',
    this.paymentStatus = 'Paid (Demo Verified)',
    this.specialInstructions = '',
  });

  int get totalItemsCount => items.fold(0, (sum, i) => sum + i.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderNumber': orderNumber,
        'tokenNumber': tokenNumber,
        'canteenId': canteenId,
        'canteenName': canteenName,
        'canteenLocation': canteenLocation,
        'counterInfo': counterInfo,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'discount': discount,
        'totalAmount': totalAmount,
        'pickupSlot': pickupSlot.toJson(),
        'status': status.name,
        'orderedAt': orderedAt.toIso8601String(),
        'estimatedReadyTime': estimatedReadyTime.toIso8601String(),
        'studentName': studentName,
        'studentRollNumber': studentRollNumber,
        'studentPhone': studentPhone,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'specialInstructions': specialInstructions,
      };
}
