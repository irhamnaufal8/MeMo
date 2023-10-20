//
//  NoteRepository.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import Foundation

protocol NoteRepository {
    func getAllNotes() async -> Result<[NoteFileResponse], Error>
    func getNoteById(_ id: UUID) async -> Result<NoteFileResponse?, Error>
    func deleteNote(_ id: UUID) async -> Result<Bool, Error>
    func create(note: NoteFileResponse) async -> Result<Bool, Error>
    func update(note: NoteFileResponse) async -> Result<Bool, Error>
}
