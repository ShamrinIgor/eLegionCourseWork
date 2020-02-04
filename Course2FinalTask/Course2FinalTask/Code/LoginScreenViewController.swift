import UIKit

public var token = String()

class LoginScreenViewController: UIViewController, UITextFieldDelegate
{
    var loginTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    var signInButton: UIButton = UIButton(type: .system)
    
    var loginTextFieldIsEmpty = true
    var passwordTextFieldIsEmpty = true
    
//    var token = String()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "LoginScreenViewController"
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        viewConfiger()
        view.setNeedsUpdateConstraints()
        
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        signInButton.isEnabled = false
        signInButton.alpha = 0.3
        
    }
    
    func viewConfiger() {
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.placeholder = "Login"
        loginTextField.textColor = .black
        loginTextField.borderStyle = .roundedRect
        loginTextField.autocapitalizationType = .none
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = passwordTextField.font?.withSize(14.0)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.backgroundColor = .systemBlue
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        loginTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30.0).isActive = true
        loginTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0).isActive = true
        loginTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 8.0).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor, constant: 0.0).isActive = true

        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 100.0).isActive = true
        signInButton.leftAnchor.constraint(equalTo: loginTextField.leftAnchor).isActive = true
        signInButton.rightAnchor.constraint(equalTo: loginTextField.rightAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let loginText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if (loginText.isEmpty) {
            signInButton.isEnabled = false
            signInButton.alpha = 0.3
            if textField.placeholder == "Login" {
                loginTextFieldIsEmpty = true
            }
            else {
                passwordTextFieldIsEmpty = true
            }
        }
        else {

            if textField.placeholder == "Login" {
                loginTextFieldIsEmpty = false
            }
            else {
                passwordTextFieldIsEmpty = false
            }
        }
        if (!loginTextFieldIsEmpty && !passwordTextFieldIsEmpty) {
            signInButton.isEnabled = true
            signInButton.alpha = 1.0
        }
        return true
    }
    
    @objc func signInButtonPressed(sender: UIButton!) {
        if let login = loginTextField.text, let password = passwordTextField.text {
            if !login.isEmpty && !password.isEmpty {
                let group = DispatchGroup()
                group.enter()
                
                logIn(login: login, password: password) {
                    result in
                    switch result {
                    case .success(let tokenFromJson):
                        if tokenFromJson == "Error" {
                            print(token)
                            DispatchQueue.main.async {
                                Alert.showBasic(title: "Error!", message:  "Login or password error!", vc: self)
                            }
                        }
                        else {
                            token = tokenFromJson
                            print("new token: ", token)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "toNavigationBar", sender: nil)
                            }
                        }
                    case .fail(let error):
                        print(error)
                    case .badResponse(let res):
                        print(res)
                    }
                    group.leave()
                }
                group.wait()
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let destination = segue.destination as? UITabBarController {
//            if let navVC = destination.viewControllers![0] as? UINavigationController {
//                if let feedVC = navVC.viewControllers[0] as? FeedTableViewController {
//
//                    feedVC.token = token
//                    let group = DispatchGroup()
//                    group.enter()
//                    if !token.isEmpty {
//                        getPostsForFeed(token: token) {
//                            result in
//                            switch result {
//                                case .success(let arrayOfPosts):
//                                    DispatchQueue.main.async {
//                                        feedVC.posts = arrayOfPosts
//                                    }
//                                case .fail(let error):
//                                    print(error)
//                            }
//                            group.leave()
//                        }
//                        group.wait()
//                    }
//                }
//            }
//        }
//    }
    
}
