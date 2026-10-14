import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

/// Generated product imagery placeholder.
///
/// Real product photography is not available for this milestone: the supplied
/// Figma files are flattened screen exports rather than extractable assets, so
/// they must not be used as product images. Each product renders a deterministic
/// gradient derived from its own colours instead.
class ProductPlaceholderImage extends StatelessWidget {
  const ProductPlaceholderImage({
    super.key,
    required this.colors,
    required this.icon,
    this.label,
    this.iconScale = 1,
  });

  final List<Color> colors;
  final IconData icon;

  /// Optional caption drawn over the bottom of the image.
  final String? label;

  /// Scales the centred icon, used to make the large Product Details image feel
  /// less empty.
  final double iconScale;

  @override
  Widget build(BuildContext context) {
    final stops = colors.length < 2
        ? const <double>[0, 1]
        : <double>[for (var i = 0; i < colors.length; i++) i / (colors.length - 1)];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth ? constraints.maxWidth : 200.0;
        final compact = width < 120;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              stops: stops,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Center(
                child: FractionallySizedBox(
                  widthFactor: iconScale,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      icon,
                      size: 96,
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                ),
              ),
              if (label != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          AppColors.scrim,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                      child: Text(
                        label!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: Colors.white,
                          fontSize: compact ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}