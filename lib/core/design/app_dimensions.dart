/// Centralized spacing, corner radii, elevations, and component dimensions.
abstract class AppDimensions {
  // ── Spacing ───────────────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  // ── Corner radii ──────────────────────────────────────────────────────
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusCircle = double.infinity;

  // ── Elevation / shadows ───────────────────────────────────────────────
  static const double elevationSm = 2;
  static const double elevationMd = 6;
  static const double elevationLg = 12;

  // ── Component dimensions ──────────────────────────────────────────────
  static const double cardHeight = 150;
  static const double iconSizeMd = 24;
  static const double iconSizeLg = 32;
  static const double avatarSize = 48;
  static const double sectionHeaderHeight = 56;
  static const double bottomNavHeight = 72;
  static const double maxContentWidth = 640;
  static const double tileHeight = 60;
}