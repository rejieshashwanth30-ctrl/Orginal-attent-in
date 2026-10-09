import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:student_os/models/canteen_models.dart';
import 'package:student_os/providers/auth_provider.dart';
import 'package:student_os/providers/canteen_provider.dart';
import 'package:student_os/providers/theme_provider.dart';
import 'package:student_os/screens/canteen/canteen_list_screen.dart';
import 'package:student_os/screens/canteen/canteen_menu_screen.dart';
import 'package:student_os/screens/canteen/canteen_cart_screen.dart';
import 'package:student_os/screens/canteen/canteen_order_tracking_screen.dart';
import 'package:student_os/services/canteen_service.dart';

void main() {
  group('Campus Canteen Service & Data Tests', () {
    test('Contains exactly the 4 required campus canteens', () {
      final canteens = CanteenService.canteens;
      expect(canteens.length, equals(4));

      final names = canteens.map((c) => c.name).toList();
      expect(names.contains('C5 Canteen'), isTrue);
      expect(names.contains('C6 Canteen'), isTrue);
      expect(names.contains('Foodjack'), isTrue);
      expect(names.contains('Saibites'), isTrue);
    });

    test('Each canteen has multi-category menus and valid food items', () {
      for (var canteen in CanteenService.canteens) {
        final menu = CanteenService.getMenuForCanteen(canteen.id);
        expect(menu.isNotEmpty, isTrue, reason: '${canteen.name} menu should not be empty');

        for (var item in menu) {
          expect(item.price, greaterThan(0));
          expect(item.name.isNotEmpty, isTrue);
          expect(item.emoji.isNotEmpty, isTrue);
          expect(item.canteenId, equals(canteen.id));
        }
      }
    });

    test('Pickup slots include Upcoming Break, Lunch Break, and Custom Time', () {
      final slots = CanteenService.pickupSlots;
      expect(slots.length, equals(3));
      expect(slots.any((s) => s.type == PickupSlotType.upcomingBreak), isTrue);
      expect(slots.any((s) => s.type == PickupSlotType.lunchBreak), isTrue);
      expect(slots.any((s) => s.type == PickupSlotType.customTime), isTrue);
    });
  });

  group('CanteenProvider & Cart Operations Tests', () {
    test('Adds and removes items in cart with exact price calculations', () {
      final provider = CanteenProvider();
      final c5 = CanteenService.canteens.first;
      provider.selectCanteen(c5);

      final menu = CanteenService.getMenuForCanteen(c5.id);
      final item1 = menu[0]; // e.g. Masala Dosa
      final item2 = menu[1]; // e.g. Idli Vada

      expect(provider.cartCount, equals(0));
      expect(provider.cartSubtotal, equals(0.0));

      // Add item1
      provider.addToCart(item1);
      expect(provider.cartCount, equals(1));
      expect(provider.getItemQuantityInCart(item1.id), equals(1));
      expect(provider.cartSubtotal, equals(item1.price));

      // Increment item1
      provider.addToCart(item1);
      expect(provider.cartCount, equals(2));
      expect(provider.getItemQuantityInCart(item1.id), equals(2));

      // Add item2
      provider.addToCart(item2);
      expect(provider.cartCount, equals(3));
      expect(provider.cartSubtotal, equals(item1.price * 2 + item2.price));

      // Decrement item1
      provider.removeFromCart(item1);
      expect(provider.cartCount, equals(2));
      expect(provider.getItemQuantityInCart(item1.id), equals(1));

      // Clear cart
      provider.clearCart();
      expect(provider.cartCount, equals(0));
      expect(provider.cart.isEmpty, isTrue);
    });

    test('Calculates taxes and student subsidy discounts correctly', () {
      final provider = CanteenProvider();
      final fj = CanteenService.canteens.firstWhere((c) => c.code == 'FJ');
      provider.selectCanteen(fj);

      final combo = CanteenService.getMenuForCanteen(fj.id).firstWhere((i) => i.category == 'Combos');
      provider.addToCart(combo); // Price >= 100

      expect(provider.cartSubtotal, equals(combo.price));
      expect(provider.cartTax, equals(double.parse((combo.price * 0.05).toStringAsFixed(2))));
      expect(provider.cartDiscount, equals(15.0)); // Subsidy discount active for >= 100
      expect(provider.cartGrandTotal, equals(provider.cartSubtotal + provider.cartTax - provider.cartDiscount));
    });

    test('Places pre-order and generates token and order tracking entry', () async {
      final provider = CanteenProvider();
      final c6 = CanteenService.canteens.firstWhere((c) => c.code == 'C6');
      provider.selectCanteen(c6);

      final menu = CanteenService.getMenuForCanteen(c6.id);
      provider.addToCart(menu.first);

      // Select lunch break slot
      final lunchSlot = CanteenService.pickupSlots.firstWhere((s) => s.type == PickupSlotType.lunchBreak);
      provider.setPickupSlot(lunchSlot);
      provider.setSpecialInstructions('Pack separately please');

      final order = await provider.placeOrder(
        studentName: 'Aarav Sharma',
        studentRollNumber: '21BCSE088',
        studentPhone: '+91 98765 43210',
      );

      expect(order, isNotNull);
      expect(order!.canteenName, equals('C6 Canteen'));
      expect(order.tokenNumber.startsWith('C6-'), isTrue);
      expect(order.pickupSlot.type, equals(PickupSlotType.lunchBreak));
      expect(order.specialInstructions, equals('Pack separately please'));
      expect(order.status, equals(OrderStatus.placed));
      expect(provider.cart.isEmpty, isTrue);
    });

    test('Order status advances correctly through all 4 stages', () {
      final order = CanteenService.createOrder(
        canteen: CanteenService.canteens.first,
        items: [CartItem(foodItem: CanteenService.getMenuForCanteen(CanteenService.canteens.first.id).first, quantity: 1)],
        pickupSlot: CanteenService.pickupSlots.first,
        studentName: 'Test Student',
        studentRollNumber: '21B001',
        studentPhone: '+91 90000 00000',
      );

      expect(order.status, equals(OrderStatus.placed));
      expect(order.status.stepIndex, equals(0));

      CanteenService.advanceOrderStatus(order.id);
      expect(order.status, equals(OrderStatus.preparing));
      expect(order.status.stepIndex, equals(1));

      CanteenService.advanceOrderStatus(order.id);
      expect(order.status, equals(OrderStatus.readyForPickup));
      expect(order.status.stepIndex, equals(2));

      CanteenService.advanceOrderStatus(order.id);
      expect(order.status, equals(OrderStatus.collected));
      expect(order.status.stepIndex, equals(3));
    });
  });

  group('Campus Canteen Widget Rendering Tests', () {
    testWidgets('Renders CanteenListScreen with all 4 campus canteens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1400));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => CanteenProvider()),
          ],
          child: const MaterialApp(
            home: CanteenListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Campus Canteens'), findsOneWidget);
      expect(find.text('C5 Canteen'), findsOneWidget);
      expect(find.text('C6 Canteen'), findsOneWidget);
      expect(find.text('Foodjack'), findsOneWidget);
      expect(find.text('Saibites'), findsOneWidget);
      expect(find.text('Pre-Order for Break & Lunch'), findsOneWidget);
    });

    testWidgets('Renders CanteenMenuScreen with category filters and items', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));

      final canteenProvider = CanteenProvider();
      canteenProvider.selectCanteen(CanteenService.canteens.first);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider.value(value: canteenProvider),
          ],
          child: const MaterialApp(
            home: CanteenMenuScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('C5 Canteen'), findsOneWidget);
      expect(find.text('Breakfast'), findsWidgets);
      expect(find.text('ADD'), findsWidgets);
    });

    testWidgets('Renders CanteenOrderTrackingScreen with 4-stage timeline', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));

      final canteenProvider = CanteenProvider();
      final order = CanteenService.orders.first;
      canteenProvider.setActiveTrackingOrder(order);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider.value(value: canteenProvider),
          ],
          child: const MaterialApp(
            home: CanteenOrderTrackingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Live Order Tracking'), findsOneWidget);
      expect(find.text('LIVE STATUS TRACKER'), findsOneWidget);
      expect(find.text('Order Placed'), findsOneWidget);
      expect(find.text('Preparing'), findsOneWidget);
      expect(find.text('Ready for Pickup'), findsOneWidget);
      expect(find.text('Collected'), findsOneWidget);
    });
  });
}
