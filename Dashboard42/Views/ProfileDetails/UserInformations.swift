//
//  UserInformations.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserInformations: View {
    let user: User
    
    private var grade: String? { self.user.mainCursus?.grade }
    private var level: String? { self.user.mainCursus?.level.formatted() }
    private var correctionPoints: String { self.user.correctionPoint.formatted() }
    private var wallets: String { self.user.wallet.formatted() }
    
    var body: some View {
        List {
            Section("General") {
                HRow(title: "Name", value: self.user.displayname)
                HRow(title: "Email", value: self.user.email)
            }
            
            Section("Cursus") {
                HRow(title: "Grade", value: self.grade != nil ? self.grade! : "Undefined")
                HRow(title: "Level", value: self.level != nil ? self.level! : "Undefined")
                HRow(title: "Correction points", value: self.correctionPoints)
                HRow(title: "Wallets", value: self.wallets)
                HRow(title: "Promotion", value: "\(self.user.poolMonth.capitalized) \(self.user.poolYear)")
            }
        }
        .navigationTitle("Informations")
    }
}
