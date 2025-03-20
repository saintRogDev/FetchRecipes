//
//  NetworkTests.swift
//  Fetch.TakeHomeTests
//
//  Created by Roger Jones Work  on 3/20/25.
//

@testable import Fetch_TakeHome
import XCTest

final class NetworkTests: XCTestCase {
    
    var network: Network!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        network = Network()
    }
    
    override func tearDown() {
        network = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchData_Success() async throws {
        let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "British",
                    "name": "Bakewell Tart",
                    "photo_url_large": "https://some.url/large.jpg",
                    "photo_url_small": "https://some.url/small.jpg",
                    "uuid": "12",
                    "source_url": "https://some.url/index.html",
                    "youtube_url": "https://www.youtube.com/watch?v=some.id"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let url = URL(string: "https://example.com/recipes")!
        mockURLSession.data = jsonData
        mockURLSession.response = HTTPURLResponse(url: url,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        let network = Network(session: mockURLSession)
        let result: RecipeList = try await network.fetchData(url)
        
        XCTAssertEqual(result.recipes.first?.name, "Bakewell Tart")
    }
    
    func testFetchData_InvalidStatusCode() async {
        let url = URL(string: "https://example.com/recipes")!
        mockURLSession.data = Data()
        mockURLSession.response = HTTPURLResponse(url: url,
                                                  statusCode: 404,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        let network = Network(session: mockURLSession)
        
        do {
            let _: Recipe = try await network.fetchData(url)
            XCTFail("Expected invalidStatusCode error, but succeeded")
        } catch Network.NetworkError.invalidStatusCode(let statusCode) {
            XCTAssertEqual(statusCode, 404)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchData_DecodingError() async {
        let invalidJsonData = "invalid json".data(using: .utf8)!
        let url = URL(string: "https://example.com/recipes")!
        mockURLSession.data = invalidJsonData
        mockURLSession.response = HTTPURLResponse(url: url,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        let network = Network(session: mockURLSession)
        
        do {
            let _: Recipe = try await network.fetchData(url)
            XCTFail("Expected decodingFailed error, but succeeded")
        } catch Network.NetworkError.decodingFailed {
            XCTAssertTrue(true) // Successfully caught decoding error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchData_RequestFailed() async {
        let url = URL(string: "https://example.com/recipes")!
        mockURLSession.error = URLError(.notConnectedToInternet)
        
        let network = Network(session: mockURLSession)
        
        do {
            let _: Recipe = try await network.fetchData(url)
            XCTFail("Expected requestFailed error, but succeeded")
        } catch Network.NetworkError.requestFailed(let error) {
            XCTAssertEqual((error as NSError).code, URLError.notConnectedToInternet.rawValue)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchData_OtherError() async {
        let url = URL(string: "https://example.com/recipes")!
        mockURLSession.error = NSError(domain: "CustomError",
                                           code: 123,
                                           userInfo: nil)
        
        let network = Network(session: mockURLSession)
        
        do {
            let _: Recipe = try await network.fetchData(url)
            XCTFail("Expected otherError, but succeeded")
        } catch Network.NetworkError.otherError(let error) {
            XCTAssertEqual((error as NSError).domain, "CustomError")
            XCTAssertEqual((error as NSError).code, 123)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
