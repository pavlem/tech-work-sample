//
//  HelperFunctions.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 27/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation

func aprint(_ any: Any, function: String = #function, file: String = #file, line: Int = #line) {
    let fileName = file.lastPathComponent
    print("🍏\(any)- - - - - - - - - - - - - - - - - - - - - \(fileName!) || \(function) || \(line)")
}
