import '../config/app_config.dart';

enum StoreVendor {
  appStore,
  googlePlay,
  ruStore,
}

/// Picks a store URL from [.env] using a lightweight region hint (browser locale, etc.).
class StoreCountryResolver {
  const StoreCountryResolver._();

  /// `navigator.language` style tag, e.g. `ru-RU`, `en`.
  static String? regionFromLanguageTag(String? tag) {
    if (tag == null || tag.isEmpty) return null;
    final parts = tag.split(RegExp(r'[-_]'));
    if (parts.length >= 2) {
      return parts[1].toUpperCase();
    }
    return parts[0].toUpperCase();
  }

  static StoreVendor pickVendor({
    required bool treatAsIosBrowser,
    required String? regionIso3166Alpha2,
  }) {
    if (treatAsIosBrowser) {
      return StoreVendor.appStore;
    }
    final r = regionIso3166Alpha2?.toUpperCase();
    if (r == 'RU' || r == 'BY' || r == 'KZ') {
      return StoreVendor.ruStore;
    }
    return StoreVendor.googlePlay;
  }

  static Uri urlFor(StoreVendor vendor, AppConfig config) {
    switch (vendor) {
      case StoreVendor.appStore:
        return config.appStoreUrl;
      case StoreVendor.googlePlay:
        return config.googlePlayUrl;
      case StoreVendor.ruStore:
        return config.ruStoreUrl;
    }
  }
}
