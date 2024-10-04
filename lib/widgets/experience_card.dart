// lib/widgets/experience_card.dart

import 'package:flutter/material.dart';

import '../models/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.isSelected,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rotationAngle = (index % 2 == 0) ? -0.05 : 0.05;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Experience image with tilt
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12, top: 8, bottom: 8, left: 6),
              child: Transform.rotate(
                angle: rotationAngle, // Apply the tilt based on the index
                child: Image.network(
                  experience.imageUrl,
                  fit: BoxFit.cover,
                  color: isSelected ? null : Colors.grey,
                  colorBlendMode: isSelected ? null : BlendMode.saturation,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
