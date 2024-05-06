import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/home/home.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MyApp(),
  );

  //TODO load database before launch.
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "think_simple",
      theme: darkTheme,
      home: const Home(),
      locale: const Locale("en"),
    );
  }

  static const Color _white = Color.fromARGB(255, 218, 216, 248);
  static const Color _primary = Color(0xFF3B197B);
  static const Color _secondary = Color(0xFF2619B4);
  static const Color _tetriary = Color.fromARGB(255, 13, 181, 97);
  static const Color _background = Color(0xFF040412);
  static const Color _error = Color.fromARGB(255, 199, 11, 68);

  final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      onPrimary: _white,
      secondary: _secondary,
      onSecondary: _white,
      error: _error,
      onError: _white,
      background: _background,
      onBackground: _white,
      surface: _tetriary,
      onSurface: _white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _tetriary,
      foregroundColor: _white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _background,
      selectedItemColor: _tetriary,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        letterSpacing: 0.7,
        fontSize: 48,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        letterSpacing: 0.7,
        fontWeight: FontWeight.w400,
        fontSize: 36,
      ),
      headlineSmall: TextStyle(
        letterSpacing: 0.7,
        fontWeight: FontWeight.w400,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.2,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.2,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.2,
      ),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: _primary),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        foregroundColor: _tetriary,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _secondary,
      contentTextStyle: TextStyle(color: _white),
    ),
    datePickerTheme: const DatePickerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: _background,
      dividerColor: Colors.transparent,
      todayBorder: BorderSide(style: BorderStyle.none),
      todayForegroundColor: MaterialStatePropertyAll<Color>(_tetriary),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(
          _background.withOpacity(0.94),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        foregroundColor: _tetriary,
        backgroundColor: _secondary.withAlpha(64),
      ).copyWith(
        overlayColor: MaterialStatePropertyAll<Color>(_secondary.withAlpha(64)),
      ),
    ),
    menuBarTheme: const MenuBarThemeData(
      style: MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(_background),
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
      ),
    ),
    menuTheme: const MenuThemeData(
      style: MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    useMaterial3: true,
  );
}
