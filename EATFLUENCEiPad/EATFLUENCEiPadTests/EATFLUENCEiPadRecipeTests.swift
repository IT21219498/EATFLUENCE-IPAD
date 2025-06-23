import XCTest
import CoreData
@testable import EATFLUENCEiPad

final class EATFLUENCEiPadRecipeTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var viewModel: RecipeViewModel!

    override func setUpWithError() throws {
        let persistence = PersistenceController(inMemory: true)
        context = persistence.container.viewContext
        viewModel = RecipeViewModel(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        viewModel = nil
    }

    func testFetchRecipesWhenEmpty() throws {
        viewModel.fetchRecipes()
        XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty initially")
    }

    func testAddAndFetchRecipes() throws {
        // Arrange
        let recipe = RecipeEntity(context: context)
        recipe.id = UUID()
        recipe.title = "Test Recipe"
        recipe.userId = "user123"
        recipe.isPublic = false

        try context.save()

        // Act
        viewModel.fetchRecipes()

        // Assert
        XCTAssertEqual(viewModel.recipes.count, 1, "Should have one recipe after adding")
        XCTAssertEqual(viewModel.recipes.first?.title, "Test Recipe")
    }

    func testTogglePrivacy() throws {
        let recipe = RecipeEntity(context: context)
        recipe.id = UUID()
        recipe.title = "Test Recipe"
        recipe.userId = "user123"
        recipe.isPublic = false

        try context.save()
        viewModel.fetchRecipes()

        guard let fetchedRecipe = viewModel.recipes.first else {
            XCTFail("Failed to fetch recipe")
            return
        }

        viewModel.togglePrivacy(for: fetchedRecipe)
        XCTAssertTrue(fetchedRecipe.isPublic, "Recipe should be public after toggle")
    }

    func testDeleteRecipe() throws {
        let recipe = RecipeEntity(context: context)
        recipe.id = UUID()
        recipe.title = "Delete Recipe"
        recipe.userId = "user123"

        try context.save()
        viewModel.fetchRecipes()
        XCTAssertEqual(viewModel.recipes.count, 1, "Should have 1 recipe before delete")

        viewModel.delete(recipe)
        XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty after delete")
    }
}
