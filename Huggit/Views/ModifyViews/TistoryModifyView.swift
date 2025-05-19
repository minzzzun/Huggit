//
//  TistoryModifyView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 4/9/25.
//

import SwiftUI

struct TistoryModifyView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = TistoryModifyViewModel()
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.primaryDarkBlue)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }
            
            VStack (spacing: 0){
                //헤더뷰
                OnboardingHeaderView(loginStep: 1)
                Spacer()
                    .frame(height: 45)
                
                //bodyView
                
                VStack(alignment: .leading,spacing: 15) {
                    Image("tistoryLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                    
                    
                    Text("Tistory 닉네임을\n입력해주세요!")
                        .textStyle(.h227SB)
                        .foregroundColor(Color.primaryWhite)
//                    Text("입력해주세요!")
//                        .textStyle(.h227SB)
//                        .foregroundColor(Color.primaryWhite)
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("", text: $viewModel.tistoryName, prompt: Text("닉네임을 입력하세요.")
                            .foregroundColor(Color.gray300)
                        )
                        .padding(.vertical)
                        .background(Color.primaryDarkBlue)
                        .cornerRadius(5)
                        .foregroundColor(viewModel.showError ? .errorRed : .primaryWhite)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray300),
                            alignment: .bottom
                        )
                        
                        if viewModel.showError {
                            HStack (spacing: 6){
                                Image("error")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 13.5)
                                Text("존재하지 않는 닉네임이에요")
                                    .textStyle(.s213M)
                                    .foregroundColor(.errorRed)
                            }
                        }
                    }
                }
                
                Spacer()
                
                
                Text("입력하신 Tistory 계정에 올리는 글을 잔디로 심어요!")
                    .textStyle(.s114M)
                    .foregroundColor(Color.gray300)
                    .padding(.bottom, 19)
                
                
                Button(action:{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                    viewModel.validateTistory { isValid in
                        if isValid {
                            viewModel.saveTistoryName()
                            router.offNamed("/mypageView")
                        }
                    }
                }){
                    Text("다음")
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
        }
        .navigationBarHidden(true)
    }
}


