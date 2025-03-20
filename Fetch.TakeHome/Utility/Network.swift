//
//  Network.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/19/25.
//

import Foundation

protocol NetworkProtocol {
    func fetchData<T: Decodable>(_ url: URL) async throws -> T
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

struct Network: NetworkProtocol {
    enum NetworkError: Error {
        case decodingFailed(error: DecodingError)
        case invalidStatusCode(statusCode: Int)
        case requestFailed(error: URLError)
        case otherError(error: Error)
    }
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(_ url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            try parseResponse(response: response)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(error: error)
        } catch let error as URLError {
            throw NetworkError.requestFailed(error: error)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.otherError(error: error)
        }
    }
    
    private func parseResponse(response: URLResponse) throws {
        guard let responseCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.invalidStatusCode(statusCode: -1)
        }
        guard (200...299).contains(responseCode) else {
            throw NetworkError.invalidStatusCode(statusCode: responseCode)
        }
    }
}
