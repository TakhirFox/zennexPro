//
//  NetworkService.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 02.01.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetchJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects, nil)
            } catch {
                completion(nil, error)
                print("Failed to decode:", error)
            }
            
        }.resume()
    }
    
}

