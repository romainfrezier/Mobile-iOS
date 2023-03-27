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
    
    // MARK: - Get the firebase ID of the current user
    private static func getFirebaseID() -> String {
        return Auth.auth().currentUser!.uid
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
    static func loadFromAPI<T : Decodable>(endpoint: String, callback: @escaping (APIResult<T>) -> Void, apiReturn : String){
        guard let url = buildURL(endpoint: endpoint) else {
            return
        }
        getToken() { token in
            
            guard let token = token else {
                print("Token is nil")
                return
            }
                        
            let uid = getFirebaseID()
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: "authtoken")
            request.addValue(uid, forHTTPHeaderField: "requester")
            
            print("Token : ", token)
            print("URL :", request.url ?? "Pas d'url")

            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                if error != nil {
                    print("error", error?.localizedDescription ?? "")
                    return
                }
                
                switch apiReturn {
                case returnType.array.rawValue :
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
                    } catch let JsonError {
                        print("fetch json error (\(url)):", JsonError)
                    }
                case returnType.object.rawValue :
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
                        print("fetch json error (\(url)):", JsonError)
                    }
                default:
                    print("Bad returnType")
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
            
            let uid = getFirebaseID()
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "authtoken")
            request.addValue(uid, forHTTPHeaderField: "requester")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                if let bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) {
                    print("Request Body: ", bodyString)
                }
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
    static func updateOnAPI(endpoint: String, id: String, body: [String: Any], completion: @escaping (Result<Data, Error>) -> Void){
        guard let url = buildURL(endpoint: endpoint, parameter: id) else {
            return
        }
        
        getToken() { token in
            
            guard let token = token else {
                print("Token is nil")
                return
            }
            
            let uid = getFirebaseID()
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "authtoken")
            request.addValue(uid, forHTTPHeaderField: "requester")
            
            print("URL :", url)
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                print("Error encoding : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, let response = res as? HTTPURLResponse, error == nil else {
                    print("Error sending request: \(error?.localizedDescription ?? "Unknown error")")
                    completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                    return
                }
                
                if response.statusCode == 201 {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "Error creating: \(response.statusCode)", code: response.statusCode, userInfo: nil)))
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
            
            let uid = getFirebaseID()
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue(token, forHTTPHeaderField: "authtoken")
            request.addValue(uid, forHTTPHeaderField: "requester")
            
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
