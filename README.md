# Task Manager

Task Manager is a Flutter application for task management. It allows users to create, update, and delete tasks, as well as synchronize them with Firebase Realtime Database.

## Overview

The Task Manager application is designed to help users manage their tasks efficiently. Tasks can be created, updated, and deleted, and they automatically sync with Firebase Realtime Database when an internet connection is available. When offline, tasks are stored locally and synchronized once the connection is restored.

## Setting Up and Running the Project Locally

Follow these steps to set up and run the project locally:

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 2.0 or higher)
- [Dart](https://dart.dev/get-dart)
- [Firebase CLI](https://firebase.google.com/docs/cli)

### Clone the Repository

```sh
git clone https://github.com/srios007/task_manager
cd task_manager
flutter pub get
flutter run
```

## Architecture and Design Patterns

The Task Manager application uses the **Provider** design pattern for state management. Below is a brief description of the architecture and design patterns used:

### Provider

**Provider** is a Flutter package that simplifies state management and dependency injection. In Task Manager, Provider is used to manage the state of tasks and provide access to Firebase and connectivity services.

## Project Structure

The project is organized into the following folders:

```
📂 task_manager
│-- 📂 lib
│   │-- 📂 models          # Contains model classes, such as TaskModel.
│   │-- 📂 providers       # Contains state providers, such as TaskProvider.
│   │-- 📂 services        # Contains services, such as TaskService and ConnectivityService.
│   │-- 📂 screens         # Contains application screens, such as Home and NewTask.
│   │-- 📂 widgets         # Contains reusable widgets, such as TaskButton and TaskContainer.
```

## Firebase Synchronization

The application uses **Firebase Realtime Database** to store and synchronize tasks.

- **With an internet connection:** Tasks are automatically synchronized with Firebase.
- **Without an internet connection:** Tasks are stored locally using **GetStorage** and synchronized once the connection is restored.

## Unit Testing

The project includes unit tests to verify the functionality of providers and widgets. The tests are located in the `test` folder and use the **mockito** package to create mocks of services and simulate Firebase responses.

```sh
flutter test
```

