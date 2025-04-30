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
    @EnvironmentObject var router: NavigationRouter
    
    // TODO: ViewModel에서 action 정의하기
    var services: [Service] {
        [
            Service(name: "github", detail: viewModel.githubName, action: {
                router.toNamed("/githubModify")
            }),
            Service(name: "velog", detail: viewModel.velogName, action: {
                router.toNamed("/velogModify")
            }),
            Service(name: "tistory", detail: viewModel.tistoryName, action: {
                router.toNamed("/tistoryModify")
            })
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("계정 정보")
                .font(.system(size: 17))
                .foregroundStyle(.white)
            VStack(spacing: 30) {
                ForEach(services.indices, id: \.self) { index in
                    let service = services[index]
                    AccountButtonView(
                        service: service.name,
                        serviceDetail: service.detail,
                        action: service.action
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
            )
        }
    }
}
