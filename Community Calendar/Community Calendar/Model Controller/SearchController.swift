//
//  SearchController.swift
//  Community Calendar
//
//  Created by Jordan Christensen on 1/30/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class SearchController {
    private let userDefaults = UserDefaults.standard // Use userdefaults to store user's searches
    // Note: This is stored locally. Search results will remain the same regardless of account signed in.
    
    func save(filteredSearch: Filter) {
        var tempArr = loadFromPersistantStore()
        tempArr.append(filteredSearch)
        userDefaults.setValue(try? PropertyListEncoder().encode(tempArr), forKey: searchPersistanceKey)
    }
    
    func loadFromPersistantStore() -> [Filter] {
        guard let data = userDefaults.object(forKey: searchPersistanceKey) as? Data, let decodedArray = try? PropertyListDecoder().decode([Filter].self, from: data) else { return [] }
        return decodedArray
    }
    
    func clearSearches() {
        userDefaults.setValue(nil, forKey: searchPersistanceKey)
    }
}
