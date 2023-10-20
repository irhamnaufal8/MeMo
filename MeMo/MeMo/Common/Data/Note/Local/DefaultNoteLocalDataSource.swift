//
//  DefaultNoteLocalDataSource.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import SwiftUI
import CoreData

final class DefaultNoteLocalDataSource: NoteLocalDataSource {
    
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func getAllNotes() async throws -> [NoteFileResponse] {
        let request = NoteFile.fetchRequest()
        return try container.viewContext.fetch(request).compactMap { note in
            return .init(
                id: note.id ?? .init(),
                title: note.title.orEmpty(),
                tags: (note.tags?.allObjects as? [String] ?? []),
                notes: (note.notes?.allObjects as? [NoteResponse] ?? []),
                theme: note.theme.orEmpty(),
                createdAt: note.createdAt.orCurrentDate(),
                modifiedAt: note.modifiedAt.orCurrentDate()
            )
        }
    }
    
    func getNoteById(_ id: UUID) async throws -> NoteFileResponse? {
        guard let note = try getEntityById(id) else { return .init(title: "", notes: [], theme: "") }
        return NoteFileResponse(
            id: note.id ?? .init(),
            title: note.title.orEmpty(),
            tags: (note.tags?.allObjects as? [String] ?? []),
            notes: note.notes?.allObjects as? [NoteResponse] ?? [],
            theme: note.theme.orEmpty(),
            createdAt: note.createdAt.orCurrentDate(),
            modifiedAt: note.modifiedAt.orCurrentDate()
        )
    }
    
    func deleteNote(_ id: UUID) async throws {
        guard let data = try getEntityById(id) else { return }
        let context = container.viewContext
        context.delete(data)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func create(note: NoteFileResponse) async throws {
        let data = NoteFile(context: container.viewContext)
        data.id = note.id
        data.title = note.title
//        data.tags = NSSet(array: note.tags ?? [])
        data.theme = note.theme
        data.createdAt = note.createdAt
        data.modifiedAt = note.modifiedAt
        updateNoteContent(note.notes)
        
        saveContext()
    }
    
    func update(note: NoteFileResponse) async throws {
        guard let data = try getEntityById(note.id) else { return }
        data.title = note.title
//        data.tags = NSSet(array: note.tags ?? [])
        data.theme = note.theme
        data.createdAt = note.createdAt
        data.modifiedAt = note.modifiedAt
        updateNoteContent(note.notes)
        
        saveContext()
    }
    
    private func getEntityById(_ id: UUID) throws -> NoteFile? {
        let request = NoteFile.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let context = container.viewContext
        let result = try context.fetch(request).first
        return result
        
    }
    
    private func saveContext(){
        let context = container.viewContext
        if context.hasChanges {
            do{
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateNoteContent(_ note: [NoteResponse]) {
        for content in note {
            let newNotes = NSEntityDescription.insertNewObject(forEntityName: "Note", into: container.viewContext)
            
            newNotes.setValue(content.id, forKey: "id")
            newNotes.setValue(content.text, forKey: "text")
            newNotes.setValue(content.isChecked, forKey: "isChecked")
            newNotes.setValue(content.image, forKey: "image")
            newNotes.setValue(content.type, forKey: "type")
        }
    }
}
