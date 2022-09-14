import UIKit
import ReactiveKit
import Bond

class FolderViewController: UIViewController {

    @IBOutlet weak var folderTasksTableView: UITableView!
    
    
    var presenter: FolderPresenterInput! = FolderPresenter()
    var tasks: [TaskModel]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.output = self
        presenter.dataUpdated()
        
        folderTasksTableView.reactive.selectedRowIndexPath.observeNext { indexPath in
            self.presenter.rowSelected(indexPath: indexPath)
        }
        .dispose(in: reactive.bag)
    }
}

extension FolderViewController: FolderPresenterOutput {
    func setupPopover<T: FolderPopoverViewControllerProtocol>(pop: T, parent: UIViewController, identifier: String, storyboard: UIStoryboard?, tableView: UITableView, indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let popover = storyboard?.instantiateViewController(withIdentifier: identifier) as? T else { return }
        popover.modalPresentationStyle = .popover
        popover.delegate = parent as? FolderViewController
        popover.task = self.tasks?[indexPath.row]
        popover.preferredContentSize = CGSize(width: 150, height: 150)
        weak var popVC = popover.popoverPresentationController
        popVC?.delegate = parent as? UIPopoverPresentationControllerDelegate
        popVC?.sourceView = cell
        popVC?.sourceRect = CGRect(x: cell?.bounds.midX ?? 50, y: 90, width: 0, height: 0)
        parent.present(popover, animated: true)
    }
    
    func updateTable(tasks: [TaskModel]) {
        MutableObservableArray(tasks).bind(to: folderTasksTableView) { (dataSoutce, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTaskCell") as! TableViewCell
            cell.titleLabel.textColor = .gray
            cell.descriptionLabel.textColor = .gray
            
            cell.createdLabel.text = "От: " + dataSoutce[indexPath.row].created.formattedDate()
            cell.deadlineLabel.text = "До:" + dataSoutce[indexPath.row].deadline.formattedDate()
            
            cell.titleLabel.text = dataSoutce[indexPath.row].title
            cell.descriptionLabel.text = dataSoutce[indexPath.row].descr
            self.tasks = tasks
            return cell
        }
    }
}

extension FolderViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
