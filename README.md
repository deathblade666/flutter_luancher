<p align="center">
  <img src="https://github.com/deathblade666/flutter_launcher/blob/3d5efb56d8d912cf97836d1730d918bf92aa29d2/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png">
</p>

# flutter_launcher

Unname as of yet, this flutter project is an android launcher. The idea is to have a modern, minimalistic UI without compromising on access to data when you need it. Inspired by [KISS](https://github.com/Neamar/KISS/) and [Kvaesitso](https://github.com/MM2-0/Kvaesitso).

## Features

### Current
 - Search and launch apps via return or tapping on the list item
 - Use your preferred search engine from your home screen
 - Navigate to a site directly from your home screen
 - Set Favorites for quick access (currently up to 4)
 - Modular UI, only show the UI elements you need/want
   - show/hide bottom widget pull bar
   - show/hide favorites
   - show/hide system status bar
 - Custom Widgets
   - Calendar
     - Create events
     - Modify events
   - Checklist
     - simple checklist
   - Notes
     - create quick notes without ever leaving your homescreen
 - Custom Widget order
 - uninstall apps
 - easily access system settings for specific apps

To see planned feature and what is currently working on checkout the [Project](https://github.com/users/deathblade666/projects/2).

## Build

``
git clone https://github.com/deathblade666/flutter_launcher
``

``
cd flutter_launcher
``

``
flutter pub get
``

### Update installed_apps (dep) compilSDK

``
cd ~/.pub-cache/hosted/pub.dev/installed_apps-1.5.0/android
``

``
vim build.gradle
``

Change compileSDK from 30 to 34
save and exit

``cd`` to the directory you cloned to.

run ``flutter build apk``

## Showcase

|Home screen | Favorites | Settings |
|--|--|--|
| ![alt](https://github.com/deathblade666/flutter_launcher/blob/ff093da368df531a681971d2554e0317e3613f6c/screenshots/Screenshot%20from%202024-09-18%2014-40-34.png)|![alt](https://github.com/deathblade666/flutter_launcher/blob/78c59e7e86f6e0871a92862655a66f1970fc4fbf/screenshots/Screenshot%20from%202024-10-01%2019-55-52.png)|![alt](https://github.com/deathblade666/flutter_launcher/blob/099c07eebc1bf539fabb8f97c292a7c10ac5e84a/screenshots/Screenshot%20From%202024-11-03%2013-57-23.png) |

## Widgets

|Checklist|Calendar|Notes|
|--|--|--|
| ![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-33.png)| ![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-37.png)|![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-42.png)|


## Default Flutter README Stuff
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
