import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class FriendsScreen extends StatefulWidget {
  final int initialTabIndex;

  const FriendsScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final Map<String, List<Map<String, String>>> friendData = {
    'Following': [
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile2.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile3.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile4.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile5.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile2.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile3.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile4.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile5.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile2.png'
      },
      // Add more data here...
    ],
    'Followers': [
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile2.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile3.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile4.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile5.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile2.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile3.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile4.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile5.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile2.png'
      },
      // Add more data here...
    ],
    'Suggested': [
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile2.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile3.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile4.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile5.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile2.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile3.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile4.png'
      },
      {
        'name': 'Elanor Pena',
        'username': 'elanpen',
        'image': 'assets/profile/profile5.png'
      },
      {
        'name': 'Devon Lane',
        'username': 'devlan',
        'image': 'assets/profile/profile1.png'
      },
      {
        'name': 'Michaels',
        'username': 'micheels',
        'image': 'assets/profile/profile2.png'
      },
      // Add more data here...
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      body: Column(
        children: [
          SizedBox(height: Window.getVerticalSize(20)),

          // Custom AppBar
          Container(
            padding: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: AppColors.neutral10),
            child: Column(
              children: [
                SizedBox(height: Window.getVerticalSize(10)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.neutral100),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Friends',
                        style: AppTextStyles.heading5Bold
                            .copyWith(color: AppColors.neutral100),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_add_alt_1,
                          color: AppColors.neutral100),
                      onPressed: () {
                        // Add friend functionality
                      },
                    ),
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(10)),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryBlue100,
                  unselectedLabelColor: AppColors.neutral50,
                  indicatorColor: AppColors.primaryBlue100,
                  tabs: const [
                    Tab(text: 'Following'),
                    Tab(text: 'Followers'),
                    Tab(text: 'Suggested'),
                  ],
                ),
              ],
            ),
          ),

          // Search Bar
          SizedBox(height: Window.getVerticalSize(10)),
          Padding(
            padding: Window.getPadding(all: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: AppTextStyles.bodyRegular
                    .copyWith(color: AppColors.neutral50),
                prefixIcon: Icon(Icons.search, color: AppColors.neutral50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Window.getRadiusSize(10)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // TabBarView Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildFriendList(friendData['Following']!, isFollowing: true),
                buildFriendList(friendData['Followers']!, isFollowing: false),
                buildFriendList(friendData['Suggested']!, isFollowing: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFriendList(List<Map<String, String>> friends,
      {required bool isFollowing}) {
    final filteredFriends = friends
        .where((friend) =>
            friend['name']!.toLowerCase().contains(searchQuery) ||
            friend['username']!.toLowerCase().contains(searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredFriends.length,
      itemBuilder: (context, index) {
        final friend = filteredFriends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(friend['image']!),
          ),
          title: Text(
            friend['name']!,
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100),
          ),
          subtitle: Text(
            '@${friend['username']}',
            style: AppTextStyles.captionRegular
                .copyWith(color: AppColors.neutral70),
          ),
          trailing: isFollowing
              ? IconButton(
                  icon:
                      Icon(Icons.mail_outline, color: AppColors.primaryBlue100),
                  onPressed: () {
                    // Handle mailbox icon press
                  },
                )
              : ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue10,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(8)),
                    ),
                  ),
                  child: Text(
                    "Follow",
                    style: AppTextStyles.bodyRegular
                        .copyWith(color: AppColors.primaryBlue100),
                  ),
                ),
        );
      },
    );
  }
}
