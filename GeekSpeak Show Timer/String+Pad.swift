//
//  String+Pad.swift
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 4/10/16.
//  Copyright © 2016 Brian Young. All rights reserved.
//

import Foundation

extension String
{
    enum Direction {
        case left
        case right
    }

    func pad(_ character: Character,
           totalLength: Int,
                  side: Direction) -> String {
            
            var string = self
            
            let i = string.characters.count
            
            let amountToPad = totalLength - i
            if amountToPad < 1 {
                return string
            }
            let padString = String(describing: pad)
            for _ in 1...amountToPad {
                switch side {
                case .left:  string = string + padString
                case .right: string = padString + string
                }
            }
            return string
    }

}
