//
//  Date+Extensions.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Date extension providing human-readable relative time formatting.
//  Used for displaying post timestamps in a user-friendly format.

import Foundation

extension Date {
    /// Returns a human-readable string describing how long ago the date was
    /// Formats time differences from seconds to years
    /// - Returns: String like "2 hours ago", "3 days ago", "just now"
    /// - Example: A date 2 hours ago returns "2 hours ago"
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .month, .year], from: self, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year) year\(year > 1 ? "s" : "") ago"
        }
        if let month = components.month, month > 0 {
            return "\(month) month\(month > 1 ? "s" : "") ago"
        }
        if let week = components.weekOfYear, week > 0 {
            return "\(week) week\(week > 1 ? "s" : "") ago"
        }
        if let day = components.day, day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        }
        if let second = components.second, second > 0 {
            return "\(second) second\(second > 1 ? "s" : "") ago"
        }
        return "just now"
    }
}

