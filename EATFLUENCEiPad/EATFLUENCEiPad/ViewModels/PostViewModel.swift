import Foundation
import CoreData
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts: [FoodPostEntity] = []
    
    private var viewContext: NSManagedObjectContext
        
        init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
            self.viewContext = context
        }

        func overrideContext(_ context: NSManagedObjectContext) {
            self.viewContext = context
        }

    func fetchPosts() {
        let request: NSFetchRequest<FoodPostEntity> = FoodPostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodPostEntity.timestamp, ascending: false)]
        
        do {
            posts = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch posts: \(error.localizedDescription)")
        }
    }
    
    func addPost(username: String, caption: String, image: UIImage) {
        let newPost = FoodPostEntity(context: viewContext)
        newPost.id = UUID()
        newPost.username = username
        newPost.caption = caption
        newPost.timestamp = Date()
        newPost.imageData = image.jpegData(compressionQuality: 0.8)
        
        saveContext()
        fetchPosts()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
