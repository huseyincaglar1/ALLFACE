# ALLFACE - Emotion-Based Activity Suggestion App

**ALLFACE** is a Flutter-based mobile application that leverages real-time emotion recognition using facial expressions and suggests personalized activities based on the detected emotion and the user's profile information. The application integrates machine learning (TensorFlow Lite) and Firebase to enhance user experience and personalization.

## Features
- **Real-Time Emotion Detection**: Uses a TensorFlow Lite model to analyze facial expressions (happy, sad, angry) and detect dominant emotions.
- **Activity Suggestions**: Recommends activities based on the detected emotion and user profile data
- **User Authentication**: Firebase Authentication for secure user login and registration.
- **Personalized Activity Suggestions**: Activity suggestions are refined over time based on user preferences stored in Firebase.

## Project Structure
The project is designed with a clean, modular architecture following Flutter's best practices. Below is an overview of the key components:

### 1. **Authentication (`auth_page.dart`)**
   - Manages user sign-in and registration using Firebase Authentication.
   - Ensures secure access to other parts of the app by authenticating users before providing suggestions.

### 2. **Home Page (`home_page.dart`)**
   - Acts as the main landing page after login, offering access to the app's features.
   - Provides user navigation to the camera, profile, and suggestion pages.

### 3. **Camera Page (`camera_page.dart`)**
   - Integrates the device camera to capture real-time video feed.
   - Analyzes facial expressions using a TensorFlow Lite model to detect the user's emotion.
   - Displays the recognized emotion at the bottom of the screen.

### 4. **Suggestion Page (`suggestion_page.dart`)**
   - Displays activity suggestions based on the emotion detected on the Camera Page and the user's profile.
   - Contains the following buttons:
     - **Most Preferred Personal Choice**: Displays a list of activities frequently chosen by the user.
     - **General Most Preferred Choices**: Shows a list of activities popular among other users.
   - Routes to the **Activity Page** for detailed information on selected activities.

### 5. **Profile Page (`profile_page.dart`)**
   - Allows users to view and edit personal profile information such as name, age, gender, and occupation.
   - Profile data is fetched and stored in Firebase Firestore for real-time updates.

### 6. **Settings Page (`setting_page.dart`)**
   - Enables users to customize app settings such as theme selection (light/dark mode) and notifications.

### 7. **Activity Page (`activity_page.dart`)**
   - Provides detailed information about a suggested activity.
   - Includes a validation button that, once clicked, saves the user’s activity preference to Firebase for future recommendations.

## Technical Overview

### Flutter Framework
The application is developed using Flutter, a cross-platform framework that allows a single codebase to be deployed on both Android and iOS platforms. 

### TensorFlow Lite Integration
- The TensorFlow Lite model is used for emotion recognition based on facial expressions. The camera feed is continuously analyzed, and the dominant emotion is detected in real-time.
- Model integration is handled in the **`camera_page.dart`** using the TFLite plugin.

### Firebase Integration
- **Firebase Authentication**: Secure sign-in and registration for users.
- **Firebase Firestore**: Stores user profile data, such as name, age, gender, and occupation, which are used to personalize activity suggestions.
- **Firebase Hosting**: Can be used to serve APIs or additional web resources, though not used in this implementation.

### State Management
- The project uses the **Provider** package for state management. This allows efficient handling of themes, user preferences, and model data without performance degradation.
- **MultiProvider** is used to combine multiple providers, including `ThemeProvider` for dynamic theme changes and `MyProvider` for handling custom user data.

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MyProvider(),
    ),
  ],
  child: const MainApp(),
);
```
### Activity Suggestions (API Integration)
The activity suggestions are fetched from a Flask-based REST API that takes into account user emotions, preferences, and profile information. The API logic is abstracted from the Flutter app, providing flexibility for future model improvements.

## Setup Instructions
For detailed setup instructions, please refer to the [Setup Instructions PDF](docs/setup_instructions.pdf).

### Technical Stack
- Flutter: The mobile framework used for building cross-platform applications.
- Firebase: Handles user authentication and Firestore for real-time data storage.
- TensorFlow Lite: Integrated for real-time emotion recognition from the camera feed in the user device.
- Flask-based RestAPI: abstracted from the Flutter app, providing the activity based on the user's information
- Provider: State management solution used for maintaining global app state (theme, user data).

### Future Improvements
- Improve Emotion Model Accuracy: Increase accuracy by further training the model with diverse datasets.
- Refine Activity Suggestions: Enhance personalization based on user behavior and preferences.
- Support for More Platforms: Expand to web and desktop platforms using Flutter’s multi-platform capabilities.
