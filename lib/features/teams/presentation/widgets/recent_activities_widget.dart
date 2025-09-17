import 'package:flutter/material.dart';
import '../../domain/entities/team.dart';

class RecentActivitiesWidget extends StatelessWidget {
  final Team team;

  const RecentActivitiesWidget({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...team.recentActivities.map(
              (activity) => _buildActivityItem(context, activity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, RecentActivity activity) {
    IconData icon;
    Color iconColor;

    switch (activity.type) {
      case ActivityType.challengeStarted:
        icon = Icons.play_circle_outline;
        iconColor = Colors.blue;
        break;
      case ActivityType.challengeCompleted:
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case ActivityType.milestoneReached:
        icon = Icons.flag_outlined;
        iconColor = Colors.orange;
        break;
      case ActivityType.newMember:
        icon = Icons.person_add_outlined;
        iconColor = Colors.purple;
        break;
      case ActivityType.announcement:
        icon = Icons.campaign_outlined;
        iconColor = Colors.red;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
