//
//  Constants.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-25.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

enum TreeProperties: String{
    case numofV = "number-of-volunteers"
    case type = "type-of-trees"
    case numofTrees = "number-of-trees"
}
enum Roles: String{
    case volunteer = "Volunteer"
    case lead = "Leader"
    case admin = "Administrator"
}
enum ButtonStates: String{
    case signup = "Sign-up"
    case cancel = "Cancel"
}
typealias communityPartner = Dictionary<String, String>
enum dropOffFields: String{
    case location = "location"
    case name = "name"
    case opentime = "openTime"
    case notes = "notes"
}
