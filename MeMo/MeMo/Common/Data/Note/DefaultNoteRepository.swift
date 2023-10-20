//
//  DefaultNoteRepository.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import Foundation

final class DefaultNoteRepository: NoteRepository {
    
    private let localDataSource: NoteLocalDataSource
    
    init(localDataSource: NoteLocalDataSource = DefaultNoteLocalDataSource()) {
        self.localDataSource = localDataSource
    }
    
    func getAllNotes() async -> Result<[NoteFileResponse], Error> {
        do {
            let response = try await localDataSource.getAllNotes()
            return .success(response)
        } catch (let error) {
            return .failure(error)
        }
    }
    
    func getNoteById(_ id: UUID) async -> Result<NoteFileResponse?, Error> {
        do {
            let response = try await localDataSource.getNoteById(id)
            return .success(response)
        } catch (let error) {
            return .failure(error)
        }
    }
    
    func deleteNote(_ id: UUID) async -> Result<Bool, Error> {
        do {
            try await localDataSource.deleteNote(id)
            return .success(true)
        } catch (let error) {
            return .failure(error)
        }
    }
    
    func create(note: NoteFileResponse) async -> Result<Bool, Error> {
        do {
            try await localDataSource.create(note: note)
            return .success(true)
        } catch (let error) {
            return .failure(error)
        }
    }
    
    func update(note: NoteFileResponse) async -> Result<Bool, Error> {
        do {
            try await localDataSource.update(note: note)
            return .success(true)
        } catch (let error) {
            return .failure(error)
        }
    }
}
