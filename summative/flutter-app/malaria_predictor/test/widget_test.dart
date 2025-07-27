import 'package:flutter_test/flutter_test.dart';
import 'package:malaria_predictor/main.dart';

void main() {
  testWidgets('App shows Predict button and title', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MalariaPredictApp());

    // Verify the app bar title is displayed
    expect(find.text('Malaria Case Predictor'), findsOneWidget);

    // Verify the Predict button is present
    expect(find.text('Predict'), findsOneWidget);
  });
}
