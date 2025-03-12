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
    // TODO: ViewModel에서 관리
    let useInfos: [UseInfo] = [
        UseInfo(name: "개인정보 처리방침", action: {}),
        UseInfo(name: "서비스 이용 약관", action: {}),
        UseInfo(name: "로그아웃", action: {}),
        UseInfo(name: "탈퇴하기", action: {})
    ]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("이용 안내")
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.bottom, 20)
            VStack (spacing: 28) {
                ForEach(useInfos.indices, id: \.self) { index in
                    let useInfo = useInfos[index]
                    
                    HStack {
                        Text(useInfo.name)
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                        Spacer()
                        Button(action: useInfo.action) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                                .scaledToFit()
                                .frame(height: 8)
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
