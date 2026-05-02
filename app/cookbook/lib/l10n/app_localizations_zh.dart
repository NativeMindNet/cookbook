// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '素食食谱';

  @override
  String get search => '搜索';

  @override
  String get bookmarks => '书签';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get searchPlaceholder => '输入搜索文字...';

  @override
  String get searchTabText => '文字';

  @override
  String get searchTabTitles => '标题';

  @override
  String get searchTabComments => '备注';

  @override
  String get noResults => '未找到结果';

  @override
  String resultsCount(int count) {
    return '$count 个结果';
  }

  @override
  String pageOf(int current, int total) {
    return '第 $current 页，共 $total 页';
  }

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get retry => '重试';

  @override
  String get cancel => '取消';

  @override
  String get addBookmark => '添加书签';

  @override
  String get removeBookmark => '删除书签';

  @override
  String get noBookmarks => '暂无书签';

  @override
  String get audioPlayer => '音频播放器';

  @override
  String get sections => '章节';

  @override
  String get salads => '沙拉';

  @override
  String get soups => '汤类';

  @override
  String get mainCourses => '主菜';

  @override
  String get desserts => '甜点';

  @override
  String get drinks => '饮料';

  @override
  String get ingredients => '配料';

  @override
  String get preparation => '制作方法';

  @override
  String get servings => '份量';

  @override
  String get prepTime => '准备时间';

  @override
  String get cookTime => '烹饪时间';
}
