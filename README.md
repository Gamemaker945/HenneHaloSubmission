# Christian Henne - Halo Health - Code Test Submission

### Execution Notes

This project contains cocoapod libraries. On the commandline, within the MarsView project, be sure to run $> pod install

Once run, you can open the MarsView.xcworkspace file inside XCode.

### App Usage

I wanted to make something a little fun without going too overboard. In the app, you can choose one of the three Rovers (tapping on the rover image). This will fetch the manifest for that rover.

You can then select a Martial Sol (Day on Mars), and a camera for the photos. Tap the button at the bottom, and if that sol/camera combo have photos, you will see them!

#### The application supports:

Fetch caching via AlamoFire
Image caching via SWWebImage
Note: There is a ton more I would do for offline mode including offline notification, culling data displayed based on what is cached and what is not.
PromiseKit

### App Notes

The API is broken into a client and service for data retrival. This accomplishes a few things:

Breaks down responsibility
Allows for the service to be injected with a client(s) making Unit Testing of the service easy
The primary view controllers use presenters for data handling. This also makes Unit testing of data portions of the View Controllers easy.

Note: Unit tests have not been provided but can upon request.

I hope you enjoy this submission. If there is anything you would like to see done differently, or it you would like further explanation of design, please don't hesitate to reach out.
