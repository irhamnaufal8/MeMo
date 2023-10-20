//
//  NoteLocalDataSource.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import Foundation

protocol NoteLocalDataSource {
    func getAllNotes() async throws -> [NoteFileResponse]
    func getNoteById(_ id: UUID) async throws -> NoteFileResponse?
    func deleteNote(_ id: UUID) async throws -> ()
    func create(note: NoteFileResponse) async throws -> ()
    func update(note: NoteFileResponse) async throws -> ()
}
