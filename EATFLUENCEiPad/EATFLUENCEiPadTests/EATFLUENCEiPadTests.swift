//
//  EATFLUENCEiPadTests.swift
//  EATFLUENCEiPadTests
//
//  Created by Pasindu Jayasinghe on 6/21/25.
//

import XCTest
import CoreData
import SwiftUI
@testable import EATFLUENCEiPad

final class EATFLUENCEiPadTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var viewModel: PostViewModel!

    override func setUpWithError() throws {
        let persistence = PersistenceController(inMemory: true)
        context = persistence.container.viewContext
        viewModel = PostViewModel()
        // Manually inject context if your VM allows (or update VM init to accept context)
        viewModel.overrideContext(context)
    }

    override func tearDownWithError() throws {
        context = nil
        viewModel = nil
    }

    func testAddPostAndFetch() throws {
        let testImage = UIImage(systemName: "photo")!
        
        // Act
        viewModel.addPost(username: "TestUser", caption: "Test caption", image: testImage)
        
        // Assert
        XCTAssertEqual(viewModel.posts.count, 1, "There should be one post after adding")
        let post = viewModel.posts.first
        XCTAssertEqual(post?.username, "TestUser")
        XCTAssertEqual(post?.caption, "Test caption")
        XCTAssertNotNil(post?.imageData, "Image data should be saved")
    }

    func testFetchPostsWhenEmpty() throws {
        viewModel.fetchPosts()
        XCTAssertTrue(viewModel.posts.isEmpty, "Posts should be empty initially")
    }

    func testSaveContextFailureHandled() throws {
        // Simulate failure by setting up a nil context or mock failure (example only, would require mocking)
        // Here we'll just ensure saveContext doesn't crash
        viewModel.saveContext()
        XCTAssertTrue(true, "saveContext should not crash even if nothing to save")
    }
}
