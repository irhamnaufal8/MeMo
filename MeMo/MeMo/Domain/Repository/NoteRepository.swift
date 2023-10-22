//
//  NoteRepository.swift
//  MeMo
//
//  Created by Irham Naufal on 22/10/23.
//

import Foundation

protocol NoteRepository {
    func getAllNotes() -> Result<[NoteFileResponse], Error>
    func saveNote(_ note: NoteFileResponse) -> Result<Bool, Error>
}
