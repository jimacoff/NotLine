var chat = JSON.parse(document.getElementById('chat-data').dataset.json)
console.log(chat)
App.chatChannel = App.cable.subscriptions.create({channel: "ChatChannel", chat_id: chat['id']}, {
  received: function(message) {
    console.log(message)
  },
})

function send_message(text) {
  App.chatChannel.send({content: text, chat_id: chat['id']})
}
