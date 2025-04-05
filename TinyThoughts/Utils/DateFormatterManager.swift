//
//  DateFormatterManager.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  centralized date formatter for consistent date formatting across the app

import Foundation

class DateFormatterManager {
    // MARK: - Singleton
    static let shared = DateFormatterManager()
    
    // MARK: - Properties
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - Initialization
    private init() {}
} 