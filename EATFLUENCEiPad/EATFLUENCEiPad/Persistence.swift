import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "EATFLUENCEiPad")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        if let description = container.persistentStoreDescriptions.first {
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.yourCompany.EATFLUENCEiPad")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
