//
//  CoreDataManager.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 1/9/24.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    private let container: NSPersistentContainer
    private let containerName: String = "RecordsContainer"
    private let recordsEntityName: String = "RecordsEntity"
    
    @Published var records: [RecordsEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading persistent stores: \(error)")
            }
            self.getRecords()
        }
    }
    
    private func getRecords() {
        let request = NSFetchRequest<RecordsEntity>(entityName: recordsEntityName)
        do {
            records = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching from RecordsEntity: \(error)")
        }
    }
    
    func addRecordToDB(record: Record) {
        let recordEntity = RecordsEntity(context: container.viewContext)
        recordEntity.recordId = record.id
        recordEntity.duration = Int64(record.duration)
        recordEntity.date = record.date
        
        for sound in record.sounds {
            let soundEntity = SoundEntity(context: container.viewContext)
            soundEntity.id = sound.id
            soundEntity.volume = Int64(sound.volume)
            soundEntity.onSecond = Int64(sound.onSecond)
            soundEntity.record = recordEntity
            recordEntity.addToSounds(soundEntity)
        }
        applyChanges()
    }
    
    func getRecordFromEntity(_ entity: RecordsEntity) -> Record? {
        guard let recordId = entity.recordId, let date = entity.date else { return nil }
        let duration = Int(entity.duration)
        
        var sounds: [Sound] = (entity.sounds?.allObjects as? [SoundEntity])?.map { soundEntity in
            Sound(id: soundEntity.id ?? UUID().uuidString,
                  volume: Int(soundEntity.volume),
                  onSecond: Int(soundEntity.onSecond))
        } ?? []
        sounds.sort(by: { $0.onSecond < $1.onSecond })
        
        return Record(id: recordId, sounds: sounds, duration: duration, date: date)
    }
    
    func remove(entity: RecordsEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    func removeAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: recordsEntityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            applyChanges()
        } catch {
            print("Error deleting all records: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getRecords()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }
}

