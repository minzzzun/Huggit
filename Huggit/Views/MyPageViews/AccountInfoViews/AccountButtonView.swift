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
        HStack(spacing: 15) {
            Image("\(service)Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 1) {
                Text(service.firstLetterCapitalized)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.primaryWhite)
                Text(serviceDetail)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.primaryWhite)
            }
            
            Spacer()
            
            Button(action: action) {
                Text("수정")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.primaryWhite)
                    .frame(width: 40, height: 25)
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.editGray)
            )
        }
    }
}
