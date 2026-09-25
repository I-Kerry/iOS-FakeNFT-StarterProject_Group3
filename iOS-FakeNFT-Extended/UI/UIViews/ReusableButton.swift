//
//  ReusableButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 18.09.2026.
//

import SwiftUI

struct ReusableButton: View {
    let title: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(.textMain)
                .font(.bodyBold)
                .frame(width: Constants.width, height: Constants.height)
                .background(Color.button)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

private enum Constants {
    static let width: CGFloat = 343
    static let height: CGFloat = 60
    static let cornerRadius: CGFloat = 16
}

#Preview("light") {
    ReusableButton(title: "Оплатить", action: {})
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ReusableButton(title: "Оплатить", action: {})
        .preferredColorScheme(.dark)
}
