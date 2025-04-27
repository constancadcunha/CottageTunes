import SwiftUI

struct NowPlayingView: View {
    let song: Song
    @ObservedObject var viewModel: MusicViewModel
    
    private var progress: Double {
        viewModel.duration > 0 ? viewModel.currentTime / viewModel.duration : 0
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "chevron.down")
                        .font(.title2)
                        .foregroundColor(Color("CottageGreen"))
                }
                .padding()
            }
            
            AsyncImage(url: URL(string: song.albumArtURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
            } placeholder: {
                Color("CottageRose")
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 300, height: 300)
            .shadow(radius: 10)
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text(song.title)
                    .font(.custom("Georgia-Bold", size: 24))
                    .foregroundColor(Color("CottageDarkGreen"))
                
                Text(song.artist)
                    .font(.custom("Georgia", size: 18))
                    .foregroundColor(Color("CottageBrown"))
            }
            
            VStack(spacing: 8) {
                Slider(value: $viewModel.currentTime, in: 0...viewModel.duration)
                    .accentColor(Color("CottageGreen"))
                
                HStack {
                    Text(formattedTime(viewModel.currentTime))
                    Spacer()
                    Text("-" + formattedTime(viewModel.duration - viewModel.currentTime))
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Controls
            HStack(spacing: 40) {
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(Color("CottageDarkGreen"))
                }
                
                Button(action: {
                    viewModel.playPause(song)
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color("CottageGreen"))
                }
                
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(Color("CottageDarkGreen"))
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .background(Color("CottageCream"))
    }
    
    private func timeString(from seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%d:%02d", minutes, seconds)
        }
}
