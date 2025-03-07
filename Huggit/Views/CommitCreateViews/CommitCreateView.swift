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
        VStack {
            HStack {
                Text("CommitCreateView")
                    .font(.headline)
                Spacer()
                Button(action: {
                    commitCreateViewModel.cancelCommit()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black)
                        .font(.title)
                }
            }
            
            TextField("", text: Binding(
                get: { commitCreateViewModel.commitTitle },
                set: { commitCreateViewModel.commitTitle = $0 }
            ))
                .padding()
                .background(Color.gray)
                .cornerRadius(8)
            
            TextEditor(text: Binding(
                get: { commitCreateViewModel.commitDetails },
                set: { commitCreateViewModel.commitDetails = $0 }
            ))
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
            
            Spacer()
            
            Button(action: {
                commitCreateViewModel.pushCommit()
            }) {
                Text("commit")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
        }
        .padding()
    }
}
