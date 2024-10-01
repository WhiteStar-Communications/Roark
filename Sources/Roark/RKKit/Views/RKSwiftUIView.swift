//
//  RKSwiftUIView.swift
//
//
//  Created by Logan Miller on 9/20/24.
//

import SwiftUI

public protocol RKSwiftUIView: View {
    var orientationModel: RKOrientationModel? { get set }
    var viewModel: RKViewModel? { get set }
}
