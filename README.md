# Simple-POS



A mobile POS written in _Flutter_, suitable for small cafe/restaurant, fully offline.

**Tested & printable on **Sunmi V1S** device.**

![sunmi_v1s](.github/resource/2.png)

**Support:**

- Android
- Web (unable to print, yet)
- English & Vietnamese (auto detect Locale)

---

## Install & Run

Get [flutter](https://flutter.dev/)

```
flutter pub get
flutter run
```

**For web**

1. `flutter config --enable-web`
2. `flutter run -d chrome --web-renderer canvaskit`

**For emulator**
1. `flutter run`

## Testing

`flutter test`

## TODO
- [ ] Remote printing? (via Bluetooth)
