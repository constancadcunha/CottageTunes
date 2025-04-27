import Foundation

class MusicService {
    static let shared = MusicService()
    let baseURL = "https://api.deezer.com"  // Add this line
    
    func fetchTopSongs(completion: @escaping (Result<[Song], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/playlist/3155776842/tracks")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {  // Fix closure syntax
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(DeezerResponse.self, from: data)
                    completion(.success(response.data.compactMap { track in
                        guard let preview = track.preview else { return nil }
                        return Song(
                            id: track.id,
                            title: track.title,
                            artist: track.artist.name,
                            previewURL: preview,
                            albumArtURL: track.album?.cover_medium ?? ""
                        )
                    }))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // Similar fix for searchSongs function
    func searchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "\(baseURL)/search?q=\(encodedQuery)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(DeezerResponse.self, from: data)
                let songs = response.data.compactMap { track -> Song? in
                    guard let preview = track.preview else { return nil }
                    return Song(
                        id: track.id,
                        title: track.title,
                        artist: track.artist.name,
                        previewURL: preview,
                        albumArtURL: track.album?.cover_medium ?? ""
                    )
                }
                completion(.success(songs))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
