// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ตำราอาหารมังสวิรัติ';

  @override
  String get search => 'ค้นหา';

  @override
  String get bookmarks => 'บุ๊คมาร์ค';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get searchPlaceholder => 'พิมพ์ข้อความค้นหา...';

  @override
  String get searchTabText => 'ข้อความ';

  @override
  String get searchTabTitles => 'หัวข้อ';

  @override
  String get searchTabComments => 'หมายเหตุ';

  @override
  String get noResults => 'ไม่พบผลลัพธ์';

  @override
  String resultsCount(int count) {
    return '$count ผลลัพธ์';
  }

  @override
  String pageOf(int current, int total) {
    return 'หน้า $current จาก $total';
  }

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get addBookmark => 'เพิ่มบุ๊คมาร์ค';

  @override
  String get removeBookmark => 'ลบบุ๊คมาร์ค';

  @override
  String get noBookmarks => 'ยังไม่มีบุ๊คมาร์ค';

  @override
  String get audioPlayer => 'เครื่องเล่นเสียง';

  @override
  String get sections => 'หมวดหมู่';

  @override
  String get salads => 'สลัด';

  @override
  String get soups => 'ซุป';

  @override
  String get mainCourses => 'อาหารจานหลัก';

  @override
  String get desserts => 'ขนมหวาน';

  @override
  String get drinks => 'เครื่องดื่ม';

  @override
  String get ingredients => 'ส่วนผสม';

  @override
  String get preparation => 'วิธีทำ';

  @override
  String get servings => 'จำนวนที่เสิร์ฟ';

  @override
  String get prepTime => 'เวลาเตรียม';

  @override
  String get cookTime => 'เวลาปรุง';
}
