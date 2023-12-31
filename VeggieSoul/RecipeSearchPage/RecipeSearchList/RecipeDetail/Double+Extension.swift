//
//  Double+Extension.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 31/12/23.
//

import Foundation

extension Double {
    func roundOut(numberOfDecimals: Int) -> String {
        let formateador = NumberFormatter()
        formateador.maximumFractionDigits = numberOfDecimals
        formateador.roundingMode = .down
        return formateador.string(from: NSNumber(value: self)) ?? ""
    }
}
