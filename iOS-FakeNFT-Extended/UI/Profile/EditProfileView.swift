import SwiftUI
import Kingfisher

struct EditProfileView: View {
    
    private enum Constants {
        static let avatarSize: CGFloat = 73
        static let cameraButtonSize: CGFloat = 23
        static let backIconSize: CGFloat = 24
        static let cameraIconSize: CGFloat = 12
        
        static let textFieldHeight: CGFloat = 44
        static let descriptionHeight: CGFloat = 132
        static let saveButtonHeight: CGFloat = 60
        
        static let fieldCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 16
        
        static let horizontalPadding: CGFloat = 16
    }
    
    @State private var viewModel: ProfileViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var editViewModel: EditProfileViewModel
    
    @State private var isPhotoMenuPresented = false
    @State private var isPhotoURLAlertPresented = false
    @State private var isDiscardAlertPresented = false
    @State private var isSaveErrorAlertPresented = false
    @State private var photoURL = ""
    
    init(profile: Profile, viewModel: ProfileViewModel) {
        _viewModel = State(initialValue: viewModel)
        _editViewModel = State(
            initialValue: EditProfileViewModel(profile: profile)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    if editViewModel.hasChanges {
                        isDiscardAlertPresented = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: Constants.backIconSize))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                }
                .disabled(viewModel.isSaving)
                
                Spacer()
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        isPhotoMenuPresented = true
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            if editViewModel.isAvatarDeleted {
                                Circle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(
                                        width: Constants.avatarSize,
                                        height: Constants.avatarSize
                                    )
                            } else {
                                KFImage(editViewModel.avatarURL)
                                    .placeholder {
                                        Circle()
                                            .fill(.gray.opacity(0.3))
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: Constants.avatarSize,
                                        height: Constants.avatarSize
                                    )
                                    .clipShape(Circle())
                            }
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: Constants.cameraIconSize))
                                .foregroundStyle(Color(uiColor: .yaBlackLight))
                                .frame(
                                    width: Constants.cameraButtonSize,
                                    height: Constants.cameraButtonSize
                                )
                                .background(
                                    Color(uiColor: .yaLightGrayLight)
                                )
                                .clipShape(Circle())
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                    
                    Text("Имя")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)
                    
                    TextField("", text: $editViewModel.name)
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Constants.horizontalPadding)
                        .frame(height: Constants.textFieldHeight)
                        .background(Color(uiColor: .yaLightGrayLight))
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Constants.fieldCornerRadius
                            )
                        )
                        .padding(.top, 8)
                    
                    Text("Описание")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)
                    
                    TextEditor(text: $editViewModel.description)
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: Constants.descriptionHeight)
                        .background(Color(uiColor: .yaLightGrayLight))
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Constants.fieldCornerRadius
                            )
                        )
                        .padding(.top, 8)
                    
                    Text("Сайт")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)
                    
                    TextField("", text: $editViewModel.website)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Constants.horizontalPadding)
                        .frame(height: Constants.textFieldHeight)
                        .background(Color(uiColor: .yaLightGrayLight))
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Constants.fieldCornerRadius
                            )
                        )
                        .padding(.top, 8)
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
            .disabled(viewModel.isSaving)
            
            Button {
                Task {
                    let isSaved = await viewModel.updateProfile(
                        name: editViewModel.name,
                        description: editViewModel.description,
                        avatar: editViewModel.isAvatarDeleted
                        ? ""
                        : editViewModel.avatarURL?.absoluteString ?? "",
                        website: editViewModel.website
                    )
                    
                    if isSaved {
                        dismiss()
                    } else {
                        isSaveErrorAlertPresented = true
                    }
                }
            } label: {
                Text("Сохранить")
                    .font(Font(UIFont.bodyBold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.saveButtonHeight)
                    .background(
                        Color(uiColor: .yaBlackLight)
                            .opacity(editViewModel.canSave ? 1 : 0)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: Constants.buttonCornerRadius
                        )
                    )
            }
            .disabled(!editViewModel.canSave || viewModel.isSaving)
            .allowsHitTesting(editViewModel.hasChanges && !viewModel.isSaving)
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, 16)
        }
        .background(.background)
        .overlay {
            if viewModel.isSaving {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .confirmationDialog(
            "Фото профиля",
            isPresented: $isPhotoMenuPresented,
            titleVisibility: .visible
        ) {
            Button("Изменить фото") {
                photoURL = editViewModel.avatarURL?.absoluteString ?? ""
                isPhotoURLAlertPresented = true
            }
            
            Button("Удалить фото", role: .destructive) {
                editViewModel.isAvatarDeleted = true
            }
            
            Button("Отмена", role: .cancel) {}
        }
        .alert(
            "Ссылка на фото",
            isPresented: $isPhotoURLAlertPresented
        ) {
            TextField(
                "URL фотографии",
                text: $photoURL
            )
            .keyboardType(.URL)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            
            Button("Отмена", role: .cancel) {}
            
            Button("Сохранить") {
                if let url = URL(string: photoURL) {
                    editViewModel.avatarURL = url
                    editViewModel.isAvatarDeleted = false
                }
            }
        }
        .alert(
            "Уверены,\nчто хотите выйти?",
            isPresented: $isDiscardAlertPresented
        ) {
            Button("Остаться", role: .cancel) {}
            
            Button("Выйти") {
                dismiss()
            }
        }
        .alert(
            "Ошибка",
            isPresented: $isSaveErrorAlertPresented
        ) {
            Button("ОК", role: .cancel) {}
        } message: {
            Text("Не удалось сохранить профиль")
        }
    }
}

#Preview {
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    let viewModel = ProfileViewModel(
        profileService: services.profileService
    )
    
    EditProfileView(
        profile: Profile(
            name: "Joaquin Phoenix",
            avatar: URL(string: "https://example.com/avatar.jpg")!,
            description: "Дизайнер из Казани",
            website: URL(string: "https://example.com")!,
            nfts: [],
            likes: [],
            id: "1"
        ),
        viewModel: viewModel
    )
}
