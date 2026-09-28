import SwiftUI
import Kingfisher

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @State private var isWebViewPresented = false
    @State private var isMyNFTPresented = false
    @State private var isFavoritesNFTPresented = false
    
    init(viewModel: ProfileViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                
                NavigationLink {
                    EditProfileView()
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 26))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 2)
            
            
            HStack(spacing: 16) {
                KFImage(viewModel.profile?.avatar)
                    .placeholder {
                        Circle()
                            .fill(.gray.opacity(0.3))
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                Text(viewModel.profile?.name ?? "")
                    .font(Font(UIFont.headline3))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.profile?.description ?? "")            .font(Font(UIFont.caption2))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
                
                Button {
                    isWebViewPresented = true
                } label: {
                    Text(viewModel.profile?.website.absoluteString ?? "")
                        .font(Font(UIFont.caption1))
                        .foregroundStyle(Color(uiColor: .blueUniversal))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            
            VStack(spacing: 0) {
                Button {
                    isMyNFTPresented = true
                } label: {
                    ProfileNavigationRow(
                        title: "Мои NFT",
                        count: viewModel.profile?.nfts.count ?? 0
                    )
                }
                .buttonStyle(.plain)
                
                
                Button {
                    isFavoritesNFTPresented = true
                } label: {
                    ProfileNavigationRow(
                        title: "Избранные NFT",
                        count: viewModel.profile?.likes.count ?? 0
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 40)
            
            Spacer()
            }
            .background(.background)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                }
            }
        
            .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text("Не удалось загрузить профиль")
            }
        .task {
            await viewModel.loadProfile()
        }
        .sheet(isPresented: $isWebViewPresented) {
            if let website = viewModel.profile?.website {
                NavigationStack {
                    WebView(url: website)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    isWebViewPresented = false
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                                }
                            }
                        }
                }
            }
        }
        .navigationDestination(isPresented: $isMyNFTPresented) {
            MyNFTView()
                .toolbar(.hidden, for: .tabBar)
        }
        .navigationDestination(isPresented: $isFavoritesNFTPresented) {
            FavoritesNFTView()
                .toolbar(.hidden, for: .tabBar)
        }
    }
}

private struct ProfileNavigationRow: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text("\(title) (\(count))")
                .font(Font(UIFont.bodyBold))
                .foregroundStyle(Color(uiColor: .yaBlackLight))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(uiColor: .yaBlackLight))
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 16)
        .frame(height: 54)
    }
}

#Preview {
    ProfileView(
        viewModel: ProfileViewModel(
            profileService: ProfileServiceImpl(
                networkClient: DefaultNetworkClient()
            )
        )
    )
}
