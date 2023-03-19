//
//  SortOptions.swift
//  Mobile-project-iOS
//
//  Created by Romain on 13/03/2023.
//

import Foundation

// This enum is used to sort the list of volunteers, games, timeslots and areas
enum SortOptions {
    // For the list of all the volunteers
    case firstNameAscending
    case firstNameDescending
    case lastNameAscending
    case lastNameDescending

    // For the list of all the games
    case nameAscending
    case nameDescending
    case typeAscending
    case typeDescending
    
    // For the list of all the assignments
    case startDateAscending
    case startDateDescending
    case endDateAscending
    case endDateDescending

    // For the list of all the timeslots, case with dates
    // For the list of all the areas, case with areas
}
