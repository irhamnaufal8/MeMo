//
//  DummyAssembler.swift
//  MeMo
//
//  Created by Irham Naufal on 23/10/23.
//

import Foundation
import SwiftData

protocol DummyAssembler {
    func resolve() -> SampleViewModel
    
    func resolve() -> NoteRepository
    func resolve() -> NoteLocalDataSource
    
    func resolve() -> ModelContainer?
    func resolve() -> ModelContext
}

extension DummyAssembler where Self: Assembler {
    func resolve() -> SampleViewModel {
        return  SampleViewModel(noteRepository: resolve())
    }
    
    func resolve() -> NoteRepository {
        return DefaultNoteRepository(localDataSource: resolve())
    }
    
    func resolve() -> NoteLocalDataSource {
        return DefaultNoteLocalDataSource(provider: resolve())
    }
    
    @MainActor
    func resolve() -> ModelContext {
        return resolve()!.mainContext
    }
    
    func resolve() -> ModelContainer? {
        do {
            let modelContainer = try ModelContainer(for: NoteFile.self, NoteContent.self, Tag.self, Folder.self)
            return modelContainer
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        return .none
    }
}
