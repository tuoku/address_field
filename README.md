<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->





# AddressForm
A drop-in address form with autocomplete and validation.

https://user-images.githubusercontent.com/70937274/219762068-59e82d12-dba0-49a8-bc21-e89e1f8f23aa.mp4

## Features

- Address autocomplete
- Returns a formatted address as well as individual address components and coordinates

## Getting started

Add `address_form` as a dependency in your pubspec.yaml file

```
flutter pub add address_form
```

Import PhotoX:
```dart
import 'package:address_form/address_form.dart';
```

## Usage

```dart
final mainKey = GlobalKey<AddressFormState>();

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AddressForm(
              apiKey: "",
              mainKey: mainKey,
              key: mainKey,
            )
          ],
        ),
      );
    }
```
