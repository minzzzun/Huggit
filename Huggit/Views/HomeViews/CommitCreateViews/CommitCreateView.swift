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
                    .textStyle(.s213M)
                    .foregroundStyle(Color.primaryBlue)
                Spacer()
                Button(action: {
                    commitCreateViewModel.cancelCommit()
                }) {
                    Image("cancel")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
            }
            
            Text("제목은 커밋 메시지로,\n내용은 파일로 업로드 돼요!")
                .textStyle(.h518SB)
                .foregroundStyle(Color.primaryWhite)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
            
            VStack(spacing: 9) {
                TextField("", text: Binding(
                    get: { commitCreateViewModel.commitTitle },
                    set: { commitCreateViewModel.commitTitle = $0 }
                ))
                .textStyle(.c114R)
                .padding(EdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18))
                .background(Color.gray400)
                .foregroundStyle(Color.gray000)
                .cornerRadius(5)
                
                LineNumberTextEditor(text: Binding(
                    get: { commitCreateViewModel.commitDetails },
                    set: { commitCreateViewModel.commitDetails = $0 }
                ))
                .background(Color.gray400)
                .frame(height: 232)
                .cornerRadius(5)
            }
            .padding(.top, 18)
            
            Spacer()
            
            Button(action: {
                commitCreateViewModel.pushCommit()
            }) {
                HStack {
                    if commitCreateViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.trailing, 5)
                    }
                    Text("commit!")
                        .foregroundColor(Color.primaryWhite)
                        .textStyle(.b117SB)
                }
                .frame(maxWidth: .infinity, maxHeight: 55)
                .background(Color.primaryBlue)
                .cornerRadius(10)
            }
            
        }
        .padding(20)
    }
}
