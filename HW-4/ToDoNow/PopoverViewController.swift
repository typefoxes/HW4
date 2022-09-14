import UIKit
import ReactiveKit
import Bond

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
 
    
    var delegate: ViewController?
    var task: TaskModel?
    let viewModel = ToDoNowModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeTapped()
        deleteTapped()
    }
    
    func deleteTapped() {
        removeButton.reactive.tap.observeNext { [self] in
            viewModel.deleteTask(key: task?.key ?? "")
            self.delegate?.viewWillAppear(true)
            self.dismiss(animated: true, completion: nil)
        }
        .dispose(in: reactive.bag)
    }
    
    func completeTapped() {
        doneButton.reactive.tap.observeNext { [self] in
            viewModel.completeTask(key: task?.key ?? "")
            self.delegate?.viewWillAppear(true)
            self.dismiss(animated: true, completion: nil)
        }
        .dispose(in: reactive.bag)
    }
}
