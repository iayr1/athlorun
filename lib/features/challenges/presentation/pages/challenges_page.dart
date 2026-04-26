import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/challenges/presentation/widgets/all_challenges_widget.dart';
import 'package:athlorun/features/challenges/presentation/widgets/challenge_join_card_widget.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ChallengesPageWrapper extends StatelessWidget {
  const ChallengesPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: const ChallengesPage(),
    );
  }
}

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isSearching = false;
  // Create a list of ChallengeJoinCardWidget
  List<Widget> challengeCards = [
    ChallengeJoinCardWidget(
      title: 'End Jan 160 KM Challenge',
      description:
          'Complete 150 KM until end of Jan 2024 and you will get surprise gift',
      buttonText: 'Join Challenge',
      backgroundColor: Color(0xFF4A90E2),
      onPressed: () {
        // handle join logic
      },
    ),
    ChallengeJoinCardWidget(
      title: 'Feb 100 KM Challenge',
      description:
          'Complete 100 KM by the end of Feb 2024 for a special prize!',
      buttonText: 'Join Challenge',
      backgroundColor: const Color(0xFF50E3C2),
      onPressed: () {
        // handle join logic
      },
    ),
    ChallengeJoinCardWidget(
      title: 'March 50 KM Challenge',
      description:
          'Complete 50 KM by the end of March 2024 and win a gift voucher.',
      buttonText: 'Join Challenge',
      backgroundColor: const Color(0xFF9013FE),
      onPressed: () {
        // handle join logic
      },
    ),
    ChallengeJoinCardWidget(
      title: 'April 200 KM Challenge',
      description:
          'Complete 200 KM by the end of April 2024 and become a champion!',
      buttonText: 'Join Challenge',
      backgroundColor: const Color(0xFF50E3C2),
      onPressed: () {
        // handle join logic
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        backgroundColor: AppColors.neutral10,
        title: isSearching ? '' : AppStrings.challenges,
        onBackPressed: null,
        titleWidget: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: AppStrings.searchCallenges,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.neutral100,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Window.getRadiusSize(
                        10,
                      ),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Window.getVerticalSize(
                      10,
                    ),
                  ),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral100,
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: AppColors.neutral100,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  searchQuery = '';
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: Window.getVerticalSize(
              //     10,
              //   ),
              // ),
              // const TabbarChallengeWidget(),
              // SizedBox(
              //   height: Window.getVerticalSize(
              //     10,
              //   ),
              // ),

              if (!isSearching)
                Padding(
                  padding: Window.getSymmetricPadding(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.challengeFeature,
                        style: AppTextStyles.subtitleMedium.copyWith(
                            color: AppColors.neutral100), // Custom text style
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See all",
                          style: AppTextStyles.bodySemiBold.copyWith(
                              color:
                                  AppColors.primaryBlue90), // Custom text style
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: Window.getVerticalSize(10),
              ),

              Padding(
                padding: Window.getSymmetricPadding(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: challengeCards),
                ),
              ),

              SizedBox(
                height: Window.getVerticalSize(10),
              ),

              Padding(
                padding: Window.getSymmetricPadding(horizontal: 16.0),
                child: Text(
                  AppStrings.allchallenges,
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: Window.getFontSize(18),
                    color: AppColors.neutral100,
                  ),
                ),
              ),
              SizedBox(
                height: Window.getVerticalSize(8),
              ),

              AllChallengesWidgetWrapper(
                searchQuery: searchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
