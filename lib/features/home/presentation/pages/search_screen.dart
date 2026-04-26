import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, String>> _items = [
    {
      "title": "December 5K Run Challenge",
      "subtitle": "Complete a 5K run",
      "dateRange": "Dec 1 - 31",
      "imagePath": 'assets/badges/badge1.png',
    },
    {
      "title": "Jan Climbing Challenge",
      "subtitle": "Complete Climbing Hero Peaks",
      "dateRange": "Jan 1 - 20",
      "imagePath": 'assets/badges/badge2.png',
    },
    {
      "title": "Jan Workout Challenge",
      "subtitle": "Complete Workout",
      "dateRange": "Jan 1 - 10",
      "imagePath": 'assets/badges/badge3.png',
    },
  ];

  List<Map<String, String>> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _items;
    }
    return _items
        .where((item) =>
            item["title"]!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.search,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Search Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.neutral100,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.neutral100,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Search Result Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Search Result",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_filteredItems.length} Found",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Results List
                _filteredItems.isEmpty
                    ? SizedBox(
                        height: Window.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.noResultFound,
                              height: 180,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Sorry, no result found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "What you searched has unfortunately not been found\nor doesn't exist.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: _filteredItems
                            .map((item) => SearchResultCard(
                                  title: item["title"]!,
                                  subtitle: item["subtitle"]!,
                                  dateRange: item["dateRange"]!,
                                  imagePath: item["imagePath"]!,
                                ))
                            .toList(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateRange;
  final String imagePath;

  const SearchResultCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateRange,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Image Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Challenge Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: AppColors.primaryBlue100,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateRange,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral80,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_gymnastics_sharp,
                      size: 16,
                      color: AppColors.primaryBlue100,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
