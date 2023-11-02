// Project imports:
import 'package:tstore/tstore.dart';

class SettingsDocument extends TDocument {
  final String? languageCode;
  final String? theme;
  final int? year;

  const SettingsDocument({
    this.languageCode,
    this.theme,
    this.year,
  });

  @override
  SettingsDocument clone() {
    return SettingsDocument(
      languageCode: languageCode,
      theme: theme,
      year: year,
    );
  }

  factory SettingsDocument.fromJson(Map<String, dynamic> json) {
    return SettingsDocument(
      languageCode: json['languageCode'] as String?,
      theme: json['theme'] as String?,
      year: json['year'] as int?,
    );
  }

  @override
  SettingsDocument copyWith({
    String? languageCode,
    String? theme,
    int? year,
  }) {
    return SettingsDocument(
      languageCode: languageCode ?? this.languageCode,
      theme: theme ?? this.theme,
      year: year ?? this.year,
    );
  }

  @override
  SettingsDocument merge(covariant SettingsDocument document) {
    return copyWith(
      languageCode: document.languageCode,
      theme: document.theme,
      year: document.year,
    );
  }

  @override
  List<Object?> get props => [languageCode, theme, year];

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'languageCode': languageCode,
      'theme': theme,
      'year': year,
    };
  }
}
