import UIKit
import ReactiveKit
import Bond
import RealmSwift

class CreateTaskViewController: UIViewController {

    private let realm = try? Realm()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descrTextField: UITextField!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descrTextField.delegate = self
        
        addButton.reactive.tap.observeNext { [self] in
            guard titleTextField.text != "" && descrTextField.text != "" else { return }
            
            let task = TaskModel()
            task.title = titleTextField.text ?? "Пусто"
            task.descr = descrTextField.text ?? "Пусто"
            task.deadline = deadlineDatePicker.date
            
            try? realm?.write { [self] in
                self.realm?.add(task, update: .modified)
            }
            let alert = UIAlertController(title: "👍🏻", message: "Создано", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
                        
                    
        }
        .dispose(in: reactive.bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension CreateTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

