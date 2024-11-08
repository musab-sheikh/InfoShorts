//
//  Extensions.swift
//  InfoShorts
//
//  Created by Mirza Musab Baig on 03/11/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
