# Flutter Google Gemini Integration

This Flutter application interacts with the Google Gemini API to send requests and receive responses. The app supports both text and image-based responses, allowing users to interact with the API seamlessly.

## Features

- Send text queries to the Google Gemini API
- Display text-based responses from Gemini
- Upload images for the Gemini API to analyze and respond
- Handle both text and image-based responses from the API
- Easy-to-use UI for interacting with the API

## Prerequisites

Before you start, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A Google Cloud Project with the [Google Gemini API](https://cloud.google.com/gemini) enabled (or the relevant API if you're using a specific model like Google’s Vision API, for example).
- Dart version 2.18 or higher

## Setup

### 1. Clone this repository

```bash
git clone https://github.com/sidhant947/Gemini-Sample.git
cd flutter-google-gemini-integration
```

### 2. Install dependencies

Run the following command to get all the dependencies:

```bash
flutter pub get
```

### 3. Set up API Credentials

To authenticate with the Google Gemini API, you need to generate API credentials in your Google Cloud Console. Follow these steps:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing project.
3. Navigate to the **API & Services > Credentials** section.
4. Create an API key or a service account key and store it securely.
5. Place the generated key in .env.

### 4. Build and Run the App

You can now build and run the app on your desired platform (Android, iOS, etc.):

```bash
flutter run
```

## Usage

The app provides a simple interface with a text input field to send queries and a button to trigger the interaction with the Google Gemini API.

### 1. Sending Text Input

- Type your query in the text input field.
- Press the "Send Query" button.
- The app will send the text to the Gemini API and display the response on the screen.

### 2. Sending Images

- Tap on the "Choose Image" button to pick an image from your gallery or camera.
- The image will be uploaded to the Gemini API for analysis.
- The app will display the response (e.g., a description or analysis of the image).

### 3. Response Handling

The API will return either a text-based response or an image-based response depending on your query or the uploaded image.

#### Example Response:

For a text query:

```
Gemini says: "This is a great question! Here's the response you were looking for."
```

For an image analysis:

```
Gemini says: "This image contains a cat with a ball."
```

## Code Structure

- `lib/`: Contains all Flutter application files.
  - `main.dart`: Entry point of the application.
  - `homescreen.dart`: Home Page of application.
  - `widgets/`: UI components ChatScreen and Message widgets.

## Troubleshooting

- **API Errors:** Ensure that your API key is correct and has the necessary permissions.
- **Image Upload Issues:** Make sure the image file is correctly formatted and within the size limits defined by the API.
- **Network Errors:** Check if your device has a stable internet connection.

## Contributing

Feel free to fork the repository, open issues, and submit pull requests. Contributions are always welcome!

## License

    Gemini Sample
    Copyright (C) 2024  Sidhant

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

### Notes:

- For security, remember to avoid exposing your API keys directly in the code. Consider using environment variables or Flutter's secure storage for sensitive data.
