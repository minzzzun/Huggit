//
//  HomeHeaderView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct HomeHeaderView: View {
    let month = Calendar.current.component(.month, from: Date())
    var commitsInMonth: Int = 20
    var body: some View {
        HStack {
            VStack {
                Text("오늘도 1일 1커밋을 향해 달려볼까요?")
                Text("\(month)월에는 \(commitsInMonth)개의 커밋이\n업로드 되었어요!")
            }
            Spacer()
            StampView()
        }
    }
}
