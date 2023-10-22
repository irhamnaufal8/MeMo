//
//  DefaultNoteRepository.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation

final class DefaultNoteRepository: NoteRepository {
    
    private let localDataSource: NoteLocalDataSource
    
    init(localDataSource: NoteLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func getAllNotes() -> Result<[NoteFileResponse], Error> {
        do {
            let response = try localDataSource.getAllNote()
            return .success(response)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func saveNote(_ note: NoteFileResponse) -> Result<Bool, Error> {
        do {
            try localDataSource.saveNote(note)
            return .success(true)
        } catch(let error) {
            return .failure(error)
        }
    }
}

final class MockNoteRepository: NoteRepository {
    private let localDataSource: NoteLocalDataSource
    
    init(localDataSource: NoteLocalDataSource = MockNoteLocalDataSource()) {
        self.localDataSource = localDataSource
    }
    
    func getAllNotes() -> Result<[NoteFileResponse], Error> {
        do {
            let response = try localDataSource.getAllNote()
            return .success(response)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func saveNote(_ note: NoteFileResponse) -> Result<Bool, Error> {
        do {
            try localDataSource.saveNote(note)
            return .success(true)
        } catch(let error) {
            return .failure(error)
        }
    }
}
