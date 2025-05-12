//
//  WarningView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/1/25.
//

import SwiftUI

struct WarningView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(loginStep: 4)
            
            (
                Text("HUGGIT_TECHBLOG 깃허브 레파지토리\n")
                    .foregroundStyle(Color.primaryWhite)
                + Text("주의 사항")
                    .foregroundStyle(Color.primaryBlue)
                + Text("을 안내 드릴게요!")
                    .foregroundStyle(Color.primaryWhite)
            )
            .textStyle(.h323SB)
            .lineLimit(3)
            .minimumScaleFactor(0.75)   // 원본의 75%까지 축소 허용
            .allowsTightening(true)     // 글자 간격도 같이 압축
            .multilineTextAlignment(.center)            .padding(.top, 32)
            
            Image("repo_check")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 92)
                .padding(.top, 68)
                .padding(.leading, 9.46)
            
            Spacer()
            
            VStack(spacing: 23) {
                WarningInstructionView(
                    num: 1,
                    instruction: "허깃 앱을 통해 심은 모든 잔디 소스는\nHUGGIT_TECHBLOG 레파지토리에 저장돼요",
                    highlight: "HUGGIT_TECHBLOG"
                )
                WarningInstructionView(
                    num: 2,
                    instruction: "HUGGIT 레파지토리를 삭제할 시,\n파일에 저장된 모든 잔디 정보가 삭제돼요",
                    highlight: "모든 잔디 정보가 삭제"
                )
                WarningInstructionView(
                    num: 3,
                    instruction: "HUGGIT 레파지토리 이름을 변경할 시,\n깃허브 계정 연동 과정을 다시 거쳐야 해요",
                    highlight: "깃허브 계정 연동 과정을 다시 거쳐야 해요"
                )
            }
            .padding(.bottom, 52)
            
            // 애플 로그인 버튼
            Button(action:{
                router.offAll("/")
            }){
                Text("모두 확인했어요")
                    .textStyle(.b117SB)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Color.primaryBlue)
                    .foregroundColor(Color.primaryWhite)
                    .cornerRadius(10)
            }
            .padding(.bottom, 48)
        }
        .padding(.horizontal, 20)
        .background(Color.primaryDarkBlue)
        .navigationBarHidden(true)
    }
}
