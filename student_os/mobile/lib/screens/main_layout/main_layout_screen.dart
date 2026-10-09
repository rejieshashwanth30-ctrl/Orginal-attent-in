import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../home/home_screen.dart';
import '../more/more_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/ai_floating_dock.dart';
import 'widgets/ai_quick_actions_menu.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;

  const MainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),         // 0: HOME
    MoreScreen(),         // 1: EXPLORE (Ecosystem modules & explorer)
    AIAssistantScreen(),  // 2: AI CORE
    AIAssistantScreen(),  // 3: CHATS
    ProfileScreen(),      // 4: PROFILE
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _handleAICoreTapped() {
    setState(() => _currentIndex = 2);
    AIQuickActionsMenu.show(
      context,
      onSelectTab: (idx) => setState(() => _currentIndex = idx),
    );
  }

  void _openAIQuickMenu() {
    AIQuickActionsMenu.show(
      context,
      onSelectTab: (idx) => setState(() => _currentIndex = idx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final safeBottom = bottomInset > 0 ? bottomInset + 8 : 16.0;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 1. Main scrollable content layers
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),

            // 2. Floating Bottom Navigation Dock
            if (!isKeyboardOpen)
              Positioned(
                left: 0,
                right: 0,
                bottom: safeBottom,
                child: AIFloatingDock(
                  currentIndex: _currentIndex,
                  onTabSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  onAICoreTapped: _handleAICoreTapped,
                  onAICoreLongPress: _openAIQuickMenu,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
