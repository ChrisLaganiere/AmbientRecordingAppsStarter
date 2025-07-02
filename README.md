# AmbientRecordingAppsStarter

Quick demo of bi-directional sync with a server and web/iOS clients, sharing an API contract.

The API is described in detail in `Documentation/` folder. It is only partially implemented here.

Your task is to enhance the quality guards on this project by adding and improving tests, CI, or anything else you can think of!

### Server Set Up

The mock server is easy to set up and run if you have Node installed locally:

```
# Ensure you have the right version of Node running
nvm install
nvm use

# install dependencies
yarn

# run web server and host web client locally
yarn dev
```

Then, navigate to `http://localhost:3000` to see the web app.

Or, run tests:

```
yarn test
```

### Using the API

The server API supports creating both Appointment and Recording entities. You can test it by running `yarn test`, by clicking through the web app at `localhost:3000`, by running the iOS app, or by executing scripts in `server/samples` that make use of the same API through the command line.

<img src="/Documentation/Screenshots/Screenshot 2024-03-10 at 10.39.14 AM.png?raw=true" width=800/>

### Running iOS App Locally

Running a native iOS application requires macOS and Xcode. You are not required to run the app for this exercise, but we appreciate seeing your skill if you are confident writing tests for an iOS app.

1. **Prereqs**
    - macOS 12+, **Xcode 15**+ (free on the Mac App Store)
    - No paid Apple Developer account required—Xcode Simulator works out-of-the-box. If you do want to run on a physical device you can use a free Apple ID for code-signing.
2. **Run**
    - Choose **“iPhone 15 Pro (Simulator)”** and press ▶️. Xcode will build & launch.
    - Confirm you can **create and view appointments** (server must be running).

<img src="/Documentation/Screenshots/Simulator Screenshot - iPhone 15 Pro - 2024-03-10 at 10.07.15.png?raw=true" width=400/> <img src="/Documentation/Screenshots/Simulator Screenshot - iPhone 15 Pro - 2024-03-10 at 10.07.32.png?raw=true" width=400/>
