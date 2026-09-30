import SwiftUI
import Kingfisher

struct EditProfileView: View {
    let profile: Profile

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
                    ZStack(alignment: .bottomTrailing) {
                        KFImage(profile.avatar)
                            .placeholder {
                                Circle()
                                    .fill(.gray.opacity(0.3))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 73, height: 73)
                            .clipShape(Circle())

                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(uiColor: .yaBlackLight))
                            .frame(width: 23, height: 23)
                            .background(Color(uiColor: .yaLightGrayLight))
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                    Text("Имя")
                        .font(Font(UIFont.headline3))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .padding(.top, 24)

                    Text(profile.name)
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

                    Text(profile.description)
                        .font(Font(UIFont.bodyRegular))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(16)
                        .frame(minHeight: 132, alignment: .topLeading)
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
                    .background(Color(uiColor: .yaBlackLight))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(.background)
        .navigationBarBackButtonHidden(true)
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
