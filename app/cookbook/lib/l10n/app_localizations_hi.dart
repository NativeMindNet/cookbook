// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'शाकाहारी रसोई की किताब';

  @override
  String get search => 'खोजें';

  @override
  String get bookmarks => 'बुकमार्क';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get searchPlaceholder => 'खोजने के लिए टाइप करें...';

  @override
  String get searchTabText => 'टेक्स्ट';

  @override
  String get searchTabTitles => 'शीर्षक';

  @override
  String get searchTabComments => 'टिप्पणियाँ';

  @override
  String get noResults => 'कुछ नहीं मिला';

  @override
  String resultsCount(int count) {
    return '$count परिणाम';
  }

  @override
  String pageOf(int current, int total) {
    return 'पृष्ठ $current का $total';
  }

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get addBookmark => 'बुकमार्क जोड़ें';

  @override
  String get removeBookmark => 'बुकमार्क हटाएं';

  @override
  String get noBookmarks => 'अभी तक कोई बुकमार्क नहीं';

  @override
  String get audioPlayer => 'ऑडियो प्लेयर';

  @override
  String get sections => 'अनुभाग';

  @override
  String get salads => 'सलाद';

  @override
  String get soups => 'सूप';

  @override
  String get mainCourses => 'मुख्य व्यंजन';

  @override
  String get desserts => 'मिठाई';

  @override
  String get drinks => 'पेय';

  @override
  String get ingredients => 'सामग्री';

  @override
  String get preparation => 'तैयारी';

  @override
  String get servings => 'परोसने की मात्रा';

  @override
  String get prepTime => 'तैयारी का समय';

  @override
  String get cookTime => 'पकाने का समय';
}
