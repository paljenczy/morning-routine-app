import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Map<String, Color> _avatarColors = {
  'fox': Color(0xFFFFE0B2),
  'rabbit': Color(0xFFFCE4EC),
  'bear': Color(0xFFD7CCC8),
  'cat': Color(0xFFFFCCBC),
  'dog': Color(0xFFEFEBE9),
  'owl': Color(0xFFF3E5F5),
};

class AnimalAvatar extends StatelessWidget {
  final String avatarKey;
  final String name;
  final double size;
  final bool showName;

  const AnimalAvatar({
    super.key,
    required this.avatarKey,
    required this.name,
    this.size = 72,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = _avatarColors[avatarKey] ?? const Color(0xFFE0E0E0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.1),
            child: SvgPicture.asset(
              'assets/avatars/$avatarKey.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 6),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ],
    );
  }
}
