import 'package:course_explorer/services/course_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'loadCourses reads courses from the JSON asset as Course models',
    () async {
      final courses = await CourseService().loadCourses();

      expect(courses, isNotEmpty);
      for (final course in courses) {
        expect(course.code, isNotEmpty);
        expect(course.title, isNotEmpty);
        expect(course.credits, greaterThan(0));
        expect(course.status, isNotEmpty);
      }
    },
  );
}
