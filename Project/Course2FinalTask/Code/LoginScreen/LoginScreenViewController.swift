import UIKit

public var token = String()
public var isOfflineMode = false
var dataManager = CoreDataManager(modelName: "PostsDataModel")

class LoginScreenViewController: UIViewController, UITextFieldDelegate
{
    var loginTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    var signInButton: UIButton = UIButton(type: .system)
    
    var loginTextFieldIsEmpty = true
    var passwordTextFieldIsEmpty = true
    
    var dataManager: CoreDataManager!
    
    var service = "eLegionCourseProject"
            
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
        
        keychainAuthorization()
    }
    
    private func keychainAuthorization() {
        let passwordItems = readAllItems(service: service)
        if let passItems = passwordItems, !passItems.isEmpty {
            let keys = Array<String>(passItems.keys)
            authenticateUser(account: keys[0], password: passItems[keys[0]]!)
        }
    }
    
    private func viewConfiger() {
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
        signInButton.layer.cornerRadius = 10.0
        signInButton.isEnabled = false
        signInButton.alpha = 0.3
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "toNavigationBar") {
//            let vc = segue.destination as! FeedTableViewController
//            vc.dataManager = self.dataManager
//        }
//    }
    
    func logInIntoAccount(account: String?, password: String?) {
        if let login = account, let password = password {
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
                            
                            let result = self.savePassword(password: password, service: self.service, account: account)
                            
                            if result, let savedPassword = self.readPassword(service: self.service, account: account) {
                                print("password:\(savedPassword) saved successfully with service name:\(self.service) and account:\(account)")
                            } else {
                                print("can't save password")
                            }
                        }
                    case .fail(let error):
                        print(".fail case")
                        print(error)
                    case .badResponse(let res):
                        print(".badResponse case")
                        print(res)
                        isOfflineMode = true
                        DispatchQueue.main.async {
                            AlertForOfflineMode.showBasic(title: "Connection error", message: "The server is not responding", vc: self) {_ in
                                print("Offline button pressed")
                                self.performSegue(withIdentifier: "toNavigationBar", sender: nil)
                            }
                        }
                        
                    }
                    group.leave()
                }
                group.wait()
            }
        }
    }
    
//    func GoOfflineButtonPressed() {
//        let tabBarCotroller = UITabBarController()
//
//        let feedVC = FeedViewControllerOffline()
//        let collectionVC = UIViewController()
//
//        collectionVC.title = "Collection view"
//
//
//        feedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//        collectionVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
//
//        let controllers = [feedVC, collectionVC]
//        tabBarCotroller.viewControllers = controllers
//        tabBarCotroller.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
//
//        present(tabBarCotroller, animated: true, completion: nil)
//    }
    
    @objc func signInButtonPressed(sender: UIButton!) {
        logInIntoAccount(account: loginTextField.text, password: passwordTextField.text)
    }
    
}
