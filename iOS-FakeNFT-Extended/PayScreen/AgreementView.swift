//
//  AgreementView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 26.09.2026.
//

import SwiftUI

struct AgreementView: View {
    @State private var showWebView = false
    let onPay: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Совершая покупку, вы соглашаетесь с условиями")
                    .font(.caption2)
                    .foregroundStyle(.button)
                Button("Пользовательского соглашения") {
                    showWebView = true
                }
                .font(.caption2)
                .foregroundStyle(.licenseAgreement)
            }
            
            ReusableButton(title: "Оплатить", action: onPay)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.graySecondaryBackground)
        .sheet(isPresented: $showWebView) {
            if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse") {
                WebView(url: url)
            }
        }
    }
}

#Preview {
    AgreementView(onPay: {})
}
