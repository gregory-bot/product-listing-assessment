import 'package:flutter/widgets.dart';

// Breakpoint values as named constants — magic numbers replaced so the intent
// is clear at every call site and changes stay in one place.
class _Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
}

// Selects between three layout widgets based on available width.
//
// LayoutBuilder is used instead of MediaQuery.of(context).size because WINP
// Flux is embedded as a Flutter web component inside a host page. The host
// decides how much horizontal space to allocate — that allocated width is what
// LayoutBuilder's constraints reflect. MediaQuery would return the full device
// viewport, which is irrelevant when the component occupies only a column of
// a larger page.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _Breakpoints.desktop) return desktop;
        if (constraints.maxWidth >= _Breakpoints.tablet) return tablet;
        return mobile;
      },
    );
  }
}
