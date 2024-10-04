import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot_host_onboarding/widgets/app_gradient.dart';

import '../providers/experience_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/experience_card.dart';
import '../widgets/wave_background_painter.dart';
import '../widgets/wavy_progress_bar.dart'; // Import the Wavy Progress Bar
import 'onboarding_question_screen.dart';

class ExperienceSelectionScreen extends ConsumerStatefulWidget {
  @override
  _ExperienceSelectionScreenState createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState
    extends ConsumerState<ExperienceSelectionScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen for focus events on the text field
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Scroll to the bottom when the keyboard appears
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Override to detect keyboard visibility changes
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (_isKeyboardVisible != newValue) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
      if (!_isKeyboardVisible) {
        // Unfocus the text field when the keyboard disappears
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final experiencesAsyncValue = ref.watch(experiencesProvider);
    final selectedIds = ref.watch(selectedExperienceIdsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent automatic resizing
      appBar: AppBar(
        backgroundColor: AppColors.effectBgBlur80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text1),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.text1),
            onPressed: () {},
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            height: 20,
            child: WavyProgressBar(progress: 0.5), // Example progress (50%)
          ),
        ),
      ),
      body: Stack(
        children: [
          // Add the wave background as the bottom-most layer
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: WaveBackgroundPainter(), // Use the wave background painter
          ),
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Adjust top padding based on keyboard visibility
                SizedBox(height: _isKeyboardVisible ? 16 : 270),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "01" Text
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 16, right: 16),
                        child: Text(
                          "01",
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppColors.text4,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0, left: 16, right: 16),
                        child: Text(
                          "What kind of experiences do you want to host?",
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.text1,
                            letterSpacing: 0.2,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      // Experience cards with horizontal scrolling
                      SizedBox(
                        height: 140,
                        child: experiencesAsyncValue.when(
                          data: (experiences) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: experiences.length,
                                itemBuilder: (context, index) {
                                  final experience = experiences[index];
                                  final isSelected =
                                      selectedIds.contains(experience.id);
                                  return ExperienceCard(
                                    experience: experience,
                                    isSelected: isSelected,
                                    onTap: () {
                                      final ids = [...selectedIds];
                                      if (isSelected) {
                                        ids.remove(experience.id);
                                      } else {
                                        ids.add(experience.id);
                                      }
                                      ref
                                          .read(selectedExperienceIdsProvider
                                              .notifier)
                                          .state = ids;
                                    },
                                    index: index,
                                  );
                                },
                              ),
                            );
                          },
                          loading: () =>
                              Center(child: CircularProgressIndicator()),
                          error: (err, stack) =>
                              Center(child: Text('Error: $err')),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Multi-line TextField
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          height:
                              _isKeyboardVisible ? 100 : 160, // Adjust height
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite2,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: _isKeyboardVisible
                                  ? AppColors
                                      .primaryAccent // Change border color
                                  : AppColors.border1,
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            focusNode: _focusNode, // Attach FocusNode
                            maxLines: null,
                            style: AppTextStyles.bodyText
                                .copyWith(color: AppColors.text2),
                            decoration: InputDecoration(
                              hintText: '/ Describe your perfect hotspot',
                              hintStyle: AppTextStyles.bodyText
                                  .copyWith(color: AppColors.text3),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                            onChanged: (value) => ref
                                .read(experienceTextProvider.notifier)
                                .state = value,
                            cursorColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Next Button
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: selectedIds.isNotEmpty
                                  ? AppGradients.backgroundBlur
                                  : null),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  12), // Same border radius
                              gradient: RadialGradient(
                                colors: selectedIds.isNotEmpty
                                    ? [
                                        Colors.white.withOpacity(0.2),
                                        Colors.black.withOpacity(0.1)
                                      ] // Higher opacity for active state
                                    : [
                                        Colors.white.withOpacity(0),
                                        Colors.black.withOpacity(0)
                                      ], // Lower opacity for inactive state
                                radius:
                                    5, // Adjust this for how spread out you want the gradient
                                center: Alignment
                                    .center, // Centered circular gradient
                              ),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors
                                    .transparent, // Transparent background for both active and inactive states
                                onPrimary: AppColors.text1, // Text color
                                minimumSize: Size(double.infinity,
                                    56), // Full-width and 56 height
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Keep border radius as it is
                                  side: BorderSide(
                                    color: selectedIds.isNotEmpty
                                        ? AppColors
                                            .border3 // Active state border color
                                        : AppColors
                                            .border1, // Inactive state border color
                                    width:
                                        1.5, // Border width remains unchanged
                                  ),
                                ),
                                shadowColor: Colors.transparent, // No shadow
                              ),
                              onPressed: selectedIds.isNotEmpty
                                  ? () {
                                      final selectedIds = ref
                                          .read(selectedExperienceIdsProvider);
                                      final text =
                                          ref.read(experienceTextProvider);
                                      print('Selected IDs: $selectedIds');
                                      print('Additional Text: $text');
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              OnboardingQuestionScreen(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          transitionDuration: Duration(
                                              milliseconds:
                                                  300), // Adjust the duration as needed
                                        ),
                                      );
                                    }
                                  : null, // Disable button when inactive
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Next',
                                    style: AppTextStyles.bodyText.copyWith(
                                      color: Colors.white.withOpacity(selectedIds
                                              .isNotEmpty
                                          ? 0.9
                                          : 0.4), // Text color varies by state
                                    ),
                                  ),
                                  SizedBox(
                                      width: 8), // Space between text and image
                                  Image.asset(
                                    'assets/forward.png', // Use asset image instead of icon
                                    color: Colors.white.withOpacity(selectedIds
                                            .isNotEmpty
                                        ? 0.9
                                        : 0.4), // Image color varies by state
                                    height:
                                        20, // Set the desired height for the image
                                    width:
                                        20, // Set the desired width for the image
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
