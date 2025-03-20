//
//  RecipeViewModelTests.swift
//  Fetch.TakeHomeTests
//
//  Created by Roger Jones Work  on 3/19/25.
//

@testable import Fetch_TakeHome
import XCTest

final class RecipeViewModelTests: XCTestCase {

    func testFetchRecipes_Success() async {
           let mockNetwork = MockNetwork(result: .success(RecipeList(recipes: [mockRecipe])))
           let testObject = RecipesViewModel(network: mockNetwork)
           let expectation = expectation(description: "State should update to loaded")
           await testObject.fetchRecipes()
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               if case .loaded(let recipes) = testObject.state {
                   XCTAssertEqual(recipes.recipes.count, 1)
                   XCTAssertEqual(recipes.recipes.first?.name, mockRecipe.name)
                   expectation.fulfill()
               } else {
                   XCTFail("Expected state to be loaded, got \(testObject.state)")
               }
           }
           
           await fulfillment(of: [expectation], timeout: 1.0)
       }
       
       func testFetchRecipes_Failure() async {
           let mockNetwork = MockNetwork(result: .failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ErrorVerification"])))
           let testObject = RecipesViewModel(network: mockNetwork)
           let expectation = expectation(description: "State should update to error")
           await testObject.fetchRecipes()

           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               if case .error(let message) = testObject.state {
                   XCTAssertEqual(message, "ErrorVerification")
                   expectation.fulfill()
               } else {
                   XCTFail("Expected state to be error, got \(testObject.state)")
               }
           }
           
           await fulfillment(of: [expectation], timeout: 1.0)
       }
}
