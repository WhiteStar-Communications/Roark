//
//  RKSwiftUIView.swift
//
//
//  Created by Logan Miller on 9/20/24.
//

import SwiftUI

public protocol RKSwiftUIView: View {
    var viewModel: RKViewModel { get set }
}
