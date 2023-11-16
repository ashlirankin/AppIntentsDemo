//
//  PersistenceController.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import Foundation

@MainActor
final class PersistenceController {
    
    static let shared = PersistenceController()
    private let fileManager: FileManager = FileManager.default
    
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tasks1")!
    
    private init() {}
    
    func writeItem<T: Codable>(at path: URL, _ item: T) throws {
        if !fileManager.fileExists(atPath: path.path()) {
            do {
                try fileManager.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
            }
        }

        do {
            var items: [T] = try readAllItems(at: path)
            items.append(item)
            let data = try JSONEncoder().encode(items)
            try data.write(to: path)
        }
    }
    
    func writeItems<T: Codable>(at path: URL, _ items: [T]) throws {
        if !fileManager.fileExists(atPath: path.path()) {
            do {
                try fileManager.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
            }
        }

        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: path)
        }
    }
    
    func readAllItems<T: Codable>(at path: URL) throws -> [T] {
        do {
            guard let data = fileManager.contents(atPath: path.path()) else{
                return []
            }
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func readItem<T: Codable & Identifiable>(at path: URL, with identifier: any Hashable) throws -> T? {
        do {
            guard let data = fileManager.contents(atPath: path.path()) else{
                return nil
            }
            let elements: [T] = try JSONDecoder().decode([T].self, from: data)
            let element = elements.filter { element in element.id == identifier as? T.ID }.first
            return element
        }
    }
    
    func removeItem(at path: URL) throws {
        try fileManager.removeItem(at: path)
    }
}

extension URL {
    static let tasksPath: URL = {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tasks1")!
        return container.appendingPathComponent("task")
    }()
}
