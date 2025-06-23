//
//  EATFLUENCEiPadUITests.swift
//  EATFLUENCEiPadUITests
//
//  Created by Pasindu Jayasinghe on 6/21/25.
//

import XCTest

final class EATFLUENCEiPadUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testHomeViewHasAddPostButton() throws {
        // ✅ Navigate to Home in the split view
        let homeCell = app.buttons.matching(identifier: "Home").firstMatch
        if homeCell.exists {
            homeCell.tap()
        } else {
            // Alternative: locate by label text if identifier not set
            let homeLabel = app.buttons["Home"]
            if homeLabel.exists {
                homeLabel.tap()
            }
        }

        // ✅ Verify Add Post button
        let addPostButton = app.buttons["addPostButton"]
        XCTAssertTrue(
            addPostButton.waitForExistence(timeout: 3),
            "Add Post button should exist on Home view"
        )
    }

    @MainActor
    func testTapAddPostButtonShowsSheet() throws {
        // ✅ Navigate to Home
        let homeCell = app.buttons.matching(identifier: "Home").firstMatch
        if homeCell.exists {
            homeCell.tap()
        } else {
            app.buttons["Home"].tap()
        }

        // ✅ Tap Add Post
        let addPostButton = app.buttons["addPostButton"]
        XCTAssertTrue(addPostButton.waitForExistence(timeout: 3), "Add Post button should exist")
        addPostButton.tap()

        // ✅ Check for AddPostView (username field or other known element)
        let usernameField = app.textFields["Enter username"]
        XCTAssertTrue(
            usernameField.waitForExistence(timeout: 3),
            "AddPostView should appear with username field visible"
        )
    }

    @MainActor
        func testExample() throws {
            // UI tests must launch the application that they test.
            let app = XCUIApplication()
            app.launch()

            // Use XCTAssert and related functions to verify your tests produce the correct results.
        }

        @MainActor
        func testLaunchPerformance() throws {
            if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
                // This measures how long it takes to launch your application.
                measure(metrics: [XCTApplicationLaunchMetric()]) {
                    XCUIApplication().launch()
                }
            }
        }
}
