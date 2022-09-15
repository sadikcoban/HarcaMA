//
//  String+Shorted.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import Foundation

extension String {
    func shorted(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + " ..."
    }
}
