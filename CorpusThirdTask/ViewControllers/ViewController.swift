//
//  ViewController.swift
//  CorpusThirdTask
//
//  Created by Vlad Ralovich on 23.07.22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel = UILabel(frame: .zero)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .black
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return titleLabel
    }()
    
    lazy var textView: UITextView = {
        var textView = UITextView(frame: .zero)
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            textView.heightAnchor.constraint(equalToConstant: view.frame.height / 4)
        ])
        textView.isEditable = true
        textView.delegate = self
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.keyboardDismissMode = .onDrag
        textView.font = .systemFont(ofSize: 20)
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["option1", "option2", "option3"])
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
        ])
        return segmentedControl
    }()
    
    lazy var modePickerView: UIPickerView = {
        var modePickerView = UIPickerView()
        view.addSubview(modePickerView)
        modePickerView.translatesAutoresizingMaskIntoConstraints = false
        modePickerView.delegate = self
        modePickerView.dataSource = self
        modePickerView.layer.cornerRadius = 5
        modePickerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            modePickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 4),
            modePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            modePickerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            modePickerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        return modePickerView
    }()
    
    lazy var sendButton: UIButton = {
        var sendButton = UIButton()
        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: checkboxStackView.bottomAnchor, constant: 8),
            sendButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
        ])
        sendButton.setTitle("Паказаць уведзены тэкст \nі абраныя наладкі!", for: .normal)
        sendButton.titleLabel?.numberOfLines = 0
        sendButton.titleLabel?.textAlignment = .center
        sendButton.backgroundColor = .darkGray
        sendButton.layer.cornerRadius = 5
        return sendButton
    }()
    
    lazy var checkboxStackView: UIStackView = {
        var checkboxStackView = UIStackView()
        view.addSubview(checkboxStackView)
        checkboxStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkboxStackView.topAnchor.constraint(equalTo: modePickerView.bottomAnchor, constant: 4),
            checkboxStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            checkboxStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
        ])
        checkboxStackView.axis = .horizontal
        checkboxStackView.distribution = .fillEqually
        checkboxStackView.spacing = 4
        checkboxStackView.addArrangedSubview(checkbox1Button)
        checkboxStackView.addArrangedSubview(checkbox2Button)
        checkboxStackView.addArrangedSubview(checkbox3Button)
        return checkboxStackView
    }()
    
    lazy var checkbox1Button: UIButton = {
        var checkbox1Button = UIButton()
        checkbox1Button.setTitle("checkbox1", for: .normal)
        checkbox1Button.backgroundColor = .lightGray
        checkbox1Button.setTitleColor(.black, for: .normal)
        checkbox1Button.layer.cornerRadius = 5
        return checkbox1Button
    }()
    lazy var checkbox2Button: UIButton = {
        var checkbox2Button = UIButton()
        checkbox2Button.setTitle("checkbox2", for: .normal)
        checkbox2Button.backgroundColor = .lightGray
        checkbox2Button.setTitleColor(.black, for: .normal)
        checkbox2Button.layer.cornerRadius = 5
        return checkbox2Button
    }()
    lazy var checkbox3Button: UIButton = {
        var checkbox3Button = UIButton()
        checkbox3Button.setTitle("checkbox3", for: .normal)
        checkbox3Button.backgroundColor = .lightGray
        checkbox3Button.setTitleColor(.black, for: .normal)
        checkbox3Button.layer.cornerRadius = 5
        return checkbox3Button
    }()
    
    lazy var aboutLabel: UILabel = {
        var aboutLabel: UILabel = UILabel(frame: .zero)
        view.addSubview(aboutLabel)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.textColor = .darkGray
        aboutLabel.textAlignment = .center
        aboutLabel.adjustsFontSizeToFitWidth = true
        aboutLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(greaterThanOrEqualTo: sendButton.bottomAnchor, constant: 100),
            aboutLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            aboutLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            aboutLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        return aboutLabel
    }()
    
    var modeArray = ["radiobutton1", "radiobutton2", "radiobutton3"]
    var lastText = ""
    
    var result: ResponceModel? {
        didSet {
            sendButton.isEnabled = false
            titleLabel.text = "Вынік"
            textView.backgroundColor = .yellow
            textView.text = ""
            textView.text = result!.result
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Калі ласка, увядзіце тэкст"
        textView.text = ""
        segmentedControl.selectedSegmentIndex = 0
        modePickerView.backgroundColor = .white
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        checkbox1Button.addTarget(self, action: #selector(checkboxAction1), for: .touchUpInside)
        checkbox2Button.addTarget(self, action: #selector(checkboxAction2), for: .touchUpInside)
        checkbox3Button.addTarget(self, action: #selector(checkboxAction3), for: .touchUpInside)
        aboutLabel.text = "Мы будзем рады атрымаць зваротную сувязь ад Вас на e-mail corpus.by@gmail.com.\nНашы іншыя прататыпы: corpus.by, ssrlab.by. \nЛабараторыя распазнавання і сінтэзу маўлення, АІПІ НАН Беларусі, 2016—2022"
        view.backgroundColor = .lightGray
    }
    @objc func send() {
        guard let selector = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        guard let text = textView.text else { return }
        let mode = modeArray[modePickerView.selectedRow(inComponent: 0)]
        let checkbox1 = checkbox1Button.backgroundColor == .lightGray ? 0 : 1
        let checkbox2 = checkbox2Button.backgroundColor == .lightGray ? 0 : 1
        let checkbox3 = checkbox3Button.backgroundColor == .lightGray ? 0 : 1
        if !text.isEmpty {
            lastText = text
            postText(text: text, checkbox1: checkbox1, checkbox2: checkbox2, checkbox3: checkbox3, mode: mode, selector: selector)
        textView.resignFirstResponder()
        } else {
        
        }
    }
    
    @objc func checkboxAction1() {
        if checkbox1Button.backgroundColor == .lightGray {
            checkbox1Button.backgroundColor = .white
        } else {
            checkbox1Button.backgroundColor = .lightGray
        }
    }
    @objc func checkboxAction2() {
        if checkbox2Button.backgroundColor == .lightGray {
            checkbox2Button.backgroundColor = .white
        } else {
            checkbox2Button.backgroundColor = .lightGray
        }
    }
    @objc func checkboxAction3() {
        if checkbox3Button.backgroundColor == .lightGray {
            checkbox3Button.backgroundColor = .white
        } else {
            checkbox3Button.backgroundColor = .lightGray
        }
    }
    
    private func postText(text: String, checkbox1: Int = 0 , checkbox2: Int = 0, checkbox3: Int = 0, mode: String, selector: String) {
        let param = ["text": text, "checkbox1": checkbox1,
                     "checkbox2": checkbox2, "checkbox3": checkbox3,
                     "mode": mode, "selector": selector,
                     "localization": "be"] as [String : Any]

        AF.request("https://corpus.by/ServiceDemonstrator/api.php", method: .post, parameters: param).responseDecodable(of: ResponceModel.self) { response in
            guard let data = response.value else {
                print("Error")
                return
            }
            self.result = data
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        sendButton.isEnabled = true
        titleLabel.text = "Калі ласка, увядзіце тэкст"
        textView.text = lastText
        textView.backgroundColor = .white
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        modeArray.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = modeArray[row]
        
        return label
    }
}
