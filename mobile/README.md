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

---

### Hive model needs to build each time, model is changed or added
```bash
flutter pub run build_runner build
```

### Architecture of the project and documentation

https://shop-for-me.atlassian.net/wiki/x/AYDDAQ

---

## Verification and Running Tests

Ensure that all model files are up to date and that Hive TypeAdapters are generated.

### Generating Hive TypeAdapters

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Generating Mocks with Mockito

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running Tests

Run the tests with:

```bash
flutter test --coverage
```

---

### Viewing Test Coverage as HTML

#### 🐧 Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install lcov
```
```bash
genhtml coverage/lcov.info -o coverage/html
xdg-open coverage/html/index.html
```

#### 🍎 macOS
```bash
brew install lcov
```
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

#### 🪟 Windows
1. Installer `lcov` via Chocolatey :
```powershell
choco install lcov
```
2. Générer et ouvrir le rapport HTML :
```powershell
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

> 💡 Astuce : tu peux aussi utiliser l’extension VS Code **Coverage Gutters** pour visualiser directement la couverture dans ton éditeur.

