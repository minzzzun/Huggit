//
//  CommitCreateView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/7/25.
//

import SwiftUI

struct CommitCreateView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var commitCreateViewModel: CommitCreateViewModel {
        homeViewModel.commitCreateViewModel
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack (alignment: .top, spacing: 0) {
                Text("성실한 개발자로 한발씩 더 성장!")
                    .font(.system(size: 12))
                    .foregroundStyle(.blue)
                Spacer()
                Button(action: {
                    commitCreateViewModel.cancelCommit()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black)
                        .font(.title)
                }
            }
            
            Text("제목은 커밋 메시지로,\n내용은 파일로 업로드 돼요!")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
            
            VStack(spacing: 9) {
                TextField("", text: Binding(
                                get: { commitCreateViewModel.commitTitle },
                                set: { commitCreateViewModel.commitTitle = $0 }
                            ))
                .padding(EdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18))
                .font(.system(size: 14))
                            .background(Color.black)
                            .foregroundStyle(.white)
                            .cornerRadius(5)
                
                LineNumberTextEditor(text: Binding(
                                get: { commitCreateViewModel.commitDetails },
                                set: { commitCreateViewModel.commitDetails = $0 }
                            ))
                .background(Color.black)
                            .frame(height: 231)
                            .cornerRadius(5)
            }
            .padding(.top, 18)
            
            Spacer()
            
            Button(action: {
                commitCreateViewModel.pushCommit()
            }) {
                Text("commit!")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 55)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
        }
        .padding(20)
    }
}
