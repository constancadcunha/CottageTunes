import SwiftUI

struct ExploreView: View {
    @ObservedObject var viewModel: MusicViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.songs) { song in
                    HStack(spacing: 16) {
                        // Album Art from API
                        AsyncImage(url: URL(string: song.albumArtURL)) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Color("CottageRose")
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    .overlay(
                                        Image(systemName: "music.note")
                                            .foregroundColor(.white)
                                    )
                            } else {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(song.title)
                                .font(.custom("Georgia-Bold", size: 16))
                                .foregroundColor(Color("CottageDarkGreen"))
                                .lineLimit(1)
                            
                            Text(song.artist)
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(Color("CottageBrown"))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.playPause(song)
                        }) {
                            Image(systemName: viewModel.currentlyPlaying?.id == song.id && viewModel.isPlaying ?
                                  "pause.circle.fill" : "play.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("CottageGreen"))
                        }
                        
                        Button(action: {
                            withAnimation {
                                viewModel.toggleFavorite(song)
                            }
                        }) {
                            Image(systemName: viewModel.favorites.contains { $0.id == song.id } ?
                                  "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(viewModel.favorites.contains { $0.id == song.id } ?
                                               .red : Color("CottageRose"))
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 80) // Space for now playing bar
        }
    }
}
