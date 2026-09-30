import SwiftUI
import Kingfisher

struct EditProfileView: View {
    let profile: Profile
    
    @State private var name: String
    @State private var description: String
    @State private var avatarURL: URL
    @State private var isPhotoMenuPresented = false
    @State private var isPhotoURLAlertPresented = false
    @State private var isAvatarDeleted = false
    
    private var hasChanges: Bool {
        name != profile.name || description != profile.description
    }
    
    init(profile: Profile) {
        self.profile = profile
        _name = State(initialValue: profile.name)
        _description = State(initialValue: profile.description)
        _avatarURL = State(initialValue: profile.avatar)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        isPhotoMenuPresented = true
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            if isAvatarDeleted {
                                Circle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(width: 73, height: 73)
                            } else {
                                KFImage(avatarURL)
                                    .placeholder {
                                        Circle()
                                            .fill(.gray.opacity(0.3))
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 73, height: 73)
                                    .clipShape(Circle())
                            }
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(uiColor: .yaBlackLight))
                                .frame(width: 23, height: 23)
                                .background(Color(uiColor: .yaLightGrayLight))
                                .clipShape(Circle())
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                    
                    Text("Имя")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)
                    
                    TextField("", text: $name)
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(Color(uiColor: .yaLightGrayLight))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 8)
                    
                    Text("Описание")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)
                    
                    TextEditor(text: $description)
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: 132)
                        .background(Color(uiColor: .yaLightGrayLight))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 8)
                    
                    Text("Сайт")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)
                    
                    Text(profile.website.absoluteString)
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(Color(uiColor: .yaLightGrayLight))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
            }
            
            Button {
            } label: {
                Text("Сохранить")
                    .font(Font(UIFont.bodyBold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        Color(uiColor: .yaBlackLight)
                            .opacity(hasChanges ? 1 : 0)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(!hasChanges)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(.background)
        .background {
            PhotoActionSheet(
                isPresented: $isPhotoMenuPresented,
                onChangePhoto: {
                    isPhotoURLAlertPresented = true
                },
                onDeletePhoto: {
                    isAvatarDeleted = true
                }
            )
            
            PhotoURLAlert(
                isPresented: $isPhotoURLAlertPresented,
                initialURL: avatarURL.absoluteString
            ) { newURL in
                if let url = URL(string: newURL) {
                    avatarURL = url
                }
            }
            
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EditProfileView(
        profile: Profile(
            name: "Joaquin Phoenix",
            avatar: URL(string: "https://example.com/avatar.jpg")!,
            description: "Дизайнер из Казани",
            website: URL(string: "https://example.com")!,
            nfts: [],
            likes: [],
            id: "1"
        )
    )
}
