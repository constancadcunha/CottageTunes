import SwiftUI
import AVFoundation

typealias SongCompletion = (Result<[Song], Error>) -> Void

class MusicViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var currentlyPlaying: Song?
    private(set) var audioPlayer: AVAudioPlayer?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    private var progressTimer: Timer?
    
    @Published var songs: [Song] = []
    @Published var favorites: [Song] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    override init() {
        super.init()
        loadFavorites()
        fetchTopSongs()
    }
    
    func fetchTopSongs() {
        isLoading = true
        MusicService.shared.fetchTopSongs { [weak self] (result: Result<[Song], Error>) in
            self?.handleSongResult(result)
        }
    }
    
    func search() {
        guard !searchText.isEmpty else {
            fetchTopSongs() // Reset to top songs if search is empty
            return
        }
        
        isLoading = true
        MusicService.shared.searchSongs(query: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let songs):
                    self?.songs = songs
                case .failure(let error):
                    self?.errorMessage = "Search failed: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }
    }
    
    private func handleSongResult(_ result: Result<[Song], Error>) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            switch result {
            case .success(let songs):
                self?.songs = songs
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.showError = true
            }
        }
    }
    
    func toggleFavorite(_ song: Song) {
        if favorites.contains(where: { $0.id == song.id }) {
            favorites.removeAll { $0.id == song.id }
        } else {
            favorites.append(song)
        }
        saveFavorites()
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([Song].self, from: data) {
            favorites = decoded
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    func playPause(_ song: Song) {
        if currentlyPlaying?.id == song.id {
            audioPlayer?.pause()
            progressTimer?.invalidate()
            currentlyPlaying = nil
        } else {
            currentlyPlaying = song
            guard let url = URL(string: song.previewURL) else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                        let audioPlayer = try AVAudioPlayer(data: data)
                        self?.audioPlayer = audioPlayer
                        audioPlayer.delegate = self
                        audioPlayer.play()
                        self?.startProgressTimer()
                    } catch {
                        self?.errorMessage = "Playback failed"
                        self?.showError = true
                    }
                }
            }.resume()
        }
    }
    
    private func startProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
            self.duration = player.duration
        }
    }
    
    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer?.invalidate()
        currentTime = 0
        currentlyPlaying = nil
    }
}
