import 'package:flutter/material.dart';
import '../../../../models/device_session_model.dart';
import '../../settings/device/device_session_title.dart';
import 'device_action.dart';
import 'device_section.dart';

class DevicesContent extends StatelessWidget {
  final DeviceSessionModel? currentSession;
  final List<DeviceSessionModel> otherSessions;
  final bool isTerminatingAll;

  final Future<void> Function() onRefresh;

  final Future<void> Function(
      DeviceSessionModel session,
      ) onTerminate;

  final Future<void> Function() onTerminateAll;

  DevicesContent({
    super.key,
    required this.currentSession,
    required this.otherSessions,
    required this.isTerminatingAll,
    required this.onRefresh,
    required this.onTerminate,
    required this.onTerminateAll,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark =
        theme.brightness == Brightness.dark;

    return RefreshIndicator(
      color: colorScheme.primary,
      backgroundColor: isDark
          ? Color(0xFF1B1D22)
          : Colors.white,
      onRefresh: onRefresh,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          32,
        ),
        children: [
          DevicesSecurityHeader(),
          SizedBox(height: 24),

          DevicesSectionHeader(
            title: 'This device',
            icon: Icons.smartphone_rounded,
          ),
          SizedBox(height: 10),

          if (currentSession != null)
            DeviceSessionTile(
              session: currentSession!,
            )
          else
            EmptyCurrentDeviceCard(),

          SizedBox(height: 26),

          DevicesSectionHeader(
            title: 'Active sessions',
            icon: Icons.devices_rounded,
            count: otherSessions.length,
          ),
          SizedBox(height: 10),

          if (otherSessions.isEmpty)
            NoOtherSessionsCard()
          else
            ..._buildOtherSessions(),

          if (otherSessions.isNotEmpty) ...[
            SizedBox(height: 8),
            TerminateAllSessionsButton(
              isLoading: isTerminatingAll,
              onPressed: () {
                onTerminateAll();
              },
            ),
          ],

          SizedBox(height: 22),
          DevicesSecurityNote(),
        ],
      ),
    );
  }

  List<Widget> _buildOtherSessions() {
    return otherSessions.map(
          (DeviceSessionModel session) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: DeviceSessionTile(
            session: session,
            onTerminate: () {
              onTerminate(session);
            },
          ),
        );
      },
    ).toList();
  }
}