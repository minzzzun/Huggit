//
//  LogoutModalView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 5/19/25.
//


import SwiftUI

struct LogoutModalView: View {
    @Binding var isPresented: Bool
    var confirmAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("로그아웃 하기")
                .textStyle(.b117SB)
                .foregroundColor(.primaryWhite)
            
            Text("로그아웃 하시겠어요?")
                .textStyle(.b213R)
                .foregroundColor(.gray100)
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
                    Text("확인")
                        .foregroundColor(.gray000)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                        .background(Color.primaryBlue)
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
