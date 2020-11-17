//
//  Protocols.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

//home protocols
@available(iOS 13.0, *)
protocol HomeVcDelegate {
    func handleMenuToggle(forMenu menu: MenuOption?)
}

//login protocols
protocol LoginViewModelDelegate {
    func didLoginSuccess(_ viewModel: LoginViewModel, user: User)
    func didFailedLogin(_ error: Error)
}

//profile protocols
protocol ProfileViewModelDelegate {
    func didFetchUser(_ viewModel: ProfileViewModel, user: UserModel)
    func didFailedToFetch(_ error: Error)
}
