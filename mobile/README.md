# mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### Hive model needs to build each time, model is changed or added
`flutter pub run build_runner build`

### Architecture of the project and documentation

https://shop-for-me.atlassian.net/wiki/x/AYDDAQ

## Verification and Running Tests

Ensure that all model files are up to date and that Hive TypeAdapters are generated.

### Generating Hive TypeAdapters

If you have made changes to your models or Hive annotations, run:

### Generating Mocks with Mockito

After modifying the @GenerateMocks annotations, run:

### Running Tests

Run the tests with:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner build --delete-conflicting-outputs
flutter test --coverage
```