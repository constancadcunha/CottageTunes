import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: MusicViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("CottageGreen"))
            
            
            TextField("Search songs...", text: $viewModel.searchText)
                .focused($isFocused)
                .font(.custom("Georgia", size: 16))
                .foregroundColor(Color("CottageDarkGreen"))
                .submitLabel(.search)
                .onSubmit {
                    viewModel.search()
                }
            
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                    viewModel.fetchTopSongs()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("CottageGreen"))
                }
                .transition(.opacity)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .animation(.easeInOut, value: viewModel.searchText.isEmpty)
    }
}
