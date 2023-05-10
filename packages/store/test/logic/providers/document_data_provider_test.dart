import 'package:flutter_test/flutter_test.dart';

import '../../mocks/entities/settings.entity.dart';
import '../../mocks/providers/settings.provider.dart';

void main() {
  group('TDocumentDataProvider', () {
    late SettingsDocumentDataProvider provider;
    late SettingsDocument document;

    setUp(() {
      provider = SettingsDocumentDataProvider();
      document = const SettingsDocument(languageCode: 'en');
    });

    group('#persistDocument()', () {
      test('should persit a document', () async {
        await provider.connect();
        await provider.persistDocument(document);
        final documentRetrieved = await provider.retrieveSettings();

        expect(documentRetrieved, equals(document));
      });

      test('should update document', () async {
        await provider.connect();
        await provider.persistDocument(document);
        await provider.persistDocument(
          const SettingsDocument(year: 2020, theme: 'dark'),
        );
        final documentRetrieved = await provider.retrieveSettings();

        expect(
          documentRetrieved,
          equals(const SettingsDocument(year: 2020, theme: 'dark')),
        );
      });
    });

    group('#clearDocument()', () {
      test('should clear a document', () async {
        await provider.connect();
        await provider.persistDocument(document);
        var documentRetrieved = await provider.retrieveSettings();

        expect(documentRetrieved, equals(document));

        await provider.clearDocument();
        documentRetrieved = await provider.retrieveSettings();

        expect(documentRetrieved, equals(const SettingsDocument()));
      });
    });
  });
}
