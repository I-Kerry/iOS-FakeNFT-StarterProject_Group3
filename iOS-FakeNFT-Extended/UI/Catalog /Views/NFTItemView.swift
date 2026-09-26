import SwiftUI

struct NFTItemView: View {
	let nftId: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			ZStack(alignment: .topTrailing) {
				Color.gray.opacity(0.3)
					.frame(width: 108, height: 108)
					.cornerRadius(12)
				
				Button {
					
				} label: {
					Image(systemName: "heart.fill")
						.foregroundColor(.white)
						.padding(12)
				}
			}
			
			HStack(spacing: 2) {
				ForEach(0..<5) { _ in
					Image(systemName: "star.fill")
						.font(.system(size: 10))
						.foregroundColor(.yellow)
				}
			}
			.padding(.top, 8)
			
			Text("Archie")
				.font(.system(size: 17, weight: .bold))
				.foregroundColor(.primary)
				.padding(.top, 4)
			
			HStack {
				VStack(alignment: .leading, spacing: 2) {
					Text("Цена")
						.font(.system(size: 10, weight: .regular))
						.foregroundColor(.secondary)
					Text("1 ETH")
						.font(.system(size: 10, weight: .bold))
						.foregroundColor(.primary)
				}
				
				Spacer()
				
				Button {
					
				} label: {
					Image(systemName: "bag.fill")
						.foregroundColor(.primary)
				}
			}
			.padding(.top, 4)
			
			Spacer(minLength: 0)
		}
		.frame(width: 108, height: 192)
	}
}

#Preview {
	NFTItemView(nftId: "1")
}
