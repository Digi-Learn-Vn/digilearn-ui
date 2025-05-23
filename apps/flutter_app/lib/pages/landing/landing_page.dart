import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/core/theme/theme_provider.dart';
import 'top_bar.dart';
import 'home_section.dart';
import 'explore_section.dart';
import 'aboutus_section.dart';
import 'bottom_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static final GlobalKey homeKey = GlobalKey();
  static final GlobalKey exploreKey = GlobalKey();
  static final GlobalKey aboutUsKey = GlobalKey();

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _activeSection = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _activeSection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: TopBar(
        isDarkTheme: ValueNotifier<bool>(themeProvider.isDarkTheme),
        activeSection: _activeSection,
        scrollToSection: _scrollToSection,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HomeSection(
                  key: LandingPage.homeKey,
                  isDarkTheme: ValueNotifier<bool>(themeProvider.isDarkTheme),
                ),
                ExploreSection(
                  key: LandingPage.exploreKey,
                  isDarkTheme: ValueNotifier<bool>(themeProvider.isDarkTheme),
                ),
                AboutUsSection(
                  key: LandingPage.aboutUsKey,
                  isDarkTheme: ValueNotifier<bool>(themeProvider.isDarkTheme),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final double screenHeight = MediaQuery.of(context).size.height;

    if (offset < screenHeight * 0.5) {
      _activeSection.value = 0;
    } else if (offset < screenHeight * 1) {
      _activeSection.value = 1;
    } else {
      _activeSection.value = 2;
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    print('Scrolling to section: $key');
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print('Context is null for key: $key');
    }
  }
}
