// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
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

    group('Connection Management', () {
      test(
          'multiple connects and single disconnect '
          'does not actually disconnect', () async {
        await provider.connect();
        await provider.connect();

        await provider.persistDocument(document);
        var documentRetrieved = await provider.retrieveSettings();
        expect(documentRetrieved, equals(document));

        // This should not actually disconnect
        // because there's still one more active connection.
        await provider.disconnect();

        // This should still work.
        documentRetrieved = await provider.retrieveSettings();
        expect(documentRetrieved, equals(document));
      });

      test('actual disconnect only happens after all connects are disconnected',
          () async {
        await provider.connect();
        await provider.connect();

        await provider.disconnect(); // Should not actually disconnect

        // Check if still connected
        final documentRetrieved = await provider.retrieveSettings();
        expect(documentRetrieved, equals(document));

        await provider.disconnect(); // Now it should actually disconnect.

        try {
          await provider.retrieveSettings();
        } catch (error) {
          expect(error, isA<Exception>());
        }
      });
    });
  });
}
