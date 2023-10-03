![my badge](https://img.shields.io/badge/Made%20with-Flutter-blue?style=for-the-badge&logo=flutter)  &nbsp;  &nbsp; ![my badge](https://img.shields.io/github/last-commit/Krishak15/Barometer-WearOS/main?style=for-the-badge) 

[![forthebadge](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxODcuMTg3NSIgaGVpZ2h0PSIzNSIgdmlld0JveD0iMCAwIDE4Ny4xODc1IDM1Ij48cmVjdCB3aWR0aD0iOTMuNTM3NDk4NDc0MTIxMSIgaGVpZ2h0PSIzNSIgZmlsbD0iIzFhOTRiYSIvPjxyZWN0IHg9IjkzLjUzNzQ5ODQ3NDEyMTEiIHdpZHRoPSI5My42NTAwMDE1MjU4Nzg5IiBoZWlnaHQ9IjM1IiBmaWxsPSIjZTZkMTAwIi8+PHRleHQgeD0iNDYuNzY4NzQ5MjM3MDYwNTUiIHk9IjE3LjUiIGZvbnQtc2l6ZT0iMTIiIGZvbnQtZmFtaWx5PSInUm9ib3RvJywgc2Fucy1zZXJpZiIgZmlsbD0iI0ZGRkZGRiIgdGV4dC1hbmNob3I9Im1pZGRsZSIgYWxpZ25tZW50LWJhc2VsaW5lPSJtaWRkbGUiIGxldHRlci1zcGFjaW5nPSIyIj5CVUlMVCBGT1I8L3RleHQ+PHRleHQgeD0iMTQwLjM2MjQ5OTIzNzA2MDU1IiB5PSIxNy41IiBmb250LXNpemU9IjEyIiBmb250LWZhbWlseT0iJ01vbnRzZXJyYXQnLCBzYW5zLXNlcmlmIiBmaWxsPSIjRkZGRkZGIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmb250LXdlaWdodD0iNTAwIiBhbGlnbm1lbnQtYmFzZWxpbmU9Im1pZGRsZSIgbGV0dGVyLXNwYWNpbmc9IjIiPldFQVIgT1M8L3RleHQ+PC9zdmc+)](https://forthebadge.com)

&nbsp;

# Barometer WearOS

This Flutter app is designed for Wear OS devices to access and display Barometer values, Location data, and Altitude information. It utilizes Flutter's cross-platform capabilities to deliver sensor data directly to your wrist. This README provides an overview of the app's features.
&nbsp;
<div id="image-container">
  <img src="screenshots/Barometer.png" alt="Poster">
</div>
&nbsp;
&nbsp;

**Note**: Before using this app, please ensure that your Wear OS device supports the necessary sensors and permissions.

⚠️ Please note that this version is in **beta** and may contain bugs.
&nbsp;
## Features

- **Barometer Data**: Access real-time barometer readings.
- **Location Data**: Retrieve location information
- **Altitude Information**: Altitude based on location

**Note**: To enable geocoding functionality, please obtain an API key from the website https://locationiq.com/ and add it on appropriate dart file.

## Screenshots

<img src="screenshots/updated/img1.png" width="150"  /> &nbsp; <img src="screenshots/updated/img2.png" width="150"/>  &nbsp;
<img src="screenshots/updated/img3.png" width="150"/> &nbsp; <img src="screenshots/updated/img4.png" width="150"/> 
&nbsp; <img src="screenshots/updated/img5.png" width="150"/> &nbsp; <img src="screenshots/updated/img6.png" width="150"/> 

## How to debug

1) Enable developer options on your WearOS device.
2) Enable USB Debugging and Wireless debugging.
3) Both PC and Watch should be on same Wi-Fi network.
4) Pair device using ```adb pair <IP of device>``` then enter pairing code when prompted for secure TCP/IP communication.
5) ```adb pair``` is used for wifi pairing your device with Android >= 11, while ```adb connect``` can be used to connect directly to a device with Android <11 over wifi.
6) Either you can debug directly or Build app using ```flutter build apk``` command and install the app using ```adb install <path to .apk file>``` **recommended**

## How to install

1) Do the same steps as above in **How to debug** section tiil **Step 5**.
2) Then copy downloaded file to PC and run command prompt in the same folder. 
3) Install the app using ```adb install <path to .apk file>``` (PC). You can also use your android phone to install app; use **GeminiMan** WearOS Manager app from playstore.
4) Enjoy the app.

   
   

  
&nbsp;
&nbsp;

Lava lamp Animation credit - https://github.com/RetroMusicPlayer/Paisa


