//
//  BiometricHandler.swift
//  FanServe
//
//  Created by macbook on 15/12/22.
//

import Foundation
import LocalAuthentication

class BiometricHandler {
    
    static let shared = BiometricHandler()
    
    private init() {}
    
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        let reason = "FanServe uses Biometric to log you in."
        context.evaluatePolicy(
            // .deviceOwnerAuthentication allows
            // biometric or passcode authentication
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, error in
            completion(success)
//            if success {
//                // Handle successful authentication
//            } else {
//                // Handle LAError error
//            }
        }
    }
    
}
