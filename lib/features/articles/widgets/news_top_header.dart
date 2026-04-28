import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewsTopHeader extends StatelessWidget {
  const NewsTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1118),
        border: Border.all(color: const Color(0xFF293243)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFFF3A4B),
            ),
            alignment: Alignment.center,
            child: const Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEWSROOM',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                'LIVE WIRE',
                style: TextStyle(
                  fontFamily: 'Jetbrains Mono',
                  color: Color(0xFF7A8598),
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset("assets/notifs.svg", width: 25, height: 25)
        ],
      ),
    );
  }
}
