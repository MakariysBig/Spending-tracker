import UIKit

extension TransactionInfoViewController {
    final class Views {
        
        //MARK: - Properties
        
        let saveButton = UIButton()
        let datePicker = UIDatePicker()
        let dateTextField = UITextField()
        let amountTextField = UITextField()
        let noteTextField = UITextField()
        
        //MARK: - Private properties
        
        private let contentView = UIView()
        private let coverView = UIView()
        private let dateLabel = UILabel()
        private let amountLabel = UILabel()
        private let noteLabel = UILabel()
        
        //MARK: - Methods
        
        func loadViews(_ view: UIView) {
            setUpContentViewLayout(view)
            setUpCoverViewLayout()
            setUpAmountTextFieldLayout()
            setUpAmountLabelLayout()
            setUpNoteTextFieldLayout()
            setUpNotetLabelLayout()
            seUpTextDatePickerLayout()
            setUpDatePickerLayout()
            setUpDateLabelLAyout()
            saveButtonLayout()
        }
        
        //MARK: - Private Methods
        
        private func saveButtonLayout() {
            contentView.addSubview(saveButton)
            saveButton.setTitle("Save transaction", for: .normal)
            saveButton.setTitleColor(.white, for: .normal)
            saveButton.backgroundColor = .orange
            saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
            saveButton.layer.cornerRadius = 10
            
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
                saveButton.heightAnchor.constraint(equalToConstant: 50),
                saveButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
                saveButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            ])
        }
        
        private func setUpDateLabelLAyout() {
            coverView.addSubview(dateLabel)
            
            dateLabel.text = "Date: "
            dateLabel.textColor = .black
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: dateTextField.leadingAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: dateTextField.trailingAnchor),
                dateLabel.bottomAnchor.constraint(equalTo: dateTextField.topAnchor),
            ])
        }
        
        private func seUpTextDatePickerLayout() {
            coverView.addSubview(dateTextField)
            
            dateTextField.placeholder = "Pick your date"
            dateTextField.font = UIFont.systemFont(ofSize: 20)
            dateTextField.borderStyle = .roundedRect
            dateTextField.tintColor = .black
            dateTextField.layer.borderWidth = 2
            dateTextField.layer.cornerRadius = 10
            
            dateTextField.translatesAutoresizingMaskIntoConstraints = false
            dateTextField.inputView = datePicker
            
            NSLayoutConstraint.activate([
                dateTextField.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
                dateTextField.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
                dateTextField.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 40),
                dateTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func setUpDatePickerLayout() {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            let loc = Locale(identifier: "en")
            datePicker.locale = loc
        }
        
        private func setUpNoteTextFieldLayout() {
            coverView.addSubview(noteTextField)
            
            noteTextField.placeholder = "Enter note"
            noteTextField.text = "0"
            noteTextField.borderStyle = .roundedRect
            noteTextField.layer.borderWidth = 2
            noteTextField.layer.cornerRadius = 10
            
            noteTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                noteTextField.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
                noteTextField.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
                noteTextField.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 40),
                noteTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func setUpNotetLabelLayout() {
            coverView.addSubview(noteLabel)
            
            noteLabel.text = "Note: "
            noteLabel.textColor = .black
            
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                noteLabel.leadingAnchor.constraint(equalTo: noteTextField.leadingAnchor),
                noteLabel.trailingAnchor.constraint(equalTo: noteTextField.trailingAnchor),
                noteLabel.bottomAnchor.constraint(equalTo: noteTextField.topAnchor),
            ])
        }
        
        private func setUpAmountLabelLayout() {
            coverView.addSubview(amountLabel)
            
            amountLabel.text = "Amount: "
            amountLabel.textColor = .black
            
            amountLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                amountLabel.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
                amountLabel.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
                amountLabel.bottomAnchor.constraint(equalTo: amountTextField.topAnchor),
            ])
        }
        
        private func setUpAmountTextFieldLayout() {
            coverView.addSubview(amountTextField)
            
            amountTextField.placeholder = "Enter your amount"
            amountTextField.text = "0"
            amountTextField.borderStyle = .roundedRect
            amountTextField.layer.borderWidth = 2
            amountTextField.layer.cornerRadius = 10
            amountTextField.keyboardType = .decimalPad
            
            amountTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                amountTextField.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
                amountTextField.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
                amountTextField.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 30),
                amountTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func setUpCoverViewLayout() {
            contentView.addSubview(coverView)
            
            coverView.backgroundColor = .white
            
            coverView.translatesAutoresizingMaskIntoConstraints = false
            coverView.layer.cornerRadius = 20
            
            NSLayoutConstraint.activate([
                coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                coverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                coverView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        }
        
        private func setUpContentViewLayout(_ view: UIView) {
            view.addSubview(contentView)
            contentView.backgroundColor = .white
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}
