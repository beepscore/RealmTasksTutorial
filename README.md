# Purpose
Do realm iOS tutorial

# References

## Tutorial: Build iOS App from Scratch
https://realm.io/docs/tutorials/realmtasks/

## RealmSwiftExamples
https://github.com/beepscore/RealmSwiftExamples.git

## RealmService
Add a class similar to Realm: CRUD | Swift 4, Xcode 9
https://www.youtube.com/watch?v=hC6dLLbfUXc

https://academy.realm.io/posts/tutorial-sharing-data-between-watchkit-and-your-app/
http://tackmobile.com/blog/App-Groups-and-iMessage-Extensions-for-iOS-10.html

# Results


## Appendix Record info about adding Realm framework for iOS to project.

#### getting started
https://realm.io/docs/swift/latest/

#### realm-cocoa
https://github.com/realm/realm-cocoa

### Results

#### Approach 1: Git clone
I forked realm-cocoa, added branch beepscore, updated 2 projects to recommended settings.
Xcode says "conversion to Swift 4 is available". Every time I tap it Xcode crashes.

https://stackoverflow.com/questions/44640852/how-can-i-use-realm-with-swift-4/44641478#44641478

Also might need to clone recursive.

Try download framework instead.

#### Approach 2: download built framework
2017-11-06
got error module compiled with Swift 4.0 cannot be imported in Swift 4.0.2
https://stackoverflow.com/questions/47051318/realms-swift-module-compiled-with-swift-4-0-cannot-be-imported-in-swift-4-0-2

My Xcode is using Swift 4.0.2, not 4.0

    xcrun swift --version
    Apple Swift version 4.0.2 (swiftlang-900.0.69.2 clang-900.0.38)
    Target: x86_64-apple-macosx10.9

So need to compile from source.
Try Carthage.

#### Approach 3: Carthage

    brew install carthage

    carthage update

    *** Fetching realm-cocoa
    *** Downloading realm-cocoa.framework binary at "v3.0.1"
    *** Skipped installing realm-cocoa.framework binary due to the error:
        "Incompatible Swift version - framework was built with 4.0 (swiftlang-900.0.65 clang-900.0.37) and the local version is 4.0.2 (swiftlang-900.0.69.2 clang-900.0.38)."
    *** Checking out realm-cocoa at "v3.0.1"
    *** xcodebuild output can be found in /var/folders/g4/6bm303dn22n5tqj7jrdxrb5w0000gn/T/carthage-xcodebuild.QpIZ4e.log
    *** Building scheme "Realm" in Realm.xcworkspace
    *** Building scheme "RealmSwift" in Realm.xcworkspace

created Cartfile.resolved
