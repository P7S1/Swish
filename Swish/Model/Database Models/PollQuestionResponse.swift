//
//  PollQuestionResponse.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/1/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation

struct PollQuestionResponse : Codable {
    let userData : [User]
    let questionData : Question
    let gender : GenderType
}
