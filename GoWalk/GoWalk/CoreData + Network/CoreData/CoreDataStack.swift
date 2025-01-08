//
//  CoreDataStack.swift
//  GoWalk
//
//  Created by 박진홍 on 1/8/25.
//

import CoreData

// Core Location은 필요한 위, 경도 정보 외에 불필요한 정보 제공이 될 가능성, 많은 import가 필요하여 별개의 구조체 선언했습니다.
struct LocationPoint {
    let latitude: Double
    let longitude: Double
}

// 싱글톤 패턴으로 사용
// 사용자가 원하는 지역에 대한 위도와 경도를 저장하고 삭제하기 위한 코어데이터 스택
final class CoreDataStack {
    // 싱글톤 패턴
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Location")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("failed to load persistent container")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - 지역 추가, 삭제
    func addLocation(at newLocation: LocationPoint) {
        let location: Location = Location(context: context)
        location.latitude = newLocation.latitude
        location.longitude = newLocation.longitude
        saveContext()
    }

    func deleteLocation(of location: Location) {
        context.delete(location)
        saveContext()
    }

    // MARK: - 컨텍스트 저장 메서드

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("failed to save context")
        }
    }
}
