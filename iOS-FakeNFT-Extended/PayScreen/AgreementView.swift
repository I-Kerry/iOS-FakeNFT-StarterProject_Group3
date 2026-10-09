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
    var isEnabled = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.normalSpacing) {
            VStack(alignment: .leading, spacing: Constants.smallSpacing) {
                Text(Constants.agreementTitle)
                    .font(.caption2)
                    .foregroundStyle(.button)
                Button(Constants.agreementButtonTitle) {
                    showWebView = true
                }
                .font(.caption2)
                .foregroundStyle(.licenseAgreement)
            }
            
            ReusableButton(title: Constants.buttonTitle, action: onPay)
                .disabled(!isEnabled)
        }
        .padding(Constants.padding)
        .frame(maxWidth: .infinity)
        .background(.graySecondaryBackground)
        .sheet(isPresented: $showWebView) {
            if let url = URL(string: Constants.urlString) {
                WebView(url: url)
            }
        }
    }
}

private enum Constants {
    static let normalSpacing: CGFloat = 16
    static let smallSpacing: CGFloat = 5
    static let padding: CGFloat = 16
    
    static let agreementTitle = String(localized: "Payment.agreement")
    static let agreementButtonTitle = String(localized: "Payment.agreementTitle")
    static let buttonTitle = String(localized: "Payment.pay")
    static let urlString = "https://yandex.ru/legal/practicum_termsofuse"
}

#Preview {
    AgreementView(onPay: {}, isEnabled: true)
}
