# Malaria Case Prediction Summative

## Mission & Problem

My mission statement is in healthcare. Building a telemedecine web based application, that will improve heathcare system in hospital, and easy access to doctors.

## API Endpoint

* **Swagger UI**: [https://rwanda-malaria-api.onrender.com/docs]
* **Prediction**:

  ```http
  POST https://rwanda-malaria-api.onrender.com/predict
  Content-Type: application/json

  {
    "year": 2016,
    "deaths_median": 3500
  }
  ```

## Demo Video

[https://youtu.be/YOUR\_VIDEO\_ID](https://youtu.be/ynBSH1zHCp4)

## Running the Flutter Mobile App

1. **Open Android Studio or VS code**:

   * Connected device or emulator
2. **Configure API URL**:

   * In `lib/main.dart`, set: //so that you can get a reponse when you click on the button predict.

     ```dart
     static const String apiUrl = 'https://rwanda-malaria-api.onrender.com/predict';
     ```
3. **Install dependencies & run**:

   ```
   flutter pub get
   flutter run
   ```
4. **Usage**:

   * Enter a year between (2000–2030)
   * Enter median deaths (≥0)
   * Tap **Predict**, you will see predicted numbers and that's it.
