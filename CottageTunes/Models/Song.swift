import Foundation

struct DeezerResponse: Codable {
    let data: [DeezerTrack]
}

struct DeezerTrack: Codable {
    let id: Int
    let title: String
    let preview: String?
    let artist: DeezerArtist
    let album: DeezerAlbum?
    
    struct DeezerArtist: Codable {
        let name: String
    }
    
    struct DeezerAlbum: Codable {
        let cover_medium: String?
    }
}

struct Song: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let artist: String
    let previewURL: String
    let albumArtURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case artist = "artist.name"
        case previewURL = "preview"
        case albumArtURL = "album.cover_medium"
    }
    
    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}
