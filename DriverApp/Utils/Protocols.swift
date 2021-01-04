//
//  Protocols.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

//home protocols∫
import Foundation

//login protocols
protocol LoginViewModelDelegate {
    func didLoginSuccess(_ viewModel: LoginViewModel, user: User)
    func didFailedLogin(_ error: Error)
}

//profile protocols
protocol ProfileViewModelDelegate {
    func didFetchUser(_ viewModel: ProfileViewModel, user: UserModel, bio: Bio, vehicle: VehicleData)
    func didFailedToFetch(_ error: Error)
}

extension Notification.Name {
    static let didSendMessage = Notification.Name("didSendMessage")
    static let didOtherClick = Notification.Name("didOtherClick")
}
