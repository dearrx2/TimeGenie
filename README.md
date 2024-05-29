# Time Genie

Time Genie is a productivity application designed to streamline team management and enhance workflow efficiency, especially in remote work environments. This app provides essential features such as task management, leave requests, and schedule tracking, all within a user-friendly interface.

## Features

- **Check-In Functionality**: Allows users to check in online by taking a selfie, letting the team know they are ready to start their workday.
- **To-Do List**: Users can easily add, delete, and prioritize tasks, helping them stay organized throughout the day. Tasks can be marked as complete once finished.
- **Leave Requests**: Users can submit leave requests directly through the app, making the process quick and seamless. Managers can approve or reject these requests within the app, providing feedback as necessary.
- **Calendar**: Keep track of the team’s schedule with ease, ensuring everyone stays on the same page and deadlines are met. The calendar displays work schedules, leave dates, and important deadlines.
- **Notifications**: Users receive real-time updates on the status of their leave requests and other important reminders.

## Technologies Used

- **Programming Language**: Dart
- **Framework**: Flutter
- **Backend**: Firebase (Firestore for database, Authentication)
- **State Management**: Provider
- **Internationalization**: Flutter Internationalization (intl)

## Installation

To get a local copy up and running, follow these simple steps:

1. Clone the repository:
   ```bash
   git clone git@github.com:dearrx2/TimeGenie.git

2. Navigate to the project directory:
   ```bash
   cd time-genie

3. Install the dependencies:
   ```bash
   flutter pub get

4. Run the app:
   ```bash
   flutter run

****make sure that you have flutter sdk****

## Getting Started

**1. Sign Up/Sign In** : Register a new account or sign in with an existing account using email and password or Google authentication.

**2. Check In**: Start your day by checking in online.

**3. Manage Tasks**: Use the To-Do List to add, delete, and prioritize your tasks.

**4. Request Leave**: Submit leave requests and keep track of their approval status.

**5. View Calendar**: Check the calendar for your team’s schedule and plan accordingly.

## Feedback
We value your feedback! Feel free to open an issue if you encounter any bugs or have suggestions for improvements.

## Folder PATH 

```
C:.
|   .gitignore
|   .metadata
|   analysis_options.yaml
|   directory-tree.txt
|   pubspec.lock
|   pubspec.yaml
|   
+---android
|   |   .gitignore
|   |   gradle.properties
|   |   settings.gradle
|   |   
|   +---app
|   |   |   google-services.json
|   |   |   
|   |   \---src
|   |       +---debug
|   |       |       AndroidManifest.xml
|   |       |       
|   |       +---main
|   |       |   |   AndroidManifest.xml
|   |       |   |   
|   |       |   +---kotlin
|   |       |   |   \---com
|   |       |   |       \---example
|   |       |   |           \---untitled
|   |       |   |                   MainActivity.kt
|   |       |   |                   
|   |       |   \---res
|   |       |       +---drawable
|   |       |       |       launch_background.xml
|   |       |       |       
|   |       |       +---drawable-v21
|   |       |       |       launch_background.xml
|   |       |       |       
|   |       |       +---mipmap-hdpi
|   |       |       |       ic_launcher.png
|   |       |       |       
|   |       |       +---mipmap-mdpi
|   |       |       |       ic_launcher.png
|   |       |       |       
|   |       |       +---mipmap-xhdpi
|   |       |       |       ic_launcher.png
|   |       |       |       
|   |       |       +---mipmap-xxhdpi
|   |       |       |       ic_launcher.png
|   |       |       |       
|   |       |       +---mipmap-xxxhdpi
|   |       |       |       ic_launcher.png
|   |       |       |       
|   |       |       +---values
|   |       |       |       styles.xml
|   |       |       |       
|   |       |       \---values-night
|   |       |               styles.xml
|   |       |               
|   |       \---profile
|   |               AndroidManifest.xml
|   |               
|   \---gradle
|       \---wrapper
|               gradle-wrapper.properties
|               
+---assets
|   +---animation
|   |       animation_loading.json
|   |       animation_rocket_sent.json
|   |       animation_success_sent.json
|   |       animation_success_todo.json
|   |       dancing_loading.json
|   |       notification.json
|   |       notification2.json
|   |       notification_with_red_dot.json
|   |       send_request.json
|   |       
|   +---images
|   |   |   bg_image.png
|   |   |   google.png
|   |   |   icon_back.png
|   |   |   logo.png
|   |   |   logo2.png
|   |   |   logoCheckIn.png
|   |   |   logo_app.png
|   |   |   undraw_no_pic.png
|   |   |   
|   |   +---background
|   |   |       afternoon_background.png
|   |   |       background.svg
|   |   |       evening_background.png
|   |   |       homepage_bg.png
|   |   |       morning_background.png
|   |   |       
|   |   +---calendar
|   |   |       annual.png
|   |   |       business.png
|   |   |       sick.png
|   |   |       wfh.png
|   |   |       
|   |   +---dialog
|   |   |       error_date_picker.svg
|   |   |       undraw_confirm.svg
|   |   |       
|   |   +---icon
|   |   |       approval_icon_black.png
|   |   |       approval_icon_white.png
|   |   |       
|   |   +---icon_tag_leave
|   |   |       annual_tag.png
|   |   |       business_tag.png
|   |   |       sick_tag.png
|   |   |       wfh_tag.png
|   |   |       
|   |   +---no_data
|   |   |       no_data.png
|   |   |       undraw_images_no_data.svg
|   |   |       undraw_throw_away.svg
|   |   |       
|   |   +---role
|   |   |       manager.png
|   |   |       manager_choose.png
|   |   |       senior.png
|   |   |       senior_choose.png
|   |   |       staff.png
|   |   |       staff_choose.png
|   |   |       
|   |   \---success_pictures
|   |           undraw_1.svg
|   |           undraw_10.svg
|   |           undraw_11.svg
|   |           undraw_12.svg
|   |           undraw_2.svg
|   |           undraw_3.svg
|   |           undraw_4.svg
|   |           undraw_5.svg
|   |           undraw_6.svg
|   |           undraw_7.svg
|   |           undraw_8.svg
|   |           undraw_9.svg
|   |           
|   +---language
|   |       en.json
|   |       th.json
|   |       
|   \---svg
|       |   empty_file.svg
|       |   finish_signup.svg
|       |   manager.svg
|       |   senior.svg
|       |   staff.svg
|       |   
|       +---calendar
|       |       annual.svg
|       |       business.svg
|       |       people.svg
|       |       sick.svg
|       |       wfh.svg
|       |       
|       +---request
|       |       add_calendar.svg
|       |       annual.svg
|       |       business.svg
|       |       sick.svg
|       |       wfh.svg
|       |       
|       +---setting
|       |       darkmode.svg
|       |       language.svg
|       |       profile.svg
|       |       reset_password.svg
|       |       
|       +---signup
|       |       signup.svg
|       |       
|       \---splash_screen
|               genie.svg
|               
+---fonts
|       OpenSans.ttf
|       Prompt-Medium.ttf
|       Prompt.ttf
|       Roboto.ttf
|       
+---ios
|   |   .gitignore
|   |   firebase_app_id_file.json
|   |   
|   +---Flutter
|   |       AppFrameworkInfo.plist
|   |       Debug.xcconfig
|   |       Release.xcconfig
|   |       
|   +---Runner
|   |   |   AppDelegate.swift
|   |   |   GoogleService-Info.plist
|   |   |   Info.plist
|   |   |   Runner-Bridging-Header.h
|   |   |   
|   |   +---Assets.xcassets
|   |   |   +---AppIcon.appiconset
|   |   |   |       Contents.json
|   |   |   |       Icon-App-1024x1024@1x.png
|   |   |   |       Icon-App-20x20@1x.png
|   |   |   |       Icon-App-20x20@2x.png
|   |   |   |       Icon-App-20x20@3x.png
|   |   |   |       Icon-App-29x29@1x.png
|   |   |   |       Icon-App-29x29@2x.png
|   |   |   |       Icon-App-29x29@3x.png
|   |   |   |       Icon-App-40x40@1x.png
|   |   |   |       Icon-App-40x40@2x.png
|   |   |   |       Icon-App-40x40@3x.png
|   |   |   |       Icon-App-50x50@1x.png
|   |   |   |       Icon-App-50x50@2x.png
|   |   |   |       Icon-App-57x57@1x.png
|   |   |   |       Icon-App-57x57@2x.png
|   |   |   |       Icon-App-60x60@2x.png
|   |   |   |       Icon-App-60x60@3x.png
|   |   |   |       Icon-App-72x72@1x.png
|   |   |   |       Icon-App-72x72@2x.png
|   |   |   |       Icon-App-76x76@1x.png
|   |   |   |       Icon-App-76x76@2x.png
|   |   |   |       Icon-App-83.5x83.5@2x.png
|   |   |   |       
|   |   |   \---LaunchImage.imageset
|   |   |           Contents.json
|   |   |           LaunchImage.png
|   |   |           LaunchImage@2x.png
|   |   |           LaunchImage@3x.png
|   |   |           README.md
|   |   |           
|   |   \---Base.lproj
|   |           LaunchScreen.storyboard
|   |           Main.storyboard
|   |           
|   +---Runner.xcodeproj
|   |   |   project.pbxproj
|   |   |   
|   |   +---project.xcworkspace
|   |   |   |   contents.xcworkspacedata
|   |   |   |   
|   |   |   \---xcshareddata
|   |   |           IDEWorkspaceChecks.plist
|   |   |           WorkspaceSettings.xcsettings
|   |   |           
|   |   \---xcshareddata
|   |       \---xcschemes
|   |               Runner.xcscheme
|   |               
|   +---Runner.xcworkspace
|   |   |   contents.xcworkspacedata
|   |   |   
|   |   \---xcshareddata
|   |           IDEWorkspaceChecks.plist
|   |           WorkspaceSettings.xcsettings
|   |           
|   \---RunnerTests
|           RunnerTests.swift
|           
+---lib
|   |   firebase_options.dart
|   |   main.dart
|   |   test.dart
|   |   
|   +---components
|   |   |   checkin_button.dart
|   |   |   date_picker.dart
|   |   |   loading_animation.dart
|   |   |   long_button.dart
|   |   |   long_button_disable.dart
|   |   |   no_data.dart
|   |   |   short_button.dart
|   |   |   TextFormField.dart
|   |   |   
|   |   +---appbar
|   |   |       appbar_background_transparent.dart
|   |   |       appbar_right_icon.dart
|   |   |       
|   |   +---approval
|   |   |       approval_request_card.dart
|   |   |       
|   |   +---calendar
|   |   |   \---custom_calendar
|   |   |           day.dart
|   |   |           day_of_weelk.dart
|   |   |           main.dart
|   |   |           model.dart
|   |   |           
|   |   +---dialog
|   |   |       dialog.dart
|   |   |       
|   |   +---notification
|   |   |       button.dart
|   |   |       
|   |   +---request
|   |   |       date_picker_field.dart
|   |   |       request_button.dart
|   |   |       
|   |   +---role
|   |   |       card_role.dart
|   |   |       
|   |   +---setting
|   |   |       dropdown_password.dart
|   |   |       dropdown_profile.dart
|   |   |       forgot_password.dart
|   |   |       success_page.dart
|   |   |       switch_card.dart
|   |   |       switch_card_darkmode.dart
|   |   |       switch_card_language.dart
|   |   |       text_form_field_read.dart
|   |   |       
|   |   +---signin
|   |   |       long_button.dart
|   |   |       password_field.dart
|   |   |       text_form_field.dart
|   |   |       
|   |   +---signup
|   |   |       bottomsheet_button.dart
|   |   |       
|   |   \---todo
|   |           todocard.dart
|   |           todocard_manager.dart
|   |           todo_addnewtask.dart
|   |           todo_checkbox.dart
|   |           todo_edittask.dart
|   |           
|   +---generated
|   |       assets.dart
|   |       
|   +---login_with_google
|   |       main.dart
|   |       
|   +---provider
|   |       theme_provider.dart
|   |       
|   +---responsive
|   |   |   dimension.dart
|   |   |   hwak_playground.dart
|   |   |   responsive_layout.dart
|   |   |   
|   |   +---app
|   |   |   +---approval
|   |   |   |       approval_screen.dart
|   |   |   |       approval_screen_mobile.dart
|   |   |   |       approval_screen_web.dart
|   |   |   |       
|   |   |   +---calendar
|   |   |   |   |   calendar_screen.dart
|   |   |   |   |   calendar_screen_mobile.dart
|   |   |   |   |   calendar_screen_web.dart
|   |   |   |   |   showData.class.dart
|   |   |   |   |   showDataLeave.dart
|   |   |   |   |   
|   |   |   |   +---leave_set
|   |   |   |   |       annual.dart
|   |   |   |   |       leave_model.dart
|   |   |   |   |       leave_range.dart
|   |   |   |   |       wfh.dart
|   |   |   |   |       
|   |   |   |   \---model
|   |   |   |           date.dart
|   |   |   |           user.dart
|   |   |   |           
|   |   |   +---home
|   |   |   |       checkin_page.dart
|   |   |   |       face_api.dart
|   |   |   |       grey_scale.dart
|   |   |   |       home_screen.dart
|   |   |   |       home_screen_mobile.dart
|   |   |   |       home_screen_web.dart
|   |   |   |       location_service.dart
|   |   |   |       success_page.dart
|   |   |   |       
|   |   |   +---main
|   |   |   |       main_page.dart
|   |   |   |       main_page_mobile.dart
|   |   |   |       main_page_web.dart
|   |   |   |       
|   |   |   +---notification
|   |   |   |       fcm_notification_screen.dart
|   |   |   |       noti_screen.dart
|   |   |   |       noti_screen_mobile.dart
|   |   |   |       noti_screen_web.dart
|   |   |   |       
|   |   |   +---profile
|   |   |   |       profile_screen.dart
|   |   |   |       profile_screen_mobile.dart
|   |   |   |       profile_screen_web.dart
|   |   |   |       
|   |   |   +---request
|   |   |   |   |   success_page.dart
|   |   |   |   |   
|   |   |   |   \---request_type
|   |   |   |           request_annual.dart
|   |   |   |           request_business.dart
|   |   |   |           request_sick.dart
|   |   |   |           request_wfh.dart
|   |   |   |           
|   |   |   +---resetpassword
|   |   |   |       forgotpassword_screen.dart
|   |   |   |       forgotpassword_screen_mobile.dart
|   |   |   |       forgotpassword_screen_web.dart
|   |   |   |       
|   |   |   +---setting
|   |   |   |       setting_screen.dart
|   |   |   |       setting_screen_mobile.dart
|   |   |   |       setting_screen_web.dart
|   |   |   |       
|   |   |   \---todo
|   |   |           todo_screen.dart
|   |   |           todo_screen_mobile.dart
|   |   |           todo_screen_web.dart
|   |   |           
|   |   +---forgotpassword
|   |   |       forgotPassword.dart
|   |   |       forgotPassword_mobile.dart
|   |   |       forgotPassword_mobile_save.dart
|   |   |       forgotPassword_web.dart
|   |   |       
|   |   +---Role
|   |   |       role_screen.dart
|   |   |       role_screen_mobile.dart
|   |   |       role_screen_web.dart
|   |   |       
|   |   +---signin
|   |   |       signin_screen.dart
|   |   |       signin_screen_mobile.dart
|   |   |       signin_screen_web.dart
|   |   |       
|   |   +---signup
|   |   |       signup_screen.dart
|   |   |       signup_screen_mobile.dart
|   |   |       signup_screen_web.dart
|   |   |       
|   |   \---splashscreen
|   |       +---app
|   |       |       splash_screen.dart
|   |       |       splash_screen_mobile.dart
|   |       |       splash_screen_web.dart
|   |       |       
|   |       \---signup
|   |               splash_screen.dart
|   |               splash_screen_mobile.dart
|   |               splash_screen_web.dart
|   |               
|   +---services
|   |       auth_service.dart
|   |       notification_service.dart
|   |       
|   +---unit_test
|   |       calendar_date.dart
|   |       
|   \---utils
|           big_text.dart
|           color_utils.dart
|           constants.dart
|           dark_mode.dart
|           extensions.dart
|           image.dart
|           localizations.dart
|           snackbar.dart
|           style.dart
|           systemUi.dart
|           
+---linux
|   |   .gitignore
|   |   CMakeLists.txt
|   |   main.cc
|   |   my_application.cc
|   |   my_application.h
|   |   
|   \---flutter
|           CMakeLists.txt
|           generated_plugins.cmake
|           generated_plugin_registrant.cc
|           generated_plugin_registrant.h
|           
+---macos
|   |   .gitignore
|   |   firebase_app_id_file.json
|   |   
|   +---Flutter
|   |       Flutter-Debug.xcconfig
|   |       Flutter-Release.xcconfig
|   |       GeneratedPluginRegistrant.swift
|   |       
|   +---Runner
|   |   |   AppDelegate.swift
|   |   |   DebugProfile.entitlements
|   |   |   GoogleService-Info.plist
|   |   |   Info.plist
|   |   |   MainFlutterWindow.swift
|   |   |   Release.entitlements
|   |   |   
|   |   +---Assets.xcassets
|   |   |   \---AppIcon.appiconset
|   |   |           app_icon_1024.png
|   |   |           app_icon_128.png
|   |   |           app_icon_16.png
|   |   |           app_icon_256.png
|   |   |           app_icon_32.png
|   |   |           app_icon_512.png
|   |   |           app_icon_64.png
|   |   |           Contents.json
|   |   |           
|   |   +---Base.lproj
|   |   |       MainMenu.xib
|   |   |       
|   |   \---Configs
|   |           AppInfo.xcconfig
|   |           Debug.xcconfig
|   |           Release.xcconfig
|   |           Warnings.xcconfig
|   |           
|   +---Runner.xcodeproj
|   |   |   project.pbxproj
|   |   |   
|   |   +---project.xcworkspace
|   |   |   \---xcshareddata
|   |   |           IDEWorkspaceChecks.plist
|   |   |           
|   |   \---xcshareddata
|   |       \---xcschemes
|   |               Runner.xcscheme
|   |               
|   +---Runner.xcworkspace
|   |   |   contents.xcworkspacedata
|   |   |   
|   |   \---xcshareddata
|   |           IDEWorkspaceChecks.plist
|   |           
|   \---RunnerTests
|           RunnerTests.swift
|           
+---test
|   |   widget_test.dart
|   |   
|   \---unit test
|           calendar_test.dart
|           sign_up_test.dart
|           
+---web
|   |   favicon.png
|   |   index.html
|   |   manifest.json
|   |   
|   \---icons
|           Icon-192.png
|           Icon-512.png
|           Icon-maskable-192.png
|           Icon-maskable-512.png
|           
\---windows
    |   .gitignore
    |   CMakeLists.txt
    |   
    +---flutter
    |       CMakeLists.txt
    |       generated_plugins.cmake
    |       generated_plugin_registrant.cc
    |       generated_plugin_registrant.h
    |       
    \---runner
        |   CMakeLists.txt
        |   flutter_window.cpp
        |   flutter_window.h
        |   main.cpp
        |   resource.h
        |   runner.exe.manifest
        |   Runner.rc
        |   utils.cpp
        |   utils.h
        |   win32_window.cpp
        |   win32_window.h
        |   
        \---resources
                app_icon.icon
```                


