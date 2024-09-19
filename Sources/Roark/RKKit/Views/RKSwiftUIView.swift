//
//  RKSwiftView.swift
//  
//
//  Created by Logan Miller on 9/19/24.
//

import SwiftUI

public protocol RKSwiftView : View {    
    var viewModel: RKViewModel { get set }
}
