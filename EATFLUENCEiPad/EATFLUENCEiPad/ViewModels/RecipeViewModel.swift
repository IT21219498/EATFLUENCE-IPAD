import Foundation
import CoreData

class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeEntity] = []

    private let context: NSManagedObjectContext
    private let currentUserId = "user123" // Replace with actual user management

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchRecipes()
    }

    func fetchRecipes() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", currentUserId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RecipeEntity.title, ascending: true)]

        do {
            recipes = try context.fetch(request)
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }

    func delete(_ recipe: RecipeEntity) {
        context.delete(recipe)
        saveContext()
        fetchRecipes()
    }

    func togglePrivacy(for recipe: RecipeEntity) {
        recipe.isPublic.toggle()
        saveContext()
        fetchRecipes()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("CoreData save failed: \(error)")
        }
    }
}
