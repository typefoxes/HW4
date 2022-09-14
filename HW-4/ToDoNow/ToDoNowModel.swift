import Foundation
import ReactiveKit
import Bond
import RealmSwift

protocol ToDoNowModelImput: AnyObject {
    var tasks: MutableObservableArray<TaskModel> { get set }
    var output: ToDoNowModelOutput! { get set }
    
    func deleteTask(key: String)
    func completeTask(key: String)
    func restoreTask(key: String)
}

protocol ToDoNowModelOutput: AnyObject {
    func updateTable()
}

class ToDoNowModel: ToDoNowModelImput {
    
    weak var output: ToDoNowModelOutput!
    static let shared = ToDoNowModel()
    private let realm = try! Realm()
    
    var tasks = MutableObservableArray(Array(try! Realm().objects(TaskModel.self)
                            .filter(NSPredicate(format: "isCompleted == false")))
                            .sorted { $1.created > $0.created })
                                                
    func deleteTask(key: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: key) {
            try! realm.write { realm.delete(object) }
    }
        output.updateTable() }
    
    func completeTask(key: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: key) {
            try! realm.write { object.isCompleted = true }
        }
        output.updateTable() }
    
    func restoreTask(key: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: key) {
            try! realm.write { object.isCompleted = false }
        }
        output.updateTable() }
}
