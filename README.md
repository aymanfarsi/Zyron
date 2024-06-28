# Zyron

<p align="center">
  <a href="https://github.com/aymanfarsi/Zyron"><img src="assets/zyron_icon.png" alt="Zyron" height="120" /></a>
</p>

<p align="center">
  <strong>A simple desktop application written in Flutter to access and manage your favorite entertainment content.</strong>
</p>

## Contents

- [Features](#features)
- [Installation](#installation)
- [Building from source](#building-from-source)
- [Contributing](#contributing)
- [Credits](#credits)
- [License](#license)

## Features

- **Simple and intuitive interface**: Zyron is designed to be easy to use and navigate.
- **Customizable**: You can add your favorite content to the app and access it easily.
- **Cross-platform**: Zyron is built using Flutter, so it can run on Windows, macOS, and Linux.
- **Open-source**: Zyron is open-source and free to use.

## Installation

To use Zyron, you can run the installer or build the application from source.

## Building from source

To install build Zyron from source, you need to have Flutter installed on your system. You can follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install) to install it.

1. Clone the repository:

```bash
git clone https://github.com/aymanfarsi/Zyron.git
```

2. Reinitialize the project directory:

```bash
mv Zyron zyron
cd zyron
flutter create .
```

3. Build the project:

```bash
flutter build <platform>
```

Replace <platform> with the platform you want to build for (windows, macos, or linux)

4. The binary will be located in the `build/<platform>/` directory.

5. You can also run the application using the following command:

```bash
flutter run
```

Add the `--release` flag to run the application in release mode.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have any ideas, bug reports, or feature requests.

1. Fork the repository and clone it to your local machine.
2. Create a new branch for your changes.
3. Make your changes and commit them.
4. Push the changes.
5. Submit a pull request.

## Credits

Zyron is built using the following technologies:

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/)

## License

Zyron is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
