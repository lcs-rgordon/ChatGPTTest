//
//  FancyView.swift
//  ChatGPTTest
//
//  Created by Russell Gordon on 2024-06-13.
//

import SwiftUI

struct FancyView: View {
    var body: some View {
        Text("This view will ask the user for books they have read, so the query can be adjusted.")
    }
}

#Preview {
    LandingView(selectedTab: Binding.constant(2))
}
