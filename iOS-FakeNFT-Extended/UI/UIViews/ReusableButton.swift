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
                .frame(width: 343, height: 60)
                .background(Color.button)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    ReusableButton(title: "Оплатить", action: {})
        .preferredColorScheme(.light)
}

#Preview {
    ReusableButton(title: "Оплатить", action: {})
        .preferredColorScheme(.dark)
}
