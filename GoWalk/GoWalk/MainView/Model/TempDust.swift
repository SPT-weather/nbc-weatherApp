//
//  TempDust.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation
// 임시 미세먼지 모델
struct TempDust {
    let micro: Int
    let fine: Int

    static let failure = TempDust(micro: 0, fine: 0)
}
