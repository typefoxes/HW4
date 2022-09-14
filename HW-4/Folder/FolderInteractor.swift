import Foundation
import RealmSwift

protocol FolderInteractorInput {
    var output: FolderInteractorOutput! { get set }
    func requestData() -> [TaskModel]
}

protocol FolderInteractorOutput {
}

class FolderInteractor: FolderInteractorInput {
    
    var output: FolderInteractorOutput!
    
    let realm = try! Realm()
    
    func requestData() -> [TaskModel] {
        return realm.objects(TaskModel.self)
            .filter(NSPredicate(format: "isCompleted == true"))
            .sorted { $1.created > $0.created }
    }
}


