# AmbientRecordingApp

Quick demo of bi-directional sync with an app and a mock server sharing an API contract.

The app should sync data efficiently and robustly, and needed to be done quickly (in one day). Many shortcuts are made for that reason, but I hope you don't see them right away!

Please see detailed notes on the project and decisions made in `Documentation/`.


### Server Set Up

The mock server is easy to set up and run if you have Node installed locally:

```
cd MockServer
npm i
node server.mjs
```

### Web App Set Up
The web app uses Vite to run locally:

```
# install dependencies
yarn
# run in local development mode
yarn dev
```

### Running iOS App Locally

Running a native iOS application requires macOS and Xcode.

1. **Prereqs**
    - macOS 12+, **Xcode 15**+ (free on the Mac App Store)
    - No paid Apple Developer account required—Xcode Simulator works out-of-the-box. If you do want to run on a physical device you can use a free Apple ID for code-signing.
2. **Run**
    - Choose **“iPhone 15 Pro (Simulator)”** and press ▶️. Xcode will build & launch.
    - Confirm you can **create and view appointments** (server must be running).

### Creating records

The app is capable of creating both Appointment and Recording entities. Additionally, there are some scripts in `MockServer/samples` that make use of the same API through the command line, to test bi-directional sync.

<img src="/Documentation/Screenshots/Simulator Screenshot - iPhone 15 Pro - 2024-03-10 at 10.07.15.png?raw=true" width=400/> <img src="/Documentation/Screenshots/Simulator Screenshot - iPhone 15 Pro - 2024-03-10 at 10.07.32.png?raw=true" width=400/>

<img src="/Documentation/Screenshots/Screenshot 2024-03-10 at 10.39.14 AM.png?raw=true" width=800/>
