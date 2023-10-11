//
//  QuestionsViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 24/09/23.
//
//MARK: INFO
/*Se presenta las diferentes herramientas que se puede ocupar al momento hacer alguna pregunta al Chatbot*/

import UIKit

class QuestionsViewController: UIViewController {

    //MARK: definir Outlets del Storyboard
    @IBOutlet var playSomeConversationButton: UIButton!
    @IBOutlet var typicalQuestionsButton: UIButton!
    @IBOutlet var textHeightTypicalQuestionsConstraint: NSLayoutConstraint!
    @IBOutlet var startConversationButton: UIButton!
    @IBOutlet var chatView: UIView!
    
    
    var isTextViewHidden: Bool = true /***Variable para definir la visibilidad de un TextView*/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem () /***actualiza el color del titulo y los items de la tab bar*/
        setUpButtons() /***Configurar diseño de los botones*/
        hideOrShowTextView() /***Determinar la atura del textView*/
        chatView.isHidden = true /***Ocultar la vista de un ejemplo de chat*/
        
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Chatbot"
       
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Tools", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Configurar diseño de los botones
    func setUpButtons(){
        //Redondeo a los botones
        playSomeConversationButton.layer.cornerRadius = playSomeConversationButton.frame.height / 3
        typicalQuestionsButton.layer.cornerRadius = typicalQuestionsButton.frame.height / 3
        startConversationButton.layer.cornerRadius = startConversationButton.frame.height / 3
    }
    
    //MARK: Visibilidad del textView
    func hideOrShowTextView() {
        isTextViewHidden.toggle()
        var height: CGFloat
        switch isTextViewHidden {
        case true:
            height = 300
        case false:
            height = 0
        }
        textHeightTypicalQuestionsConstraint.constant = height

    }
    
    //MARK: Funciones de los tres botones en pantalla
    
    //Se redirige a la pantalla del Chatbot
    @IBAction func goToConversationWithChatbot(_ sender: Any) {
        let chatViewController = ChatViewController()
        chatViewController.isANewConversation = true
        chatViewController.isNotASampleConversation = false
        navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    //En la misma panatalla se muestra un ejemplo del Chatbot
    @IBAction func showChatExample(_ sender: UIButton) {
        chatView.isHidden.toggle()
        
    }
    
    //Mostrar una vista con las tipicas preguntas para el Chatbot
    @IBAction func showTypicalQuestions(_ sender: UIButton) {
        hideOrShowTextView() /***Determinar la atura del textView*/
    }
    

}


