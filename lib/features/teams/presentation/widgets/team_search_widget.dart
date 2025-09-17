import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/teams_provider.dart';

class TeamSearchWidget extends StatefulWidget {
  const TeamSearchWidget({super.key});

  @override
  State<TeamSearchWidget> createState() => _TeamSearchWidgetState();
}

class _TeamSearchWidgetState extends State<TeamSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsProvider>(
      builder: (context, teamsProvider, child) {
        return Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: teamsProvider.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search teams and athletes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            teamsProvider.clearSearch();
                          },
                        ),
                      IconButton(
                        icon: Icon(
                          _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
              ),
            ),

            // Filters Section
            if (_showFilters) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Filter
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: teamsProvider.categories.map((category) {
                        final isSelected = teamsProvider.selectedCategory == category;
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            teamsProvider.setCategory(category);
                          },
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Sort Options
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildSortChip('name', 'Name', teamsProvider),
                        _buildSortChip('followers', 'Followers', teamsProvider),
                        _buildSortChip('winRate', 'Win Rate', teamsProvider),
                        _buildSortChip('trending', 'Trending', teamsProvider),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Clear Filters Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          teamsProvider.clearSearch();
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All Filters'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Search Results Count
            if (teamsProvider.searchQuery.isNotEmpty || teamsProvider.selectedCategory != 'All')
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${teamsProvider.filteredTeams.length} results found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    if (teamsProvider.searchQuery.isNotEmpty || teamsProvider.selectedCategory != 'All')
                      TextButton(
                        onPressed: () {
                          teamsProvider.clearSearch();
                          _searchController.clear();
                        },
                        child: const Text('Clear'),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSortChip(String value, String label, TeamsProvider provider) {
    final isSelected = provider.sortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        provider.setSortBy(value);
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }
}
