//
//  LibraryAlbumsResponse.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 14/03/2024.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
