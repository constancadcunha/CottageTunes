import SwiftUI

struct SongRow: View {
    let song: Song
    @ObservedObject var viewModel: MusicViewModel
    
    private var isFavorite: Bool {
        viewModel.favorites.contains { $0.id == song.id }
    }
    
    private var isPlaying: Bool {
        viewModel.currentlyPlaying?.id == song.id && viewModel.isPlaying
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Album art placeholder
            Image(systemName: "music.note")
                .frame(width: 50, height: 50)
                .background(Color("CottageRose"))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.custom("Georgia-Bold", size: 16))
                    .foregroundColor(Color("CottageDarkGreen"))
                Text(song.artist)
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Color("CottageBrown"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                viewModel.playPause(song)
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("CottageGreen"))
            }
            
            Button(action: {
                viewModel.toggleFavorite(song)
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : Color("CottageRose"))
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
    }
}
