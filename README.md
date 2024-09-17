# Dashboard42

**Dashboard42** is an iOS app designed for students of School 42. It provides easy access to intranet 42 information directly from your iPhone, with a set of features to simplify the management of your academic journey.

## Features

- **Access to student profile**: View your personal information and your progress in the course.
- **Project Viewing**: Access the list of available projects, their description and your results.
- **Correction Tracking**: Schedule and track your correction appointments.
- **Real-time statistics**: Track your ranking, progress points, skills and current level.
- **Events Calendar**: Stay informed about events and meetings organized within 42.
- **Connection History**: Track your cluster connection times and recent activity.

## Prerequisites

- iOS 17 or later
- Valid account 42 to connect to the intranet via the API

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/Dashboard42/Dashboard42.git
    ```

2. Navigate to the project folder:

    ```bash
    cd Dashboard42
    ```

3. Open the project with Xcode:

    ```bash
    open Dashboard42.xcodeproj
    ```

4. Compile and run on your simulator or iOS device.

## Technologies used

- **SwiftUI**: Modern and responsive user interface.
- **API 42**: Retrieving data from the intranet.
- **Swift Package Manager**: Managing external dependencies.

## Contribute

Contributions are welcome! If you would like to suggest changes or improvements, please follow the steps below:

1. Fork the repository.
2. Create a branch for your feature or bugfix (`git checkout -b feature/new-feature`).
3. Make your changes and commit them (`git commit -am 'Adding new feature'`).
4. Push your branch (`git push origin feature/new-feature`).
5. Open a Pull Request.

You need to [create an application for 42's API]((https://profile.intra.42.fr/oauth/applications/new)) with the following redirection URI: `fr.marcmosca.Dashboard42://oauth2callback`.

After this, you need to create a configuration file (.xcconfig) to contains API credentials, like this:

```xcconfig
API_CLIENT_ID = <YOUR_CLIENT_ID_KEY>
API_CLIENT_SECRET = <YOUR_CLIENT_SECRET_KEY>
API_CALLBACK = /oauth2callback
API_REDIRECT_URI = fr.marcmosca.Dashboard42:/$(API_CALLBACK)
```

## Known Issues

- The application may have difficulty retrieving data when API 42 is under maintenance.

## Disclaimer

This project is not officially affiliated with 42 or any of its official entities. It is an independent project created by and for 42 students to enhance their experience. Use this app responsibly and respect the policies and guidelines of 42.

## Contact

You can send me an email at **mmosca@student.42lyon.fr**.
