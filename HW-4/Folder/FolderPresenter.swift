import Foundation
import UIKit

protocol FolderPresenterInput {
    var output: FolderPresenterOutput! { get set }
    func dataUpdated()
    func rowSelected(indexPath: IndexPath)
}

protocol FolderPresenterOutput {
    func updateTable(tasks: [TaskModel])
    func setupPopover<T: FolderPopoverViewControllerProtocol>(pop: T, parent: UIViewController, identifier: String, storyboard: UIStoryboard?, tableView: UITableView, indexPath: IndexPath)
}

class FolderPresenter: FolderPresenterInput, FolderInteractorOutput {
    var output: FolderPresenterOutput!
    
    var interactor: FolderInteractorInput! = FolderInteractor()
    
    func dataUpdated() {
        interactor.output = self
        output.updateTable(tasks: interactor.requestData())
    }
    
    func rowSelected(indexPath: IndexPath) {
        let output = self.output as! FolderViewController
        
        output.setupPopover(pop: FolderPopoverViewController(), parent: output, identifier: "FolderPopover", storyboard: output.storyboard, tableView: output.folderTasksTableView, indexPath: indexPath)
    }
}


