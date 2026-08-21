import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/call/call_controller.dart';
import '../../../models/chat_model.dart';

import 'call_filter_segment.dart';
import 'call_tile.dart';

/// UPDATED: Streamlined Call History List Screen positioned cleanly directly under the AppBar without blank gaps
class CallListScreen extends StatefulWidget {
  const CallListScreen({super.key});

  @override
  State<CallListScreen> createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  int _selectedFilterIndex = 0; // 0 = All Calls, 1 = Missed Calls

  final List<ChatModel> _callHistory = [
    ChatModel(
      id: '1',
      name: 'John Doe',
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      isMe: false, // isIncoming = true
      unread: 0,   // isMissed = false
      message: 'Today, 10:30 AM',
      dateTime: DateTime.now(),
      type: 'call',
    ),
    ChatModel(
      id: '2',
      name: 'Sarah Connor',
      image: '',
      isMe: true, // isIncoming = false
      unread: 0,  // isMissed = false
      message: 'Today, 08:15 AM',
      dateTime: DateTime.now(),
      type: 'call',
    ),
    ChatModel(
      id: '3',
      name: 'Michael Scott',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      isMe: false, // isIncoming = true
      unread: 1,   // isMissed = true
      message: 'Yesterday, 04:45 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      type: 'call',
    ),
  ];

  List<ChatModel> get _filteredCalls {
    if (_selectedFilterIndex == 1) {
      return _callHistory.where((call) => call.unread > 0).toList();
    }
    return _callHistory;
  }

  void _startCall(ChatModel call, CallType type) {
    // Registers CallController and navigates to active CallScreen
    Get.put(
      CallController(
        name: call.name,
        avatarUrl: call.image,
        callType: type,
      ),
    );
    // Get.to(() => const CallScreen());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final List<ChatModel> calls = _filteredCalls;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 120),
        children: [
          // 1. All / Missed Calls Filter Selector
          CallFilterSegment(
            selectedIndex: _selectedFilterIndex,
            onIndexChanged: (int index) {
              setState(() => _selectedFilterIndex = index);
            },
          ),

          const SizedBox(height: 12),

          // 2. Call Logs List Card or Empty State
          if (calls.isEmpty)
            _buildEmptyState(theme, colorScheme)
          else
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.15 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(calls.length, (index) {
                  ChatModel call = calls[index];
                  bool showDivider = index < calls.length - 1;

                  return Column(
                    children: [
                      CallTile(
                        call: call,
                        onAudioCall: () => _startCall(call, CallType.audio),
                        onVideoCall: () => _startCall(call, CallType.video),
                      ),
                      if (showDivider)
                        Padding(
                          padding: const EdgeInsets.only(left: 68),
                          child: Divider(height: 1, color: borderColor),
                        ),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  /// ADDED: 72x72 circular empty state when no call logs are found
  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.phone,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Recent Calls',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your call history will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}