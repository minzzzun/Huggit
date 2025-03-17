//
//  AccountButtonView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct AccountButtonView: View {
    var service: String
    var serviceDetail: String
    var action: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            Image("\(service)Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(service.firstLetterCapitalized)
                .font(.system(size: 15))
                .foregroundStyle(.white)
            Spacer()
            Text(serviceDetail)
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
        .onTapGesture {
            action()
        }
    }
}
