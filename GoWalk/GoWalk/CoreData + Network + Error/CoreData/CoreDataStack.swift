//
//  CoreDataStack.swift
//  GoWalk
//
//  Created by 박진홍 on 1/8/25.
//

import CoreData

// Core Location은 필요한 위, 경도 정보 외에 불필요한 정보 제공이 될 가능성, 많은 import가 필요하여 별개의 구조체 선언했습니다.
// 2차적으로 이러한 DTO를 만드는 것이 NSManagedObject를 받아서 테이블 뷰에 사용하는 것보다 성능적으로 낫다고 합니다.(lazy-loading)
// 그 외에도 context가 변경될 수 있다는 안정성 관련 문제 등도 있다고 합니다..
struct LocationPoint {
    let regionName: String
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
                print(AppError.data(.failedToMakePersistentContainer).localizedDescription)
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
        location.regionName = newLocation.regionName
        location.latitude = newLocation.latitude
        location.longitude = newLocation.longitude
        saveContext()
    }

    func fetchLocationPointList() -> [LocationPoint] {
        let fetchRequst: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            let locations: [Location] = try context.fetch(fetchRequst)
            return locations.map { location in
                LocationPoint(
                    regionName: location.regionName ?? "알 수 없는 지역",
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            }
        } catch {
            print(AppError.data(.failedToFetch(error: error)).localizedDescription)
            return []
        }
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
            print(AppError.data(.failedToSaveContext(error: error)))
        }
    }
}
