import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/device_session_model.dart';
import '../../settings/device/device_session_title.dart';
import 'session_comfirmation_dialog.dart';
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

  Future<void> _terminateSession(
      BuildContext context,
      DeviceSessionModel session,
      ) async {
    bool confirmed =
    await SessionConfirmationDialog.showTerminateSession(
      context: context,
      deviceName: session.deviceName,
    );

    if (!confirmed) {
      return;
    }

    await onTerminate(session);
  }

  Future<void> _terminateAllSessions(
      BuildContext context,
      ) async {
    bool confirmed =
    await SessionConfirmationDialog.showTerminateAllSessions(
      context: context,
    );

    if (!confirmed) {
      return;
    }

    await onTerminateAll();
  }

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
            title: 'this_device'.tr,
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
            title: 'active_sessions'.tr,
            icon: Icons.devices_rounded,
            count: otherSessions.length,
          ),

          SizedBox(height: 10),

          if (otherSessions.isEmpty)
            NoOtherSessionsCard()
          else
            ..._buildOtherSessions(context),

          if (otherSessions.isNotEmpty) ...[
            SizedBox(height: 8),

            TerminateAllSessionsButton(
              isLoading: isTerminatingAll,
              onPressed: () {
                _terminateAllSessions(context);
              },
            ),
          ],

          SizedBox(height: 22),

          DevicesSecurityNote(),
        ],
      ),
    );
  }

  List<Widget> _buildOtherSessions(
      BuildContext context,
      ) {
    return otherSessions.map(
          (DeviceSessionModel session) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: DeviceSessionTile(
            session: session,
            onTerminate: () {
              _terminateSession(
                context,
                session,
              );
            },
          ),
        );
      },
    ).toList();
  }
}