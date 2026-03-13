// integration_test/all_tests.dart
// Combined entry point for all integration tests.
//
// Running a single file means Flutter builds ONE test APK and installs it
// once, avoiding the install/uninstall cycle (and the accompanying
// DELETE_FAILED_INTERNAL_ERROR on the first run) that occurs when the
// runner is pointed at an entire directory.
//
// Add new test files here as they are created.

import 'app_test.dart' as app_test;
import 'journal_flow_test.dart' as journal_flow_test;

void main() {
  app_test.main();
  journal_flow_test.main();
}
