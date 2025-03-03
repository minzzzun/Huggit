//
//  StampView.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/3/25.
//

import SwiftUI

struct StampView: View {
    var daysIn3Days: Int = 1
    
    var body: some View {
        VStack (alignment: .trailing){
            ZStack (alignment: .top){
                Image("tooltip_long")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 121, height: 30.15)
                
                Text("\(daysIn3Days)일 연속 commit 실천중!")
                    .foregroundStyle(.white)
                    .font(.system(size: 9))
                    .padding(.top, 7)
            }
            
            HStack(spacing: 0) {
                Image(stampName(for: 1))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(0)
                
                Image(stampName(for: 2))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .padding(.leading, -20.1)
                    .padding(.trailing, 0)
                
                Image(stampName(for: 3))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 63, height: 63)
                    .padding(.leading, -24.2)
                    .padding(.trailing, 0)
                    .shadow(color: Color.white.opacity(0.8), radius: 12.6)
            }

        }
    }
    
    private func stampName(for stampOrder: Int) -> String {
        switch stampOrder {
        case 1:
            return daysIn3Days >= 3 ? "stamp_1st_enable" : "stamp_1st_disable"
        case 2:
            return daysIn3Days >= 2 ? "stamp_2nd_3rd_enable" : "stamp_2nd_3rd_disable"
        case 3:
            return daysIn3Days >= 1 ? "stamp_2nd_3rd_enable" : "stamp_2nd_3rd_disable"
        default:
            return ""
        }
    }
}
