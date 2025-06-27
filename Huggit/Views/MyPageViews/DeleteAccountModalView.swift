//
//  DeleteAccountModalView.swift
//  Huggit
//
//  Created by 김민준 on 6/27/25.
//

import SwiftUI

struct DeleteAccountModalView: View {
    @Binding var isPresented: Bool
    var confirmAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("회원탈퇴")
                .textStyle(.b117SB)
                .foregroundColor(.primaryWhite)
            
            Text("정말로 회원탈퇴를 하시겠어요?\n\n회원탈퇴 시 모든 데이터가\n영구적으로 삭제됩니다.")
                .textStyle(.b213R)
                .foregroundColor(.gray100)
                .multilineTextAlignment(.center)
                .padding(.top, 3)
            
            HStack(spacing: 11) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .foregroundColor(.gray000)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                        .background(Color.gray300)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    confirmAction()
                    isPresented = false
                }) {
                    Text("회원탈퇴")
                        .foregroundColor(.gray000)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                        .background(Color.errorRed)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 30)
            
        }
        .padding(.top, 35)
        .padding([.horizontal, .bottom], 20)
        .background(Color.gray600)
        .cornerRadius(10)
    }
}

