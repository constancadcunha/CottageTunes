import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(colors: [Color("CottageCream"), Color("CottageMist")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        Text("Cottage Tunes")
                            .font(.custom("SnellRoundhand-Bold", size: 32))
                            .foregroundColor(Color("CottageDarkGreen"))
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Image(systemName: "leaf.fill")
                            .font(.title2)
                            .foregroundColor(Color("CottageGreen"))
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    ZStack {
                        SearchBar(viewModel: viewModel)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("CottageGreen"))
                                .padding(.trailing, 40)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    
                    TabView(selection: $selectedTab) {
                        ExploreView(viewModel: viewModel)
                            .tag(0)
                        
                        FavoritesView(viewModel: viewModel)
                            .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    
                    HStack(spacing: 0) {
                        TabButton(
                            icon: "music.note.list",
                            label: "Explore",
                            isSelected: selectedTab == 0
                        ) {
                            withAnimation(.easeInOut) {
                                selectedTab = 0
                            }
                        }
                        
                        Spacer()
                        
                        TabButton(
                            icon: "heart.fill",
                            label: "Favorites",
                            isSelected: selectedTab == 1
                        ) {
                            withAnimation(.easeInOut) {
                                selectedTab = 1
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(
                        Color.white.opacity(0.7)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                }
                
                
                if let currentSong = viewModel.currentlyPlaying {
                    NowPlayingBar(song: currentSong, viewModel: viewModel)
                        .transition(.move(edge: .bottom))
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct TabButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .symbolVariant(isSelected ? .fill : .none)
                Text(label)
                    .font(.custom("Georgia", size: 12))
            }
            .frame(width: 80)
            .foregroundColor(isSelected ? Color("CottageGreen") : Color("CottageBrown"))
            .padding(.vertical, 8)
            .background(
                isSelected ? Color("CottageGreen").opacity(0.2) : Color.clear
            )
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
