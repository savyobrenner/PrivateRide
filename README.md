**Note**: Occasionally, unit tests may fail to run on simulators due to a bug in Xcode 16. If this happens, try running the tests on a physical device or on simulators with iOS versions below 18, where they are confirmed to work correctly.

# 📱 Private Ride

An iOS app built for private ride requests, integrating with simulated backend endpoints. Developed in SwiftUI, utilizing MVVM-C (Model-View-ViewModel-Coordinator) architecture. Dependency injection is managed using the Factory library.

## ✨ Features

- Request a ride by providing **origin**, **destination**, and **user ID**, with error handling to ensure valid inputs.
- **Map View**: Displays the user’s current location (with permission) and provides address suggestions using Apple's API. A preliminary route is generated locally based on the suggested addresses, enhancing the user experience.
- **Address Input Validation**: The input fields for ride estimation handle errors effectively, ensuring that fields are not left empty or filled with only whitespace characters.
- **Ride Details View**: Displays the route and available drivers, allowing the user to confirm the ride only when a driver is selected. Includes handling for empty states when data is unavailable.
- **Ride History Screen**: Shows past rides with empty state handling, field validation, and ensures that a driver is selected for filtering.
- **Multilingual Support**: The app supports **four languages**: Portuguese, English, French, and Spanish.
- **Analytics Integration**: Built-in analytics infrastructure for tracking app usage and events.
- **Unit Tests**: Unit tests for core functionalities to ensure stability and reliability across scenarios.

## 🧩 Design System

A **design system** with **atomic and molecular components** was implemented for consistent reuse throughout the app, ensuring better maintainability and scalability:

### Atoms
- **PRButton**: A customizable button component that adheres to the app's design standards.
- **PRFormSectionHeader**: A header component for organizing form sections with consistent styling.
- **PRMapView**: A map view component that displays user location and routes with ease.
- **PRRideOptionCard**: A small, reusable card component for showcasing the rides.
- **PRTextField**: A custom text field.

### Molecules
- **PRTripCard**: A card component designed to display trip details like origin, destination, driver, and cost.
- **PRAddressFormView**: A reusable form component for capturing user input such as origin and destination.
- **PRBottomSheet**: A customizable bottom sheet view for presenting additional details or actions.
- **PRFloatingAlert**: A modular floating alert system that includes:
  - **PRFloatingAlertModel**: Defines the data structure for the alert.
  - **PRFloatingAlertType**: Enum representing different alert types (e.g., success, error).
  - **PRFloatingAlertView**: The visual component for displaying floating alerts.

By implementing this system, the app achieves a modular architecture with enhanced readability, reusability, and maintainability.

## 🔗 Dependencies

The app utilizes the following dependencies to enhance functionality and development efficiency:

- **Factory**: Used for dependency injection, enabling better modularity and testability by decoupling components and managing dependencies efficiently.
- **IQKeyboardManager**: Automatically handles the keyboard appearance and dismissal, ensuring a seamless user experience when interacting with input fields.

## 🎨 Code Style Best Practices

- Proper **indentation and line breaks** to ensure code readability.
- **No force unwrapping**: Ensuring code safety and preventing unexpected crashes.
- **Decoupled ViewModels and Services**: Dividing responsibilities and making the code more modular.
- **Minimum deployment target: iOS 15**: For a more stable version of SwiftUI framework.

## 🚀 How to Run the Project

1. Clone the repository to your machine:
2. Open the project in **Xcode**.
3. Ensure that all **SPM dependencies** are properly fetched:
   - Go to **File** > **Packages** > **Resolve Package Versions**.
   - Alternatively, open the **Package Dependencies** section in the project navigator and verify if the dependencies are downloaded.
4. Select the simulator of your choice or a physical device.
5. Compile and run the project by clicking the Run button or pressing **Cmd + R**.

## 🧪 Running Tests

1. Clone the repository to your machine:
2. Open the project in **Xcode**.
3. Select the simulator of your choice or a physical device (with iOS below 18 - Xcode's bug / this happen sometimes).
4. Press Cmd + U to build and run all the tests.

## 📜 Project Structure

- **Coordinators/**: Contains all the Coordinators that manage the navigation between screens.
- **Views/**: Contains all the Views, developed in SwiftUI.
- **ViewModels/**: Contains the logic and business rules associated with each View.
- **Models/**: Contains the app's data structures.
- **Services/**: Contains services for API communication and network logic.
- **Components/**: Reusable components, such as `PRTextField` and `PRTripCard`.
