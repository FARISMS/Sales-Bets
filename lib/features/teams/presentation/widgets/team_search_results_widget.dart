import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/teams_provider.dart';
import '../../domain/entities/team.dart';
import '../pages/team_profile_page.dart';

class TeamSearchResultsWidget extends StatelessWidget {
  const TeamSearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsProvider>(
      builder: (context, teamsProvider, child) {
        final teams = teamsProvider.filteredTeams;
        
        if (teams.isEmpty) {
          return _buildEmptyState(context, teamsProvider);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            final isFollowing = teamsProvider.isFollowing(team.id);
            final searchQuery = teamsProvider.searchQuery;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      team.logo,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: _buildHighlightedText(
                  team.name,
                  searchQuery,
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedText(
                      team.category,
                      searchQuery,
                      TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${team.followersCount} followers',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.trending_up,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${team.winRate}% win rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (searchQuery.isNotEmpty && 
                        team.description.toLowerCase().contains(searchQuery.toLowerCase()))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: _buildHighlightedText(
                          team.description,
                          searchQuery,
                          TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFollowing ? Icons.favorite : Icons.favorite_border,
                    color: isFollowing ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    teamsProvider.toggleFollow(team.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFollowing
                              ? 'Unfollowed ${team.name}'
                              : 'Following ${team.name}',
                        ),
                        backgroundColor: isFollowing
                            ? Colors.orange
                            : Colors.green,
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TeamProfilePage(teamId: team.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, TeamsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            provider.searchQuery.isNotEmpty
                ? 'No teams found for "${provider.searchQuery}"'
                : 'No teams found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            provider.searchQuery.isNotEmpty
                ? 'Try adjusting your search terms or filters'
                : 'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              provider.clearSearch();
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    TextStyle style, {
    int? maxLines,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    return RichText(
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, index),
            style: style,
          ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: style.copyWith(
              backgroundColor: Colors.yellow.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text.substring(index + query.length),
            style: style,
          ),
        ],
      ),
    );
  }
}
