// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ベジタリアン料理本';

  @override
  String get search => '検索';

  @override
  String get bookmarks => 'ブックマーク';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get searchPlaceholder => '検索テキストを入力...';

  @override
  String get searchTabText => 'テキスト';

  @override
  String get searchTabTitles => 'タイトル';

  @override
  String get searchTabComments => 'メモ';

  @override
  String get noResults => '結果が見つかりません';

  @override
  String resultsCount(int count) {
    return '$count 件の結果';
  }

  @override
  String pageOf(int current, int total) {
    return '$current / $total ページ';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get retry => '再試行';

  @override
  String get cancel => 'キャンセル';

  @override
  String get addBookmark => 'ブックマークを追加';

  @override
  String get removeBookmark => 'ブックマークを削除';

  @override
  String get noBookmarks => 'ブックマークはまだありません';

  @override
  String get audioPlayer => 'オーディオプレーヤー';

  @override
  String get sections => 'セクション';

  @override
  String get salads => 'サラダ';

  @override
  String get soups => 'スープ';

  @override
  String get mainCourses => 'メインディッシュ';

  @override
  String get desserts => 'デザート';

  @override
  String get drinks => 'ドリンク';

  @override
  String get ingredients => '材料';

  @override
  String get preparation => '作り方';

  @override
  String get servings => '人前';

  @override
  String get prepTime => '準備時間';

  @override
  String get cookTime => '調理時間';
}
