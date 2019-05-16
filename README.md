# CSContacts
Framework for pulling contacts from the phone and synchronising with server.
The framework also stores the contacts locally and on app start pulls contacts from local storage before synchronising with the server to enable best user experience.

## Instructions for framework integration via cocoapods

Install framework via cocoapods. Framework is located in public repo on github.
To install from private repo add to top of Podfile:
```
source 'https://github.com/cloverstudio/CSContacts_iOS.git'
source 'https://github.com/CocoaPods/Specs.git'
```
To retreive framework from git add to Podfile:
```
pod 'CSContacts_iOS', '~> 0.0'
```
Don't forget user_frameworks for visibility:
```
use_frameworks!
```
If new version can't be obtained run: "pod repo update" before pod update.
The framework is written in Swift vsersion 4.2 and relies heavily on RxSwift which is part of it's dependecies.

## Instructions 
On app start, in AppDelegate method didFinishLaunchingWithOptions call start on CSContactsProvider class instance passing server endpoint url for contact synchronisation.

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

CSContactsProvider.instance.start(contactSyncUrl: URL(string:  [ENDPOINT URL])!)

return true
}
```

This will initialise the CSContactsProvider class singleton. 
The contacts list can be obtained by subscribing to phoneContacts property on the CSContactsProvider. This property is a Driver and thus well suited for driving UI as it is guaranteed to run on the main thread.

Example of phoneContacts used as a drive to drive a UITableView:
```
phoneContacts
.drive(tableView
.rx
.items(cellIdentifier: ContactCell.identifier,
cellType: ContactCell.self)){ (_, contact, cell) in
cell.setContact(contact)
}.disposed(by: self.disposeBag)
```

## Instructions for backend support
The api endpoint needs to be configured to accept a POST request containing JSON body of phone numbers separated by comma “,” without white spaces. E.g.:
```
{"phoneNumbers" : "+000989288072,+000989288074”}
```

The response needs to contain “code” property for success, and “data” object containing “users” property as an array of users. The user objects need to contain following properties 
- "_id" as String
- "name" as String
- "phoneNumber" as String

## Debug
Debugging is supported via the property statusUpdate on the CSContactsProvider.









