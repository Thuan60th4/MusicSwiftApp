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
        case PUT
        case DELETE
    }
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    func getNewReleases(completion: @escaping (NewReleasesResponse?) -> Void) {
        createRequest(with:"/browse/new-releases?limit=50", method: .GET) {
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
                    print("getNewReleases",error.localizedDescription)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getFeaturedPlaylists(completion: @escaping (FeaturedPlaylistsResponse?) -> Void) {
        createRequest(with: "/browse/featured-playlists?limit=20", method: .GET) { request in
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
                    print("getFeaturedPlaylists",error.localizedDescription)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getRecommendations(genres: Set<String>, completion: @escaping (RecommendationsResponse?) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: "/recommendations?seed_genres=\(seeds)",
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
                    print("getRecommendations",error.localizedDescription)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getRecommendedGenres(completion: @escaping (RecommendedGenresResponse?) -> Void) {
        createRequest(with: "/recommendations/available-genre-seeds",method: .GET) { request in
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
                    print("getRecommendedGenres",error.localizedDescription)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getPlayListDetail(for playListId: String, completion : @escaping (PlaylistDetailsResponse?) -> Void){
        createRequest(with: "/playlists/\(playListId)", method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(result)
                } catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func getAlbumDetail(for albumId: String, completion : @escaping (AlbumDetailsResponse?) -> Void){
        createRequest(with: "/albums/\(albumId)", method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(result)
                } catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        createRequest(
            with: "/me",
            method: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(result)
                }
                catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func createUserPlaylist(with name: String, completion: @escaping (Bool) -> Void){
        getCurrentUserProfile { userProfile in
            guard let userProfile = userProfile else {
                completion(false)
                return
            }
            self.createRequest(with: "/users/\(userProfile.id)/playlists", method: .POST) { request in
                let body = ["name": name]
                var req = request
                req.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                let task = URLSession.shared.dataTask(with: req) { data, _ , error in
                    guard let data = data, error == nil else {
                        completion(false)
                        return
                    }
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        if let response = result as? [String: Any], response["id"] as? String != nil {
                            completion(true)
                        }
                        else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                    }
                }
                task.resume()
            }
        }
    }
    
    func getUserPlaylist(completion : @escaping ([Playlist]?) -> Void){
        createRequest(with: "/me/playlists/?limit=50", method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    completion(result.items)
                } catch {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    public func addTrackToPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(
            with: "/playlists/\(playlist.id)/tracks",
            method: .POST
        ) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(false)
                    return
                }

                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any],
                       response["snapshot_id"] as? String != nil {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
                catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    func removeTrackFromPlaylist(
           track: AudioTrack,
           playlist: Playlist,
           completion: @escaping (Bool) -> Void
       ) {
           createRequest(
               with: "/playlists/\(playlist.id)/tracks",
               method: .DELETE
           ) { baseRequest in
               var request = baseRequest
               let json: [String: Any] = [
                   "tracks": [
                       [
                           "uri": "spotify:track:\(track.id)"
                       ]
                   ]
               ]
               request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else{
                       completion(false)
                       return
                   }

                   do {
                       let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                       if let response = result as? [String: Any],
                          response["snapshot_id"] as? String != nil {
                           completion(true)
                       }
                       else {
                           completion(false)
                       }
                   }
                   catch {
                       completion(false)
                   }
               }
               task.resume()
           }
       }
    
    func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
           createRequest(
               with: "/me/albums",
               method: .GET
           ) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.faileedToGetData))
                       return
                   }
                   do {
                       let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                       completion(.success(result.items.compactMap({ $0.album })))
                   }
                   catch {
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
    
    func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
           createRequest(
               with: "/me/albums?ids=\(album.id)",
               method: .PUT
           ) { baseRequest in
               var request = baseRequest
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")

               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   guard let code = (response as? HTTPURLResponse)?.statusCode,
                         error == nil else {
                       completion(false)
                       return
                   }
                   print(code)
                   completion(code == 200)
               }
               task.resume()
           }
       }
    
    private func createRequest(with endpoint : String, method : HTTPMethod, completion : @escaping (URLRequest) -> Void){
        AuthManager.shared.checkValidTokenWhenCall { token in
            guard let url = URL(string: Constants.baseUrl + endpoint) else {return}
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)",forHTTPHeaderField: "Authorization")
            request.httpMethod = method.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
