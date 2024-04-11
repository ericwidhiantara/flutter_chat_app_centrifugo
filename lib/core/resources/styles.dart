import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tddboilerplate/core/core.dart';

/// Light theme
ThemeData themeLight(BuildContext context) => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      primaryColor: Palette.primary,
      disabledColor: Palette.shadowDark,
      hintColor: Palette.subText,
      cardColor: Palette.card,
      scaffoldBackgroundColor: Palette.background,
      dividerColor: Palette.shadow,
      colorScheme: const ColorScheme.light().copyWith(
        primary: Palette.primary,
        background: Palette.background,
      ),
      textTheme: TextTheme(
        displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: Dimens.displayLarge,
              color: Palette.text,
            ),
        displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: Dimens.displayMedium,
              color: Palette.text,
            ),
        displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: Dimens.displaySmall,
              color: Palette.text,
            ),
        headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: Dimens.headlineMedium,
              color: Palette.text,
            ),
        headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: Dimens.headlineSmall,
              color: Palette.text,
            ),
        titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: Dimens.titleLarge,
              color: Palette.text,
            ),
        titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: Dimens.titleMedium,
              color: Palette.text,
            ),
        titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: Dimens.titleSmall,
              color: Palette.text,
            ),
        bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: Dimens.bodyLarge,
              color: Palette.text,
            ),
        bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: Dimens.bodyMedium,
              color: Palette.text,
            ),
        bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: Dimens.bodySmall,
              color: Palette.text,
            ),
        labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: Dimens.labelLarge,
              color: Palette.text,
            ),
        labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: Dimens.labelSmall,
              letterSpacing: 0.25,
              color: Palette.text,
            ),
      ),
      appBarTheme: const AppBarTheme().copyWith(
        titleTextStyle: Theme.of(context).textTheme.bodyLarge,
        color: Palette.background,
        iconTheme: const IconThemeData(color: Palette.primary),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        surfaceTintColor: Palette.background,
        shadowColor: Palette.shadow,
      ),
      drawerTheme: const DrawerThemeData().copyWith(
        elevation: Dimens.zero,
        surfaceTintColor: Palette.background,
        backgroundColor: Palette.background,
      ),
      bottomSheetTheme: const BottomSheetThemeData().copyWith(
        backgroundColor: Palette.background,
        surfaceTintColor: Colors.transparent,
        elevation: Dimens.zero,
      ),
      dialogTheme: const DialogTheme().copyWith(
        backgroundColor: Palette.background,
        surfaceTintColor: Colors.transparent,
        elevation: Dimens.zero,
      ),
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: Palette.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: const <ThemeExtension<dynamic>>[
        CustomColor(
          primary: Palette.primary,
          onboardingGradientUp: Palette.onboardingGradientUp,
          onboardingGradientDown: Palette.onboardingGradientDown,
          pinkButtonColor: Palette.pinkButtonColor,
          background: Palette.background,
          card: Palette.card,
          buttonText: Palette.text,
          defaultText: Palette.black,
          subtitle: Palette.subText,
          shadow: Palette.shadowDark,
          green: Palette.greenLatte,
          roseWater: Palette.roseWaterLatte,
          flamingo: Palette.flamingoLatte,
          pink: Palette.pinkLatte,
          mauve: Palette.mauveLatte,
          maroon: Palette.maroonLatte,
          peach: Palette.peachLatte,
          yellow: Palette.yellow,
          yellowLatte: Palette.yellowLatte,
          teal: Palette.tealLatte,
          sapphire: Palette.sapphireLatte,
          sky: Palette.skyLatte,
          blue: Palette.blue,
          blueLatte: Palette.blueLatte,
          lavender: Palette.lavenderLatte,
          red: Palette.red,
          redLatte: Palette.redLatte,
        ),
      ],
    );

/// Dark theme
ThemeData themeDark(BuildContext context) => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      primaryColor: Palette.redMocha,
      disabledColor: Palette.shadowDark,
      hintColor: Palette.subTextDark,
      cardColor: Palette.cardDark,
      scaffoldBackgroundColor: Palette.backgroundDark,
      dividerColor: Palette.shadow,
      colorScheme: const ColorScheme.dark().copyWith(primary: Palette.primary),
      textTheme: TextTheme(
        displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: Dimens.displayLarge,
              color: Palette.textDark,
            ),
        displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: Dimens.displayMedium,
              color: Palette.textDark,
            ),
        displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: Dimens.displaySmall,
              color: Palette.textDark,
            ),
        headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: Dimens.headlineMedium,
              color: Palette.textDark,
            ),
        headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: Dimens.headlineSmall,
              color: Palette.textDark,
            ),
        titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: Dimens.titleLarge,
              color: Palette.textDark,
            ),
        titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: Dimens.titleMedium,
              color: Palette.textDark,
            ),
        titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: Dimens.titleSmall,
              color: Palette.textDark,
            ),
        bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: Dimens.bodyLarge,
              color: Palette.textDark,
            ),
        bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: Dimens.bodyMedium,
              color: Palette.textDark,
            ),
        bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: Dimens.bodySmall,
              color: Palette.textDark,
            ),
        labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: Dimens.labelLarge,
              color: Palette.textDark,
            ),
        labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: Dimens.labelSmall,
              letterSpacing: 0.25,
              color: Palette.textDark,
            ),
      ),
      appBarTheme: const AppBarTheme().copyWith(
        titleTextStyle: Theme.of(context).textTheme.bodyLarge,
        iconTheme: const IconThemeData(color: Palette.redMocha),
        color: Palette.backgroundDark,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        surfaceTintColor: Palette.backgroundDark,
        shadowColor: Palette.shadowDark,
      ),
      drawerTheme: const DrawerThemeData().copyWith(
        elevation: Dimens.zero,
        surfaceTintColor: Palette.backgroundDark,
        backgroundColor: Palette.backgroundDark,
        shadowColor: Palette.shadowDark,
      ),
      bottomSheetTheme: const BottomSheetThemeData().copyWith(
        backgroundColor: Palette.backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: Dimens.zero,
      ),
      dialogTheme: const DialogTheme().copyWith(
        backgroundColor: Palette.backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: Dimens.zero,
      ),
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(color: Palette.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: const <ThemeExtension<dynamic>>[
        CustomColor(
          primary: Palette.primary,
          onboardingGradientUp: Palette.onboardingGradientUp,
          onboardingGradientDown: Palette.onboardingGradientDown,
          pinkButtonColor: Palette.pinkButtonColor,
          background: Palette.backgroundDark,
          buttonText: Palette.textDark,
          defaultText: Palette.white,
          card: Palette.cardDark,
          subtitle: Palette.subTextDark,
          shadow: Palette.shadowDark,
          green: Palette.greenMocha,
          roseWater: Palette.roseWaterMocha,
          flamingo: Palette.flamingoMocha,
          pink: Palette.pinkMocha,
          mauve: Palette.mauveMocha,
          maroon: Palette.maroonMocha,
          peach: Palette.peachMocha,
          yellow: Palette.yellow,
          yellowLatte: Palette.yellowMocha,
          teal: Palette.tealMocha,
          sapphire: Palette.sapphireMocha,
          sky: Palette.skyMocha,
          blue: Palette.blue,
          blueLatte: Palette.blueMocha,
          lavender: Palette.lavenderMocha,
          red: Palette.red,
          redLatte: Palette.redMocha,
        ),
      ],
    );

class CustomColor extends ThemeExtension<CustomColor> {
  final Color? primary;
  final Color? onboardingGradientUp;
  final Color? onboardingGradientDown;
  final Color? pinkButtonColor;
  final Color? background;
  final Color? card;
  final Color? buttonText;
  final Color? defaultText;
  final Color? subtitle;
  final Color? shadow;
  final Color? green;
  final Color? roseWater;
  final Color? flamingo;
  final Color? pink;
  final Color? mauve;
  final Color? maroon;
  final Color? peach;
  final Color? yellow;
  final Color? yellowLatte;
  final Color? teal;
  final Color? sky;
  final Color? sapphire;
  final Color? blue;
  final Color? blueLatte;
  final Color? lavender;
  final Color? red;
  final Color? redLatte;

  const CustomColor({
    this.primary,
    this.onboardingGradientUp,
    this.onboardingGradientDown,
    this.pinkButtonColor,
    this.background,
    this.card,
    this.buttonText,
    this.defaultText,
    this.subtitle,
    this.shadow,
    this.green,
    this.roseWater,
    this.flamingo,
    this.pink,
    this.mauve,
    this.maroon,
    this.peach,
    this.yellow,
    this.yellowLatte,
    this.teal,
    this.sapphire,
    this.sky,
    this.blue,
    this.blueLatte,
    this.lavender,
    this.red,
    this.redLatte,
  });

  @override
  ThemeExtension<CustomColor> copyWith({
    Color? primary,
    Color? onboardingGradientUp,
    Color? onboardingGradientDown,
    Color? pinkButtonColor,
    Color? background,
    Color? card,
    Color? buttonText,
    Color? defaultText,
    Color? subtitle,
    Color? shadow,
    Color? green,
    Color? roseWater,
    Color? flamingo,
    Color? pink,
    Color? mauve,
    Color? maroon,
    Color? peach,
    Color? yellow,
    Color? yellowLatte,
    Color? teal,
    Color? sky,
    Color? sapphire,
    Color? blue,
    Color? blueLatte,
    Color? lavender,
    Color? red,
    Color? redLatte,
  }) {
    return CustomColor(
      primary: primary ?? this.primary,
      onboardingGradientUp: onboardingGradientUp ?? this.onboardingGradientUp,
      onboardingGradientDown:
          onboardingGradientDown ?? this.onboardingGradientDown,
      pinkButtonColor: pinkButtonColor ?? this.onboardingGradientDown,
      background: background ?? this.background,
      card: card ?? this.card,
      buttonText: buttonText ?? this.buttonText,
      defaultText: defaultText ?? this.defaultText,
      subtitle: subtitle ?? this.subtitle,
      shadow: shadow ?? this.shadow,
      green: green ?? this.green,
      roseWater: roseWater ?? this.roseWater,
      flamingo: flamingo ?? this.flamingo,
      pink: pink ?? this.pink,
      mauve: mauve ?? this.mauve,
      maroon: maroon ?? this.maroon,
      peach: peach ?? this.peach,
      yellow: yellow ?? this.yellow,
      yellowLatte: yellowLatte ?? this.yellowLatte,
      teal: teal ?? this.teal,
      sky: sky ?? this.sky,
      sapphire: sapphire ?? this.sapphire,
      blue: blue ?? this.blue,
      blueLatte: blueLatte ?? this.blueLatte,
      lavender: lavender ?? this.lavender,
      red: red ?? this.red,
      redLatte: redLatte ?? this.redLatte,
    );
  }

  @override
  ThemeExtension<CustomColor> lerp(
    covariant ThemeExtension<CustomColor>? other,
    double t,
  ) {
    if (other is! CustomColor) {
      return this;
    }
    return CustomColor(
      primary: Color.lerp(primary, other.primary, t),
      onboardingGradientUp:
          Color.lerp(onboardingGradientUp, other.onboardingGradientUp, t),
      onboardingGradientDown:
          Color.lerp(onboardingGradientDown, other.onboardingGradientDown, t),
      pinkButtonColor: Color.lerp(pinkButtonColor, other.pinkButtonColor, t),
      background: Color.lerp(background, other.background, t),
      card: Color.lerp(card, other.card, t),
      buttonText: Color.lerp(buttonText, other.buttonText, t),
      subtitle: Color.lerp(subtitle, other.subtitle, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      green: Color.lerp(green, other.green, t),
      roseWater: Color.lerp(roseWater, other.roseWater, t),
      flamingo: Color.lerp(flamingo, other.flamingo, t),
      pink: Color.lerp(pink, other.pink, t),
      mauve: Color.lerp(mauve, other.mauve, t),
      maroon: Color.lerp(maroon, other.maroon, t),
      peach: Color.lerp(peach, other.peach, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      teal: Color.lerp(teal, other.teal, t),
      sapphire: Color.lerp(sapphire, other.sapphire, t),
      blue: Color.lerp(blue, other.blue, t),
      lavender: Color.lerp(lavender, other.lavender, t),
      sky: Color.lerp(sky, other.sky, t),
      red: Color.lerp(red, other.red, t),
    );
  }
}

class BoxDecorations {
  BoxDecorations(this.context);

  final BuildContext context;

  BoxDecoration get button => BoxDecoration(
        color: Palette.primary,
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        boxShadow: [BoxShadows(context).button],
      );

  BoxDecoration get card => BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        boxShadow: [BoxShadows(context).card],
      );
}

class BoxShadows {
  BoxShadows(this.context);

  final BuildContext context;

  BoxShadow get button => BoxShadow(
        color: Theme.of(context)
            .extension<CustomColor>()!
            .shadow!
            .withOpacity(0.5),
        blurRadius: 16.0,
        spreadRadius: 1.0,
      );

  BoxShadow get card => BoxShadow(
        color: Theme.of(context)
            .extension<CustomColor>()!
            .shadow!
            .withOpacity(0.5),
        blurRadius: 5.0,
        spreadRadius: 0.5,
      );

  BoxShadow get dialog => BoxShadow(
        color: Theme.of(context).extension<CustomColor>()!.shadow!,
        offset: const Offset(0, -4),
        blurRadius: 16.0,
      );

  BoxShadow get dialogAlt => BoxShadow(
        color: Theme.of(context).extension<CustomColor>()!.shadow!,
        offset: const Offset(0, 4),
        blurRadius: 16.0,
      );

  BoxShadow get buttonMenu => BoxShadow(
        color: Theme.of(context).extension<CustomColor>()!.shadow!,
        blurRadius: 4.0,
      );
}
