import UIKit

class ViewController: UIViewController, ToDoNowModelOutput {
    

    @IBOutlet weak var toDoNowTable: UITableView!
    
    private var toDoNowModel: ToDoNowModelImput! = ToDoNowModel.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        toDoNowModel.output = self
        updateTable()
        rowSelected()
    }
    
    func updateTable() {
        toDoNowModel = ToDoNowModel()
        toDoNowModel.tasks.bind(to: toDoNowTable) { (dataSource, indexPath, tableView) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoNowCell") as! TableViewCell
            
            cell.titleLabel.textColor = .red
            cell.descriptionLabel.textColor = .systemGray
            cell.layer.borderWidth = 0.1
            cell.layer.cornerRadius = 8
        
            cell.titleLabel.text = dataSource[indexPath.row].title
            cell.descriptionLabel.text = dataSource[indexPath.row].descr
            cell.deadlineLabel.text = "До: " +  dataSource[indexPath.row].deadline.formattedDate()
            cell.createdLabel.text = "От: " + dataSource[indexPath.row].created.formattedDate()
            return cell
        }
    }
    
    func rowSelected() {
        toDoNowTable.reactive.selectedRowIndexPath.observeNext { indexPath in
            let cell = self.toDoNowTable.cellForRow(at: indexPath)
            guard let popover = (self.storyboard?.instantiateViewController(withIdentifier: "Popover") as? PopoverViewController) else { return }
            popover.modalPresentationStyle = .popover
            popover.delegate = self
            popover.preferredContentSize = CGSize(width: 100, height: 120)
            weak var popoverVC = popover.popoverPresentationController
            popoverVC?.delegate = self
            popoverVC?.sourceView = cell
            popoverVC?.sourceRect = CGRect(x: cell?.bounds.midX ?? 50, y: 90, width: 0, height: 0)
            popover.task = self.toDoNowModel.tasks[indexPath.row]
            self.present(popover, animated: true)
        }
        .dispose(in: reactive.bag)
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
