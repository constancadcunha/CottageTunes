import SwiftUI

struct NowPlayingBar: View {
    let song: Song
    @ObservedObject var viewModel: MusicViewModel
    @State private var showFullPlayer = false
    
    private var progress: Double {
        viewModel.duration > 0 ? viewModel.currentTime / viewModel.duration : 0
    }
    
    var body: some View {
        VStack(spacing: 0) {

            CustomProgressBar(progress: progress)
                .frame(height: 2)
            
            HStack(spacing: 16) {
                // Album art
                AsyncImage(url: URL(string: song.albumArtURL)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color("CottageRose")
                        .overlay(Image(systemName: "music.note").foregroundColor(.white))
                }
                .frame(width: 50, height: 50)
                .cornerRadius(6)
                .shadow(radius: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .font(.custom("Georgia-Bold", size: 16))
                        .lineLimit(1)
                    Text(song.artist)
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color("CottageBrown"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    viewModel.playPause(song)
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color("CottageGreen"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color("CottageCream").opacity(0.95))
            .onTapGesture {
                showFullPlayer = true
            }
            .onTapGesture {
                    showFullPlayer = true
                }
            }
        .sheet(isPresented: $showFullPlayer) {
            NowPlayingView(song: song, viewModel: viewModel)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color("CottageCream")
                .edgesIgnoringSafeArea(.bottom)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .sheet(isPresented: $showFullPlayer) {
            NowPlayingView(song: song, viewModel: viewModel)
        }
    }
}

struct CustomProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width)
                
                Rectangle()
                    .foregroundColor(Color("CottageGreen"))
                    .frame(width: CGFloat(progress) * geometry.size.width)
            }
        }
    }
}
