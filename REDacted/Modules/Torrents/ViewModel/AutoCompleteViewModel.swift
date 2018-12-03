//
//  AutoCompleteViewModel.swift
//  REDacted
//
//  Created by Greazy on 12/2/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct AutoCompleteViewModel {
    let results: [String]
    
    init (autoCompleteResults: [AutoCompleteSuggestion]) {
        self.results = autoCompleteResults.map({$0.value})
    }
    
}
