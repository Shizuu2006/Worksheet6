import 'package:flutter_test/flutter_test.dart';

import 'package:course_explorer/identity.dart';
import 'package:course_explorer/main.dart';

void main() {
  testWidgets('Nama dan NIM mahasiswa tampil di aplikasi', (tester) async {
    await tester.pumpWidget(const CourseExplorerApp());
    await tester.pump();

    expect(find.textContaining(studentId), findsWidgets);
    expect(find.textContaining(studentName), findsWidgets);
  });

  testWidgets('Course Explorer renders course list', (tester) async {
    await tester.pumpWidget(const CourseExplorerApp());
    await tester.pump();

    expect(find.text('Course Explorer'), findsOneWidget);
    expect(find.text('Pemrograman Mobile'), findsOneWidget);
    expect(find.text('IF101'), findsOneWidget);
  });
}
