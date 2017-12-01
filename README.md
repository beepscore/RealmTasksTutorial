# Purpose
Do realm iOS tutorial.

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

## Appendix Prerequisite
Use repo realm-tasks to create a realm database.

### realm-tasks
    git checkout master

### start realm object server
    cd realm_practice
    npm start

### realm studio
start realm studio

### realm-tasks
Start "RealmTasks Apple/RealmTasks.xcworkspace"
In Xcode, build and run scheme RealmTasks macOS.
Create user test pw test
Now realm studio shows realm <uuid>/realmtasks
fields
id: string, text: string, date: date?, completed: bool
Manually add some tasks.

## Appendix Record info about adding Realm framework for iOS to project.

### getting started
https://realm.io/docs/swift/latest/

### realm-cocoa
https://github.com/realm/realm-cocoa

### Carthage

    brew install carthage

    carthage update

    *** Fetching realm-cocoa
    *** Downloading realm-cocoa.framework binary at "v3.0.2"
    *** xcodebuild output can be found in /var/folders/g4/6bm303dn22n5tqj7jrdxrb5w0000gn/T/carthage-xcodebuild.hRboCH.log

    created Cartfile.resolved

// TODO: ?

    *** Building scheme "Realm" in Realm.xcworkspace
    *** Building scheme "RealmSwift" in Realm.xcworkspace

