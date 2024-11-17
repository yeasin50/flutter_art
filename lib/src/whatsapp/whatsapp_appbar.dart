import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// WhatsApp Profile appBar
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13181C),
      body: SafeArea(
        child: CustomScrollView(
          slivers: const [
            SliverPersistentHeader(
              delegate: WhatsappAppBarSliverHeader(
                avatarUrl: "https://avatars.githubusercontent.com/u/46500228?v=4",
                bannerUrl: "https://cdn.pixabay.com/photo/2017/02/09/09/11/starry-sky-2051448_1280.jpg",
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 24,
              ),
            ),
            SliverToBoxAdapter(
              child: Placeholder(
                fallbackHeight: 1200,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WhatsappAppBarSliverHeader extends SliverPersistentHeaderDelegate {
  const WhatsappAppBarSliverHeader({
    required this.avatarUrl,
    required this.bannerUrl,
  });

  final String avatarUrl;
  final String bannerUrl;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = shrinkOffset / maxExtent;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: shrinkOffset >= maxExtent - minExtent //
              ? const Color(0xFF1F272A)
              : Colors.transparent,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 48,
          child: Image.network(
            bannerUrl,
            fit: BoxFit.contain,
            opacity: AlwaysStoppedAnimation(max(0, lerpDouble(1, -.25, t)!)),
          ),
        ),
        if (shrinkOffset < maxExtent - minExtent)
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox.square(
              dimension: 120,
              child: Stack(
                children: [
                  Material(
                    clipBehavior: Clip.antiAlias,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: Ink.image(
                          image: NetworkImage(avatarUrl),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: buildIconButton(
                      () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        // if (shrinkOffset < maxExtent - minExtent * 2)
        Positioned(
          right: 8,
          bottom: shrinkOffset + (48 - 16),
          child: buildIconButton(
            () {},
          ),
        ),

        Align(
          alignment: Alignment.topLeft,
          child: BackButton(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Material buildIconButton(VoidCallback onTap) {
    return Material(
      color: Color(0xFF05A382),
      shape: CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.camera_alt_outlined,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 250;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}
