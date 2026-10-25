import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_lab8_smart_catalog/main.dart';

void main() {
  testWidgets('list feed uses ListView.separated with dividers', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartCatalogApp());
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Divider), findsWidgets);
    expect(find.text('Wireless Headphones'), findsOneWidget);
    expect(find.text('12 items'), findsOneWidget);
  });

  testWidgets('toggle switches to 2-column grid without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.tap(find.byTooltip('Show as grid'));
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
    expect(delegate.childAspectRatio, 0.72);
    expect(tester.takeException(), isNull); // no RenderFlex overflow

    await tester.tap(find.byTooltip('Show as list'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsNothing);
  });

  testWidgets('pull-to-refresh adds a new item at index 0 after 1.5 s', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.fling(
      find.text('Wireless Headphones'),
      const Offset(0, 400),
      1000,
    );
    await tester.pump(); // start refresh
    await tester.pump(const Duration(seconds: 1)); // indicator visible
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    expect(find.text('13 items'), findsNothing); // still "loading"
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('13 items'), findsOneWidget);
    final firstTitle = tester.widget<Text>(
      find
          .descendant(
            of: find.byType(ListTile).first,
            matching: find.byType(Text),
          )
          .first,
    );
    expect(
      firstTitle.data,
      'Studio Microphone #100',
    ); // generated item at index 0
  });

  testWidgets('swipe deletes, UNDO restores at original index', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.drag(find.text('Smart Watch Series 5'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(find.text('Smart Watch Series 5'), findsNothing);
    expect(find.text('11 items'), findsOneWidget);
    expect(find.text('UNDO'), findsOneWidget);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('12 items'), findsOneWidget);

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => (t.title as Text).data)
        .toList();
    expect(titles[1], 'Smart Watch Series 5'); // back at index 1
  });

  testWidgets('empty state appears and Reset Catalog restores seed', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartCatalogApp());
    for (var i = 0; i < 12; i++) {
      await tester.drag(find.byType(ListTile).first, const Offset(-600, 0));
      await tester.pumpAndSettle();
    }
    expect(find.text('Catalog is Empty'), findsOneWidget);
    expect(find.text('0 items'), findsOneWidget);

    await tester.tap(find.text('Reset Catalog'));
    await tester.pumpAndSettle();
    expect(find.text('12 items'), findsOneWidget);
    expect(find.text('Wireless Headphones'), findsOneWidget);
  });

  testWidgets('grid has no overflow on small and large phones', (tester) async {
    for (final size in const [Size(320, 640), Size(430, 932)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const SmartCatalogApp());
      await tester.tap(find.byTooltip('Show as grid'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
    addTearDown(tester.view.reset);
  });
}
