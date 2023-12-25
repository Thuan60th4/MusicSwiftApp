//
//  ApiManagers.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 25/12/2023.
//

import Foundation

class ApiManagers {
    static let shared = ApiManagers()
    struct Constants {
        static let baseUrl = "https://api.spotify.com/v1"
    }
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func getNewReleases(completion: @escaping (NewReleasesResponse?) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/browse/new-releases?limit=50"), method: .GET) {
            request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(result)
                }
                catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getFeaturedPlaylists(completion: @escaping (FeaturedPlaylistsResponse?) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/browse/featured-playlists?limit=20"), method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(result)
                }
                catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getRecommendations(genres: Set<String>, completion: @escaping (RecommendationsResponse?) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: URL(string: Constants.baseUrl + "/recommendations?seed_genres=\(seeds)"),
            method: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(result)
                }
                catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (RecommendedGenresResponse?) -> Void) {
        createRequest(with: URL(string: Constants.baseUrl + "/recommendations/available-genre-seeds"),
                      method: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(result)
                }
                catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    private func createRequest(with url : URL?, method : HTTPMethod, completion : @escaping (URLRequest) -> Void){
        AuthManager.shared.checkValidTokenWhenCall { token in
            guard let url = url else {return}
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)",forHTTPHeaderField: "Authorization")
            request.httpMethod = method.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
