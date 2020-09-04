# Todoey
A simple ToDo list app to demonstrate the various on-device data storage solutions
![Storage Types](Docs/storage_type.png)


- [User Defaults](https://developer.apple.com/documentation/foundation/userdefaults): Store basic data types (configs, user settings), everything is stored in a property file, this makes it inefficient for larger data sets
- [NSCoder](https://developer.apple.com/documentation/foundation/nscoder): Abuse the Plist by storing complex data types by storing complex objects that conform to the Codable protocol
![Code to Get File Path](Docs/file_path.png)
![Code for NSCode](Docs/ns_coder.png)
- Core Data: this is the real deal

## Installing Core Data
- add initialization code for core data
![Step 1: App Delegate](Docs/core_data_step1.png)
- create a data schema/model file (make sure step 1 context name is same as the file name)
![Step 2: Add Data Model File](Docs/core_data_step2.png)
- define the data model
![Step 3: Define Model](Docs/core_data_step3.png)

## NSPredicate
The lovechild of regex and sql

[Cheatsheet](https://academy.realm.io/posts/nspredicate-cheatsheet/)
