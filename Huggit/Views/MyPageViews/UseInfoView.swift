//
//  UseInfoView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/12/25.
//

import SwiftUI

struct UseInfo {
    let name: String
    let action: () -> Void
}

struct UseInfoView: View {
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.openURL) private var openURL
    
    @Binding var showLogoutModal: Bool
    @Binding var showDeleteAccountModal: Bool

    private let privacyPolicyURL = URL(string: "https://future-glass-b30.notion.site/Huggit-1ce93d5fc4ad8037956cdc09a468375a?pvs=4")!
    private let termsOfUseURL = URL(string: "https://future-glass-b30.notion.site/Huggit-1ce93d5fc4ad8001a179c56061082798?pvs=4")!
    
    var useInfos: [UseInfo] {
        [
            UseInfo(name: "개인정보 처리방침", action: {
                openURL(privacyPolicyURL)
            }),
            UseInfo(name: "서비스 이용 약관", action: {
                openURL(termsOfUseURL)
            }),
            UseInfo(name: "로그아웃", action: {
                showLogoutModal = true
            }),
            UseInfo(name: "회원탈퇴", action: {
                showDeleteAccountModal = true
            })
        ]
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("이용 안내")
                .textStyle(.b117SB)
                .foregroundStyle(Color.gray000)
                .padding(.bottom, 20)
            VStack (spacing: 28) {
                ForEach(useInfos.indices, id: \.self) { index in
                    let useInfo = useInfos[index]
                    
                    HStack {
                        Text(useInfo.name)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.gray100)
                        Spacer()
                        Button(action: useInfo.action) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.gray300)
                                .scaledToFit()
                                .frame(height: 8)
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color.gray600)
            )
        }
    }
}
