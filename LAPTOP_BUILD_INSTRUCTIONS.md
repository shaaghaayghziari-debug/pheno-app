# PHENO — laptop + Codemagic build instructions

## What was fixed in this package

The uploaded project did not contain the generated Flutter `ios/` and `android/` platform folders. That is the direct reason the earlier iOS build could not find an Xcode project.

The Codemagic workflow has been made explicit so that it:
1. generates the missing iOS/Android runners on the cloud build machine;
2. runs `flutter pub get`;
3. runs `flutter analyze`;
4. actually builds an iOS Release IPA;
5. actually builds an Android Release APK;
6. publishes the resulting files as Codemagic artifacts.

The app code and the PHENO feature architecture were not intentionally rewritten.

## On the laptop

1. Extract this ZIP.
2. Open the extracted `pheno` folder.
3. Push the whole folder to the GitHub repository connected to Codemagic.
4. Make sure `codemagic.yaml` is in the repository root.
5. In Codemagic, select the YAML/codemagic.yaml workflow for the app. Do not use the old empty Workflow Editor configuration.
6. For iOS, connect Apple signing/App Store Connect credentials in Codemagic. The bundle identifier used by this workflow is:
   `com.pheno.app`
7. Start the iOS workflow and Android workflow separately.

## Important

A successful Codemagic build is not enough by itself. In the build page, the Publishing/Artifacts section must show an `.ipa` for iOS and an `.apk` for Android.

If `flutter analyze` reports a Dart error, fix that error before the release build. This package was inspected statically here, but an actual Flutter SDK/Xcode build was not available in this environment.
