//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Maria Reshetnikova on 28/09/2026.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 0) {

            HStack {
                Spacer()

                Button {

                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 26))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 2)


            HStack(spacing: 16) {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 70, height: 70)

                Text("Имя пользователя")
                    .font(Font(UIFont.headline3))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("Описание профиля")
                    .font(Font(UIFont.caption2))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))

                Text("Сайт")
                    .font(Font(UIFont.caption1))
                    .foregroundStyle(Color(uiColor: .blueUniversal))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 20)


            VStack(spacing: 0) {
                ProfileNavigationRow(
                    title: "Мои NFT",
                    count: 112
                )


                ProfileNavigationRow(
                    title: "Избранные NFT",
                    count: 11
                )
            }
            .padding(.top, 40)

            Spacer()
        }
        .background(.background)
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
    ProfileView()
}
