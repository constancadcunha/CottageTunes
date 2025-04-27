import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: MusicViewModel
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [Color("CottageCream"), Color("CottageMist")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            
            if viewModel.favorites.isEmpty {
                emptyStateView
            } else {
                favoritesListView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("CottageRose"))
            
            Text("No favorites yet")
                .font(.custom("Georgia-Bold", size: 18))
                .foregroundColor(Color("CottageDarkGreen"))
            
            Text("Tap the ♡ icon to add songs to favorites")
                .font(.custom("Georgia", size: 14))
                .foregroundColor(Color("CottageBrown"))
        }
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favorites) { song in
                    HStack(spacing: 16) {
                        
                        AsyncImage(url: URL(string: song.albumArtURL)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        } placeholder: {
                            ZStack {
                                Color("CottageRose")
                                Image(systemName: "music.note")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
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
                        
                        
                        Button(action: {
                            viewModel.playPause(song)
                        }) {
                            Image(systemName: viewModel.currentlyPlaying?.id == song.id && viewModel.isPlaying ?
                                  "pause.circle.fill" : "play.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("CottageGreen"))
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.top, 16)
        }
    }
}
