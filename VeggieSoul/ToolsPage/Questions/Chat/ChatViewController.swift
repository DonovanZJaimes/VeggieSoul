//
//  ChatViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/10/23.
//
//MARK: INFO
/*Se presenta la vista para poder tener un chat con el Chatbot de Spoonacular API*/

import UIKit
import MessageKit
import InputBarAccessoryView
import SafariServices

class ChatViewController: MessagesViewController {
    
    //MARK: Inicializaciones generales
    let backgroundRecipeImageURL = "https://c8.alamy.com/compes/2j7jf0e/los-alimentos-veganos-para-la-ecologia-y-el-medio-ambiente-ayudan-al-mundo-con-ideas-ecologicas-2j7jf0e.jpg" /***En caso de que la imagen de la reeta no tenga imagen, se colocara esta*/
    let currentUser = Sender(senderId: "user_id", displayName: "User") /***Usario de la aplicacion*/
    let otherUser = Sender(senderId: "chatbot_id", displayName: "chatbot") /***El chatbot sera el otro usuario*/
    var messages = [MessageType]()/***Mensajes para presentar en el chat*/
    var isANewConversation = false
    var isNotASampleConversation = true
    var messageId = 0 /***Id para cada mensaje*/
    var timeInterval: Double = 70000 /***Intervalo de tiempo para cada mensaje*/
    var contextId: Int = .random(in: 0...1000) /***Id de la conversacion para que el Chat pueda recordar las preguntas y respuestas anteriores*/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem () /***Configura el titulo y botones del navigationItem*/
        //Delegados y data source del chat
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //En caso de ser una nueva conversacion
        if isANewConversation {
            welcomeMessage()
        }
        //En caso de presentar un mensaje de ejemplo
        if isNotASampleConversation {
            sampleConversation()
        }
    }
    
    
    //Mensaje de bienvenida cada vez que se presenta un nuevo chat
    func welcomeMessage() {
        messages.append(Message(sender: otherUser, messageId: newId(), sentDate: newDate(), kind: .text("How I can help you?")))
        messagesCollectionView.reloadData()
        isANewConversation = false
    }
    
    //Mensaje de parte del usuario en caso de mostrar una pregunta de ejemplo
    func sampleConversation(){
        let exampleQuestions = ["Calories is 1 cup of butter", "2 cups of butter in grams", "vitamin a in 2 carrots", "Donuts", "show me some foodie gifts", "what is a substitute for flour", "food trivia", "chicken recipes", "spaghetti with shrimp"]
        var random: Int = .random(in: 0...(exampleQuestions.count - 1))
        let message = Message(sender: currentUser, messageId: newId(), sentDate: newDate(), kind: .text(exampleQuestions[random]))/***Creacion de un nuevo mensaje con el texto registrado*/
        insertNewMessage(message) /***llamar a la metodo para insertar un nuevo mensaje*/
        requestAQuestion(exampleQuestions[random])/***Realizar una peticion a la API para recibir respuesta a la pregunta realizada*/
    }
    
    //MARK: Presentar un nuevo mensaje en pantalla
    func insertNewMessage(_ message: Message) {
        //Se agrega un mensaje y se presenta en pantalla
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    //Se crea un nuevo id para cada mensaje
    func newId() -> String {
        let newId = String(messageId)
        messageId += 1
        return newId
    }
    
    //Se crea una nueva fecha para un mensaje
    func newDate() -> Date {
        let newDate = Date().addingTimeInterval(-timeInterval)
        timeInterval -= 1
        return newDate
    }
    
    //MARK: Realizar peticion a la API para recibir respuesta a la pregunta realizada
    func requestAQuestion(_ question: String){
        //Obtenemos la respuesta a la pregunta realizada y la agregamos en pantalla del lado del Chatbot
        let questionString = question.lowercased().replacingOccurrences(of: " ", with: "+")
        let askTheChatbot = AskTheChatbot(text: questionString, contextId: String(contextId))
        Task {
            do {
                let answer = try await sendRequest(askTheChatbot)/***Respuesta obtenida de la API*/
                let answerText = answer.answerText
                let message = Message(sender: otherUser, messageId: newId(), sentDate: newDate() , kind: .text(answerText))/***Creamos un mensaje proveniente del Chatbot*/
                insertNewMessage(message)/***Agregamoe el mensaje en pantalla*/
                if answer.media.count != 0 { //En caso de que la respueta tenga media
                    showAnswersWithMedia(media: answer.media)
                }
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            }
            catch{
                print(error)
            }
        }
    }
    //Mostrar en pantalla la respuesta obtenida de la API con media disponible
    func showAnswersWithMedia(media: [AnswerMedia]) {
        Task {
            for index in 0 ..< media.count {
                //obtenemos los valores para mostrar en el mensaje
                let url = URL(string: media[index].link ?? "https://spoonacular.com/food-api")
                let urlImage = media[index].image ?? backgroundRecipeImageURL
                let fetchImage = FetchChatbotImage(url: urlImage)
                let text = media[index].title
                if let image = try? await sendRequest(fetchImage) { //Se obtiene la imagen disponible
                    let messageWithMedia = Message(sender: otherUser, messageId: newId(), sentDate: newDate(), kind: .linkPreview(Link(text: text ,url: url!, teaser: "", thumbnailImage: image))) /***Se crea un mensaje a partir de los datos obtenidos proveniente del Chatbot*/
                    insertNewMessage(messageWithMedia)/***Insertamos el mensaje en pantalla*/
                }
            }
        }
        
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // metodo que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Chatbot"
        
        //Configurar el boton de edicion
        navigationItem.rightBarButtonItem = UIBarButtonItem (title: "Delete chat", style: .plain, target: self, action: #selector(startNewConversation))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        //UIColor(named: "ColorTeal")!
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Comenzar con una nueva conversacion
    @objc func startNewConversation(){
        //borramos los mensajes guardados y tambien en la pantalla
        messages.removeAll()
        messagesCollectionView.reloadData()
        contextId = .random(in: 0...1000) /***Obtenemos nuevo Id para una conversacion nueva*/
        isANewConversation = true
        welcomeMessage() /***Mostarmos un mensaje de entrada*/
    }
    
}
//MARK: Extension pata los delegados y data source de la vista
extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource, InputBarAccessoryViewDelegate, MessageLabelDelegate, MessageCellDelegate {
    //MARK: metodos para la DataSourse de los mensajes
    func currentSender() -> SenderType {
        currentUser /***Principal usuario*/
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        messages.count
    }
    
    //MARK: Delegado para mostar un nuevo mensaje al presionar "Send"
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //Cuando se presiona el boton de "Send" se realiza este metodo
        let message = Message(sender: currentUser, messageId: newId(), sentDate: newDate(), kind: .text(text))/***Creacion de un nuevo mensaje con el texto registrado*/
        insertNewMessage(message) /***llamar al metodo para insertar un nnuevo mensaje*/
        
        inputBar.inputTextView.text = "" /***Borramos texto del InputBar*/
        inputBar.resignFirstResponder()
        inputBar.inputTextView.resignFirstResponder()
        //Mostar el nuevo mesaje en pantalla
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        requestAQuestion(text)/***Realizar una peticion a la API para recibir respuesta a la pregunta realizada*/
    }
    
    //MARK: Modificar el diseño de los mensajes
    //Modificar el color de findo de cada mensaje
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if messages[indexPath.section].sender.displayName == currentUser.displayName {
            return UIColor(named: "ColorTeal")!
        }
        else {
            return .opaqueSeparator
        }
    }
    
    //Modificar la imagen correspondiente a cada avatar
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.backgroundColor = .white
        avatarView.layer.borderWidth = 1
        avatarView.contentMode = .scaleAspectFit
        if messages[indexPath.section].sender.displayName == currentUser.displayName {
            //Imagen del lado del usuario
            avatarView.image = UIImage(systemName: "person")
            avatarView.tintColor = .opaqueSeparator
            let borderColor = UIColor(named: "ColorTeal")
            avatarView.layer.borderColor = borderColor?.cgColor

        } else {
            //imagen del lado del Chatbot
            avatarView.image = UIImage(named: "ChatbotAvatar")!
            let borderColor = UIColor(named: "opaqueSeparator")
            avatarView.layer.borderColor = borderColor?.cgColor
            
        }
    }
    
    //Configurar la imagen del mensaje
    func configureLinkPreviewImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        imageView.layer.cornerRadius = imageView.frame.height / 3
    }
    
    //MARK: Presionar un mensaje
    //Ir a safari en caso de presionar la url de un mensaje
    func didSelectURL(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
        print("se presiono el url \(url)")
    }
    
    
    
}
