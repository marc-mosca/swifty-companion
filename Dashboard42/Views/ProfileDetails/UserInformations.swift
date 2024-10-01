//
//  UserInformations.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserInformations: View {
    let user: User
    
    private var grade: String? { user.mainCursus?.grade }
    private var level: String? { user.mainCursus?.level.formatted() }
    private var correctionPoints: String { user.correctionPoint.formatted() }
    private var wallets: String { user.wallet.formatted() }
    
    var body: some View {
        List {
            Section("General") {
                HRow(title: "Name", value: user.displayname)
                HRow(title: "Email", value: user.email)
            }
            
            Section("Cursus") {
                HRow(title: "Grade", value: grade != nil ? grade! : "Undefined")
                HRow(title: "Level", value: level != nil ? level! : "Undefined")
                HRow(title: "Correction points", value: correctionPoints)
                HRow(title: "Wallets", value: wallets)
                HRow(title: "Promotion", value: "\(user.poolMonth.capitalized) \(user.poolYear)")
            }
        }
        .navigationTitle("Informations")
    }
}
