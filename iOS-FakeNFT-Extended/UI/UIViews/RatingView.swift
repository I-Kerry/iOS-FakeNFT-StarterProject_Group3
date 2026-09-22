//
//  RatingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import SwiftUI

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? Constants.starfilled : Constants.starEmptied)
                    .foregroundStyle(star <= rating ? .starColored : .starUncolored)
                    .font(.system(size: 12))
            }
        }
    }
}

private enum Constants {
    static let starfilled = "star.fill"
    static let starEmptied = "star"
}

#Preview {
    ZStack {
        Color.red
        RatingView(rating: 4)
    }
    
}
