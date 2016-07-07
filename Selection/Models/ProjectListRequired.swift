//
//  ProjectListRequired.swift
//  Selection
//
//  Created by April on 6/8/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import Foundation

class ProjectListRequired {
    var email: String
    var password: String
    var idcia : String
    var username :String
    var iddeptos : String
    
    required init(email _email: String, password _pwd: String, idcia: String, username : String, iddeptos: String){
        self.email = _email
        self.password = _pwd
        self.idcia = idcia
        self.username = username
        self.iddeptos = iddeptos
    }
    
    func toDictionary() -> [String: String]{
        return ["email" : email, "password" : password, "idcia" : idcia, "username" : username, "iddeptos" : iddeptos ]
    }
}
