//
//  AuthManagers.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 23/12/2023.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    struct Constants {
        static let clientID = "3b571dfd2f594542869b17e9430df7f8"
        static let clientSecret = "cfa134caa3614395a6473b7fd53420d6"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://open.spotify.com/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read"
    }
    
    private init() {}
    
    var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
   private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
   private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
   private var tokenExpiredDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
   private var shouldRefreshToken: Bool{
        guard let expirationDate = tokenExpiredDate else {return true}
        let fiveMin: TimeInterval = 300
        let currentDate = Date()
        return currentDate.addingTimeInterval(fiveMin) >= expirationDate
    }
    
   private var isRefreshing = false
    
   private var apiCallWhenRefreshing: [(String) -> Void] = []
    
    func exchangeTokenForCode(_ code : String, completion : @escaping (Bool) -> Void){
        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //set header
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        //set body
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.saveToken(result: result)
                completion(true)
            } catch {
                completion(false)
                print("exchangeTokenForCode error \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func checkValidTokenWhenCall(completion: @escaping (String) -> Void){
        if isRefreshing {
            //đang refresh token thì thêm các api đang gọi vào mảng refresh xog thì call hết những thằng trong mảng này
            apiCallWhenRefreshing.append(completion)
            return
        }
        if shouldRefreshToken {
            self.refreshAccessToken { isSuccess in
                if isSuccess, let token = self.accessToken{
                    completion(token)
                }
            }
        }
        else if let token = accessToken{
            completion(token)
        }
        
    }
    
    func refreshAccessToken(completion : ( (Bool) -> Void)?){
        if (isRefreshing || !shouldRefreshToken){
            completion?(false)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion?(false)
            return
        }
        
        isRefreshing = true
        
        // Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion?(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshToken),
        ]
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            self.isRefreshing = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.saveToken(result: result)
                completion?(true)
                self.apiCallWhenRefreshing.forEach{ $0(result.access_token) }
                self.apiCallWhenRefreshing.removeAll()
            }
            catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
   private func saveToken(result : AuthResponse){
        UserDefaults.standard.setValue(result.access_token,forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token,forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),forKey: "expirationDate")
    }
}
