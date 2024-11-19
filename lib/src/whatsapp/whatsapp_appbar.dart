/// WhatsApp profile appBar animation
///! Checkout the tutorial https://youtu.be/8JKE0tViRVQ
///
import 'dart:ui';

import 'package:flutter/material.dart';

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
              delegate: WhatsappAppBarSliverDelegate(
                avatarUrl: "https://avatars.githubusercontent.com/u/46500228?v=4",
                bannerUrl: "https://cdn.pixabay.com/photo/2017/02/09/09/11/starry-sky-2051448_1280.jpg",
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 32),
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

class WhatsappAppBarSliverDelegate extends SliverPersistentHeaderDelegate {
  const WhatsappAppBarSliverDelegate({
    required this.avatarUrl,
    required this.bannerUrl,
  });

  final String avatarUrl;
  final String bannerUrl;

  Material buildIconButton(VoidCallback onTap) {
    return Material(
      color: const Color(0xFF05A382),
      shape: CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = shrinkOffset / maxExtent;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedContainer(
          duration: Durations.short1,
          color: shrinkOffset >= maxExtent - minExtent //
              ? const Color(0xFF1F272A)
              : Colors.transparent,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: lerpDouble(48, -48, t),
          child: Image.network(
            bannerUrl,
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(lerpDouble(1, 0, t)!),
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
                    child: InkWell(
                      onTap: () {},
                      child: Ink.image(
                        image: NetworkImage(avatarUrl),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: buildIconButton(() {}),
                  ),
                ],
              ),
            ),
          ),
        if (shrinkOffset < maxExtent - minExtent)
          Positioned(
            right: 8,
            bottom: shrinkOffset + (48 - 16),
            child: buildIconButton(() {}),
          ),
        Align(
          alignment: Alignment.topLeft,
          child: BackButton(
            color: Colors.white,
          ),
        )
      ],
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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
