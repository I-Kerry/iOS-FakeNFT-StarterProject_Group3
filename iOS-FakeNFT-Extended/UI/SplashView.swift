import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -15
    
    var body: some View {
        ZStack {
			Color.white.ignoresSafeArea()
            VStack {
                Image(.splashLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotation))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
                rotation = 0
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.8)) {
                scale = 1.1
            }
        }
    }
    
    private enum Constants {
        static let imageWidth: CGFloat = 75
        static let imageHeight: CGFloat = 77.68
    }
}

#Preview {
    SplashView()
}
