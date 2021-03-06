//
//  Project.swift
//  CoolestProjects
//
//  Created by Valentino Gattuso on 09/06/2016.
//  Copyright © 2016 coderdojo. All rights reserved.
//

import Foundation
import Gloss

struct Project {
    let name: String
    let category: String
    let projectDescription: String
    let coderdojo: String
    let deskNumber: String?
}

extension Project: Decodable {
    
    init?(json: JSON) {
        guard
            let name: String = "name" <~~ json,
            let category: String = "category" <~~ json,
            let projectDescription: String = "description" <~~ json,
            let coderdojo: String = "coderdojo" <~~ json
            else { return nil }

        self.name = name
        self.category = category
        self.projectDescription = projectDescription
        self.coderdojo = coderdojo
        self.deskNumber = "deskNumber" <~~ json
    }
}

extension Project: Glossy {
    
    func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> self.name,
            "category" ~~> self.category,
            "description" ~~> self.projectDescription,
            "coderdojo" ~~> self.coderdojo,
            "deskNumber" ~~> self.deskNumber
            ])
    }
    
}
