import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/species/data/models/species_detail.dart';
import 'package:butterfly_india/features/species/presentation/providers/species_providers.dart';
import 'package:butterfly_india/features/species/presentation/widgets/custom_fields_section.dart';
import '../../helpers/test_helpers.dart';
import 'fake_species_datasource.dart';

/// The section is driven entirely by backend data: the species carries values
/// keyed by field_key, the definitions endpoint supplies the titles. These
/// tests pin the join, the formatting, and the cases where it must show nothing.

void main() {
  late FakeSpeciesRemoteDataSource remote;

  setUp(() => remote = FakeSpeciesRemoteDataSource());

  SpeciesDetail detailWith(Map<String, dynamic> customFields) => SpeciesDetail(
        id: 'sp-1',
        commonName: 'Crimson Rose',
        scientificName: 'Pachliopta hector',
        customFields: customFields,
      );

  Future<void> pump(WidgetTester tester, SpeciesDetail detail) async {
    final container = createTestContainer(
      overrides: [speciesRemoteDataSourceProvider.overrideWithValue(remote)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: CustomFieldsSection(detail: detail),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows a value under its admin-defined label', (tester) async {
    remote.fieldDefinitions = const [
      SpeciesFieldDefinition(fieldKey: 'wing_texture', label: 'Wing texture'),
    ];
    await pump(tester, detailWith({'wing_texture': 'Velvety'}));

    expect(find.text('Wing texture'), findsOneWidget);
    expect(find.text('Velvety'), findsOneWidget);
    expect(find.text('Custom fields'), findsOneWidget);
  });

  testWidgets('formats lists and booleans for reading', (tester) async {
    remote.fieldDefinitions = const [
      SpeciesFieldDefinition(
          fieldKey: 'local_names', label: 'Local names', fieldType: 'list'),
      SpeciesFieldDefinition(
          fieldKey: 'is_endemic', label: 'Endemic', fieldType: 'boolean'),
    ];
    await pump(tester, detailWith({
      'local_names': ['Rose', 'Gulab'],
      'is_endemic': true,
    }));

    expect(find.text('Rose, Gulab'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
  });

  testWidgets('groups fields under their group name', (tester) async {
    remote.fieldDefinitions = const [
      SpeciesFieldDefinition(
          fieldKey: 'wing_texture', label: 'Wing texture', groupName: 'Field notes'),
    ];
    await pump(tester, detailWith({'wing_texture': 'Velvety'}));

    expect(find.text('Field notes'), findsOneWidget);
  });

  testWidgets('renders nothing when the species has no values', (tester) async {
    remote.fieldDefinitions = const [
      SpeciesFieldDefinition(fieldKey: 'wing_texture', label: 'Wing texture'),
    ];
    await pump(tester, detailWith(const {}));

    expect(find.text('Wing texture'), findsNothing);
  });

  testWidgets('skips values with no definition', (tester) async {
    // A key the app has no definition for — either admin-only or retired. It
    // must not be rendered under its raw storage key.
    remote.fieldDefinitions = const [
      SpeciesFieldDefinition(fieldKey: 'wing_texture', label: 'Wing texture'),
    ];
    await pump(tester, detailWith({'internal_note': 'needs a better photo'}));

    expect(find.text('needs a better photo'), findsNothing);
    expect(find.text('internal_note'), findsNothing);
  });

  testWidgets('skips empty values', (tester) async {
    remote.fieldDefinitions = const [
      SpeciesFieldDefinition(fieldKey: 'wing_texture', label: 'Wing texture'),
      SpeciesFieldDefinition(
          fieldKey: 'local_names', label: 'Local names', fieldType: 'list'),
    ];
    await pump(tester, detailWith({'wing_texture': '   ', 'local_names': []}));

    expect(find.text('Wing texture'), findsNothing);
    expect(find.text('Local names'), findsNothing);
  });

  testWidgets('renders nothing when definitions fail to load', (tester) async {
    remote.fail = true;
    await pump(tester, detailWith({'wing_texture': 'Velvety'}));

    expect(find.text('Velvety'), findsNothing);
  });
}
