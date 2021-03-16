//
//  NetworkManager.swift
//  Find The Weather (iOS)
//
//  Created by Jeremy Christian Stowers on 3/15/21.
//

import Foundation

//TODO -> what is the Codable protocol?
//TODO -> video stopped at 31:01 ( https://www.youtube.com/watch?v=KI6Yf7VMefc )

final class NetworkManager<T: Codable> {
    static func fetch(for url:URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error)
            guard error == nil else {
                print(String(describing: error!))
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case error(err: String)
}