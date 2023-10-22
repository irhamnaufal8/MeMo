//
//  SampleViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import SwiftUI

@Observable
final class SampleViewModel {
    
    private let noteRepository: NoteRepository
    
    var notes: [NoteFileResponse] = []
    
    var title = ""
    var isSuccess = false
    var isShowError = false
    var errorText = ""
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func createNote() {
        let note = NoteFileResponse(
            title: self.title,
            notes: [.init(text: "Dummy notes is here")],
            theme: "PURPLE"
        )
        
        let result = noteRepository.saveNote(note)
        
        switch result {
        case .success(let success):
            DispatchQueue.main.async { [weak self] in
                self?.isSuccess = success
            }
        case .failure(let failure):
            DispatchQueue.main.async { [weak self] in
                self?.isShowError = true
                self?.errorText = failure.localizedDescription
            }
        }
    }
    
    func getAllNote() {
        let result = noteRepository.getAllNotes()
        
        switch result {
        case .success(let success):
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.notes = success
                }
            }
        case .failure(let failure):
            DispatchQueue.main.async { [weak self] in
                self?.isShowError = true
                self?.errorText = failure.localizedDescription
            }
        }
    }
}
