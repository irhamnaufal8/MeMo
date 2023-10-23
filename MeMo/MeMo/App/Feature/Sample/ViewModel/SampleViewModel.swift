//
//  SampleViewModel.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import SwiftUI

final class SampleViewModel: ObservableObject {
    
    private let noteRepository: NoteRepository
    
    @Published var notes: [NoteFileResponse] = []
    
    @Published var title = ""
    @Published var isSuccess = false
    @Published var isShowError = false
    @Published var errorText = ""
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func createNote() {
        let note = NoteFileResponse(
            title: self.title,
            tags: [.init(text: "")],
            notes: [.init(text: "")],
            theme: "PURPLE",
            createdAt: .now,
            modifiedAt: .now
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
