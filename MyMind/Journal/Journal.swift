//
//  Journal.swift
//  MyMind
//
//  Created by STDC_30 on 19/05/2024.
//

import Foundation
import UIKit

enum JournalItem {
    case savedjournal(Journal)
    case newJournal
}

struct Journal {
    let title: String
    var content: String
    var date: Date
    var image: UIImage?
    var mood: String
}
