//
//  ContactSection.swift
//  zeliz22-ass4
//
//  Created by zaza elizbarashvili on 13/11/1403 AP.
//

import Foundation

struct ContactSection{
    var header: ContactHeaderModel
    var contacts: [Contact]
    
    init(header: ContactHeaderModel, contacts: [Contact]){
        self.header = header
        self.contacts = contacts
    }
}
