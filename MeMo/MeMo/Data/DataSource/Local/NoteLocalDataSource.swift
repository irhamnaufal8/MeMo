//
//  NoteLocalDataSource.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation
import SwiftData

protocol NoteLocalDataSource {
    func getAllNote() throws -> [NoteFileResponse]
    func saveNote(_ note: NoteFileResponse) throws
}

final class DefaultNoteLocalDataSource: NoteLocalDataSource {
    
    private var provider: ModelContext
    
    init(provider: ModelContext) {
        self.provider = provider
    }
    
    func getAllNote() throws -> [NoteFileResponse] {
        let response = try provider.fetch(FetchDescriptor<NoteFile>())
        return response.compactMap { data in
            return NoteFileResponse(
                id: data.id,
                title: data.title,
                tags: data.tags,
                notes: data.notes,
                theme: data.theme,
                createdAt: data.createdAt,
                modifiedAt: data.modifiedAt,
                folder: data.folder
            )
        }
    }
    
    func saveNote(_ note: NoteFileResponse) throws {
        provider.insert(
            NoteFile(
                id: note.id,
                title: note.title,
                tags: note.tags,
                notes: note.notes,
                theme: note.theme,
                createdAt: note.createdAt,
                modifiedAt: note.modifiedAt,
                folder: note.folder
            )
        )
        try provider.save()
    }
}

final class MockNoteLocalDataSource: NoteLocalDataSource {
    func getAllNote() throws -> [NoteFileResponse] {
        let response: [NoteFileResponse] = [
            .init(notes: [.init(text: "Mock Text")]),
            .init(notes: [.init(text: "Mock Text 2")]),
            .init(notes: [.init(text: "Mock Text 3")])
        ]
        return response
    }
    
    func saveNote(_ note: NoteFileResponse) throws {}
}
