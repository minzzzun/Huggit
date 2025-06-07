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
                    .foregroundStyle(Color.gray200)
                Text(serviceDetail)
                    .textStyle(.h615M)
                    .foregroundStyle(serviceDetail == "아직 등록되지 않았어요" || serviceDetail == "Guest" ? Color.gray300 : Color.gray100)
            }
            
            Spacer()
            
            if serviceDetail != "Guest" {
                Button(action: action) {
                    Text("수정")
                        .textStyle(.d611M)
                        .foregroundStyle(Color.gray200)
                        .frame(width: 40, height: 25)
                }
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray500)
                )
            }
        }
    }
}
