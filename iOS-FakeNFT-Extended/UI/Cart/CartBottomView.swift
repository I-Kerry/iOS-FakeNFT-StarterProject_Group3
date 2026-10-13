import SwiftUI

struct CartBottomView: View {
	let nftAmount: Int
	let totalPrice: Double
	let onPay: () -> Void
	var body: some View {
		HStack(spacing: Constants.sStackSpacing) {
			VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
				Text("\(nftAmount) NFT")
					.font(.caption1)
					.foregroundStyle(Color.yaBlack)
				Text("\(totalPrice, specifier: "%.2f") ETH")
					.font(.bodyBold)
					.foregroundStyle(Color.yaGreen)
			}
			payButton
		}
		.padding(Constants.padding)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background {
			UnevenRoundedRectangle(
				topLeadingRadius: Constants.trailingLeadingCornerRadius,
				topTrailingRadius: Constants.trailingLeadingCornerRadius
			)
			.fill(Color.yaLightGray)
			.ignoresSafeArea(edges: .bottom)
		}
	}
	
	private var payButton: some View {
		Button(action: onPay) {
			Text(Constants.buttonTitle)
				.foregroundStyle(Color.white)
				.font(.bodyBold)
				.frame(width: Constants.buttonWidth, height: Constants.buttonHeight)
				.background(Color.yaBlack)
				.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
		}
	}
}

private enum Constants {
	static let sStackSpacing: CGFloat = 24
	static let vStackSpacing: CGFloat = 2
	static let padding: CGFloat = 16
	static let trailingLeadingCornerRadius: CGFloat = 12
	static let buttonWidth: CGFloat = 240
	static let buttonHeight: CGFloat = 44
	static let cornerRadius: CGFloat = 16
	
	static let buttonTitle = String(localized: "Cart.toPayment")
}

#Preview("light") {
	CartBottomView(nftAmount: 3, totalPrice: 8.56, onPay: {})
		.preferredColorScheme(.light)
}
#Preview("Dark") {
	CartBottomView(nftAmount: 3, totalPrice: 8.56, onPay: {})
		.preferredColorScheme(.dark)
}
