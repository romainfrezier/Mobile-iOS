//
//  APITools.swift
//  Mobile-project-iOS
//
//  Created by Romain on 06/03/2023.
//

import Foundation
import Firebase

struct APITools {
    
    // MARK: - Get the token of the current user
    private static func getToken(completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        user.getIDToken { token, error in
            if let error = error {
                print("Error getting token: \(error.localizedDescription)")
                completion(nil)
            }
            if let token = token {
                completion(token)
            }
        }
    }
    
    // MARK: - Build URL with end point
    private static func buildURL(endpoint: String) -> URL? {
        let builURL : String = env.apiURL + "/" + endpoint
        guard let url = URL(string: builURL) else {
            return nil
        }
        return url
    }
    
    // MARK: - Build URL with end point and a parameter
    private static func buildURL(endpoint: String, parameter: String) -> URL? {
        let builURL : String = env.apiURL + "/" + endpoint + "/" + parameter
        guard let url = URL(string: builURL) else {
            return nil
        }
        return url
    }
    
    // MARK: - Get data
    static func loadFromAPI<T : Decodable>(endpoint: String, callback: @escaping (APIResult<T>) -> Void){
        guard let url = buildURL(endpoint: endpoint) else {
            return
        }
        getToken() { token in
            
            guard let token = token else {
                print("Token is nil")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: "authtoken")
            
            print("Request: \(request)")
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                if error != nil {
                    print("error", error?.localizedDescription ?? "")
                    return
                }
                
                do {
                    if let data = data {
                        
                        let dateFormatter = DateFormatters.dbDate()
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        
                        let result : [T] = try decoder.decode([T].self, from: data)
                        DispatchQueue.main.async {
                            callback(.successList(result))
                        }
                    } else {
                        print("No data")
                    }
                } catch {
                    do {
                        if let data = data {
                            
                            let dateFormatter = DateFormatters.dbDate()
                            
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(dateFormatter)
                            
                            let result : T = try decoder.decode(T.self, from: data)
                            DispatchQueue.main.async {
                                callback(.success(result))
                            }
                        } else {
                            print("No data")
                        }
                    } catch let JsonError {
                        print("fetch json error:", JsonError)
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Create data
    static func createOnAPI(endpoint: String, body: [String: Any]){
        guard let url : URL = buildURL(endpoint: endpoint) else {
            return
        }
        
        getToken() { token in
            
            guard let token = token else {
                print("Token is nil")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "authtoken")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                print("Error encoding : \(error.localizedDescription)")
                return
            }
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, let response = res as? HTTPURLResponse, error == nil else {
                    print("Error sending request: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if response.statusCode == 201 {
                    print(data)
                } else {
                    print("Error creating : \(response.statusCode)")
                }
            }.resume()
        }
    }
    
    // MARK: - Update data
    static func updateOnAPI(endpoint: String, id: String, body: [String: Any]){
        guard let url = buildURL(endpoint: endpoint, parameter: id) else {
            return
        }
        
        getToken() { token in
            
            guard let token = token else {
                print("Token is nil")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "authtoken")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                print("Error encoding : \(error.localizedDescription)")
                return
            }
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, let response = res as? HTTPURLResponse, error == nil else {
                    print("Error sending request: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if response.statusCode == 201 {
                    print(data)
                } else {
                    print("Error updating : \(response.statusCode)")
                }
            }.resume()
        }
    }
    
    // MARK: - Delete data
    static func removeOnAPI(endpoint: String, id: String){
        guard let url = buildURL(endpoint: endpoint, parameter: id) else {
            return
        }
        getToken() { token in
            
            guard let token = token else {
                print("Token is nil")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue(token, forHTTPHeaderField: "authtoken")
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                if error != nil {
                    print("error", error?.localizedDescription ?? "")
                    return
                } else {
                    if let response = res as? HTTPURLResponse {
                        print("Status code: \(response.statusCode)")
                    }
                }
            }.resume()
        }
    }
    
}
