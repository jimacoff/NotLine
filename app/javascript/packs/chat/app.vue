<template>
    <div id="vueapp" class="container chat">
        <div class="row" style="height: 100%">
            <div class="col-lg-3 chat-list">
                <div class="chat-listentry" v-for="chat in chats"> 
                    <div class="card" :key="chat.id">
                        <div class="card-body">
                            <h5 class="card-title">{{ chat.partner.name }}</h5>
                            <p class="card-text" v-if="chat.last_message">
                            <span v-if="chat.last_message.sender_id == currentUser.id">
                                You: 
                            </span>
                            <span v-else>
                                {{ chat.partner.name }}:
                            </span>
                            {{ chat.last_message.content }}
                            </p>
                            <a href="javascript: void(0)" v-on:click="switchTo(chat)" >Chat</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-9 chat-room">
                <Chatroom v-on:send="sendHandler" v-on:fetch="fetchHandler" :chat="currentChat" :currentUser="currentUser" :key="currentChat.id" v-if="currentChat != null"/>
            </div>
        </div>
    </div>
</template>
<script>
module.exports = {
    props: ['pageData'],
    data: function() {
        return {
            chats: this.pageData['chats'],
            currentUser: this.pageData['current_user'],
            currentChat: null,
        }
    },
    mounted: function() {
        var initialChatId = this.pageData['initial_chat_id']
        if (initialChatId) {
            var initialChat = this.chats.find(function (chat) { 
                return initialChatId == chat.id
            })
            if (initialChat) {
                this.switchTo(initialChat)
            }
        }
        var _this = this
        this.userChannel = App.cable.subscriptions.create({channel: "UserChannel", id: this.currentUser.id}, {
            received: function(payload) {
                _this.receiveUserChannel(payload)
            },
        })
    },
    destroyed: function() {
        if (this.currentChat && this.currentChat.channel) {
            this.currentChat.channel.unsubscribe()
        }
        this.userChannel.unsubscribe()
    },
    methods: {
        switchTo: async function(chat) {
            if (this.currentChat && this.currentChat.channel) {
                this.currentChat.channel.unsubscribe()
            }
            if (!chat.messages || chat.messages.length == 0) {
                chat.messages = await this.fetchMessagesFromAPI(chat)
            }
            chat.channel = App.cable.subscriptions.create({channel: "ChatChannel", chat_id: chat.id})
            this.currentChat = chat
        },
        fetchMoreMessages: function(chat) {
            if (chat.messages == null || chat.messages.length == 0) {
                var fromMsgId = ""
            } else {
                var fromMsgId = chat.messages[0].id
            }
            return this.fetchMessagesFromAPI(chat, 20, fromMsgId).then(function(newMessages) {
                return newMessages.concat(chat.messages)
            })
        },
        fetchMessagesFromAPI: function(chat, limit = "", fromMsgId="") {
            return fetch(`/chats/${chat.id}/messages?limit=${limit}&from_msg_id=${fromMsgId}`, {
                credentials: 'same-origin'
            }).then(function(response) {
                return response.json()
            }).then(function(json) {
                return json.messages
            }).catch(function(error) {
                console.log(error)
            })
        },
        fetchChatFromAPI: function(id) {
            return fetch(`/chats/${id}`, {
                credentials: 'same-origin'
            }).then(function(response) {
                return response.json()
            }).catch(function(error) {
                console.log(error)
            })
        },
        sendHandler: function(payload) {
            this.currentChat.channel.send(payload.message)
        },
        fetchHandler: async function(payload) {
            var chat = this.chats.find(function (chat) { 
                return payload.id == chat.id
            })
            if (chat.messages && chat.messages.length > 0) {
                var newMessages = await this.fetchMessagesFromAPI(chat, 5, chat.messages[0].id)
                if (newMessages.length > 0) {
                    newMessages.forEach(function(message, idx) {
                        chat.messages.push(message)
                    })
                    chat.messages.sort(function(a, b) {
                        return parseInt(a.id) - parseInt(b.id)
                    })
                }
            }
        },
        receiveUserChannel: async function(payload) {
            if (payload.type == 'message') {
                var chat = this.chats.find(function (chat) { 
                    return payload.message.chat_id == chat.id
                })
                if (!chat) {
                    chat = await this.fetchChatFromAPI(payload.message.chat_id)
                    this.chats.push(chat)
                }
                chat.updated_at = Date.now()
                chat.last_message = payload.message
                if (!chat.messages) {
                    chat.messages = []
                }
                chat.messages.push(payload.message)
                this.chats.sort(function(a, b) {
                    return parseInt(b.updated_at) - parseInt(a.updated_at)
                })
            } 
        },
    }
}
</script>
