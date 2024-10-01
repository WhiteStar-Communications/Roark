//
//  RKOrientationModel.swift
//  
//
//  Created by Logan Miller on 10/1/24.
//

import SwiftUI

// ObservableObject to track orientation changes
class RKOrientationModel: ObservableObject {
    @Published var isPortrait: Bool = true

    // Function to update orientation
    func updateOrientation() {
        let orientation = UIDevice.current.orientation
        // Check if the device is in portrait orientation
        if orientation == .portrait || orientation == .portraitUpsideDown {
            isPortrait = true
        } else if orientation == .landscapeLeft || orientation == .landscapeRight {
            isPortrait = false
        }
    }
}
