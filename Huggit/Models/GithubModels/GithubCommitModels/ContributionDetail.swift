//
//  CommitDetail.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/4/25.
//

import Foundation

struct ContributionDetail: Identifiable, Decodable {
    var id = UUID()  
    let repositoryName: String
    let messages: [String]
}
