//
//  VNRecognizedTextObservation+Size.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/19/22.
//

import Vision

extension VNRecognizedTextObservation {
    func size() -> CGFloat {
        let width = topRight.x - topLeft.x
        let height = topLeft.y - bottomLeft.y
        return width * height
    }
}
