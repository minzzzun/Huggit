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
                    .textStyle(.c411R)
                    .foregroundStyle(Color.primaryWhite)
                Text(serviceDetail)
                    .textStyle(.h615M)
                    .foregroundStyle(Color.primaryWhite)
            }
            
            Spacer()
            
            Button(action: action) {
                Text("수정")
                    .textStyle(.d611M)
                    .foregroundStyle(Color.primaryWhite)
                    .frame(width: 40, height: 25)
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray200)
            )
        }
    }
}
