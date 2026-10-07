import SwiftUI

struct CatalogSortMenuView: View {
	private enum MenuConstants {
		static let backgroundOpacity: Double = 0.5
		static let titleHeight: CGFloat = 42
		static let separatorHeight: CGFloat = 0.5
		static let itemHeight: CGFloat = 61
		static let containerHeight: CGFloat = 164
		static let buttonHorizontalPadding: CGFloat = 16
		static let containerHorizontalPadding: CGFloat = 8
		static let spacerHeight: CGFloat = 8
		static let cornerRadius: CGFloat = 13
		static let bottomPadding: CGFloat = 32
		static let animationDuration: Double = 0.2
	}
	
	private enum MenuColors {
		static let titleGray = Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.6)
		static let separatorGray = Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.3)
		static let universalBlue = Color(red: 10/255, green: 132/255, blue: 255/255)
		static let backgroundGray = Color(red: 245/255, green: 245/255, blue: 245/255).opacity(0.7)
	}
	
	@Binding var isPresented: Bool
	var onSortByName: () -> Void
	var onSortByCount: () -> Void
	
	var body: some View {
		ZStack {
			Color(.bgSortMenu)
				.opacity(MenuConstants.backgroundOpacity)
				.ignoresSafeArea()
				.onTapGesture {
					withAnimation(.easeInOut(duration: MenuConstants.animationDuration)) {
						isPresented = false
					}
				}
			
			VStack(spacing: 0) {
				Spacer()
				
				VStack(spacing: 0) {
					ZStack {
						Text("Сортировка")
							.font(.system(size: 13, weight: .regular))
							.tracking(-0.08)
							.foregroundStyle(MenuColors.titleGray)
					}
					.frame(height: MenuConstants.titleHeight)
					
					Rectangle()
						.frame(height: MenuConstants.separatorHeight)
						.foregroundStyle(MenuColors.separatorGray)
					
					Button {
						onSortByName()
						withAnimation { isPresented = false }
					} label: {
						Text("По названию")
							.font(.system(size: 20, weight: .regular))
							.tracking(0.38)
							.foregroundStyle(MenuColors.universalBlue)
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.padding(.horizontal, MenuConstants.buttonHorizontalPadding)
					}
					.frame(height: MenuConstants.itemHeight)
					
					Rectangle()
						.frame(height: MenuConstants.separatorHeight)
						.foregroundStyle(MenuColors.separatorGray)
					
					Button {
						onSortByCount()
						withAnimation { isPresented = false }
					} label: {
						Text("По количеству NFT")
							.font(.system(size: 20, weight: .regular))
							.tracking(0.38)
							.foregroundStyle(MenuColors.universalBlue)
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.padding(.horizontal, MenuConstants.buttonHorizontalPadding)
					}
					.frame(height: MenuConstants.itemHeight)
				}
				.frame(height: MenuConstants.containerHeight)
				.background(MenuColors.backgroundGray)
				.clipShape(RoundedRectangle(cornerRadius: MenuConstants.cornerRadius))
				.padding(.horizontal, MenuConstants.containerHorizontalPadding)
				
				Spacer()
					.frame(height: MenuConstants.spacerHeight)
				
				Button {
					withAnimation(.easeInOut(duration: MenuConstants.animationDuration)) {
						isPresented = false
					}
				} label: {
					Text("Закрыть")
						.font(.system(size: 20, weight: .semibold))
						.tracking(0.38)
						.foregroundStyle(MenuColors.universalBlue)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				.frame(height: MenuConstants.itemHeight)
				.background(Color.white)
				.clipShape(RoundedRectangle(cornerRadius: MenuConstants.cornerRadius))
				.padding(.horizontal, MenuConstants.containerHorizontalPadding)
			}
			.padding(.bottom, MenuConstants.bottomPadding)
			.ignoresSafeArea(edges: .bottom)
			.transition(.move(edge: .bottom))
		}
	}
}
