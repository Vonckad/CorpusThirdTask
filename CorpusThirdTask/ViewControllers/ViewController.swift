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
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            textView.heightAnchor.constraint(equalToConstant: view.frame.height / 4)
        ])
        textView.isEditable = true
        textView.backgroundColor = .white
        textView.keyboardDismissMode = .onDrag
        textView.font = .systemFont(ofSize: 20)
        textView.layer.cornerRadius = 20
        return textView
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["option1", "option2", "option3"])
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 24),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24)
        ])
        return segmentedControl
    }()
    
    lazy var sendButton: UIButton = {
        var sendButton = UIButton()
        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24),
            sendButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
        ])
        sendButton.setTitle(" Паказаць уведзены тэкст \nі абраныя наладкі! ", for: .normal)
        sendButton.titleLabel?.numberOfLines = 0
        sendButton.titleLabel?.textAlignment = .center
        sendButton.backgroundColor = .darkGray
        sendButton.layer.cornerRadius = 5
        return sendButton
    }()
    
    var result: ResponceModel? {
        didSet {
            print(result)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Калі ласка, увядзіце тэкст"
        textView.text = ""
        segmentedControl.selectedSegmentIndex = 0
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        view.backgroundColor = .lightGray
    }
    @objc func send() {
        guard let selector = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        print("sel = \(selector)")
        guard let text = textView.text else { return }
        if !text.isEmpty {
            postText(text: text, checkbox1: 0, checkbox2: 0, checkbox3: 1, mode: "radiobutton2", selector: selector)
        textView.resignFirstResponder()
        } else {
            
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
