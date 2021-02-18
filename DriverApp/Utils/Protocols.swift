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
    func didLoginSuccess(_ viewModel: LoginViewModel, user: User, bio: Bio)
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
    static let didCloseAdmin = Notification.Name("didCloseAdmin")
    static let didSelectAdmin = Notification.Name("didSelectAdmin")
    static let didOpenChat = Notification.Name("didOpenChat")
    static let didOpenOrder = Notification.Name("didOpenOrder")
}
