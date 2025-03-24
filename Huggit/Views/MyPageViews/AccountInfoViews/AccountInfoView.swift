//
//  AccountInfoView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct Service {
    let name: String
    let detail: String
    let action: () -> Void
}

struct AccountInfoView: View {
    @EnvironmentObject var viewModel: MyPageViewModel
    
    // TODO: ViewModel에서 action 정의하기
    var services: [Service] {
        [
            Service(name: "Github", detail: viewModel.githubName, action: {}),
            Service(name: "Velog", detail: viewModel.velogName, action: {}),
            Service(name: "Tistory", detail: viewModel.tistoryName, action: {})
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("계정 정보")
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.bottom, 20)
            VStack {
                ForEach(services.indices, id: \.self) { index in
                    let service = services[index]
                    VStack(spacing: 0) {
                        AccountButtonView(
                            service: service.name,
                            serviceDetail: service.detail,
                            action: service.action
                        )
                        if index < services.count - 1 {
                            VStack {
                                Divider()
                                    .frame(height: 0.8)
                            }
                            .padding(.vertical, 18)
                            .padding(.horizontal, 30)
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color.gray)
            )
        }
    }
}
