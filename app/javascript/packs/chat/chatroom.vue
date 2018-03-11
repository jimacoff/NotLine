<template>
    <div id="vueapp">
        <div style="text-align: center"><a href="javascript: void(0)" v-on:click="showMoreMessages">show more messages</a></div>
        <div class="messages" v-for="message in messages">
            <Message :message="message" :user="current_user" :key="message.id" :sentByCurrentUser="true" v-if="sentByCurrentUser(message)" />
            <Message :message="message" :user="partner" :key="message.id" :sentByCurrentUser="false" v-else />
        </div>
        <div class="message-input">
            <textarea placeholder="Press enter to send message" v-model="pendingMessage" v-on:compositionstart="compositionStart" v-on:compositionend="compositionEnd" v-on:keyup.enter="keyEnter"></textarea>
            <button class="btn btn-lg btn-primary" v-on:click="sendPendingMessage">Send</button>
        </div>
    </div>
</template>

<script>
module.exports = {
    props: ['chatData'],
    data: function () {
        return {
            current_user: this.chatData.current_user,
            partner: this.chatData.partner,
            messages: [],
            inComposition: false,
            enterToSend: true,
            pendingMessage: "",
            scrollToBottom: true,
        }
    },
    beforeMount: function() {
    },
    mounted: function() {
        _this = this
        this.fetchMessages().then(function(messages) {
            _this.messages = messages
        }).then(function() {
            window.scrollTo(0, document.body.scrollHeight)
        })
        this.chatChannel = App.cable.subscriptions.create({channel: "ChatChannel", chat_id: this.chatData.id}, {
          received: function(message) {
              _this.receiveMessage(message)
          },
        })
    },
    updated: function() {
        if (this.scrollToBottom) {
            scrollTo(0, document.body.scrollHeight)
        }
    },
    beforeDestroy: function() {
        this.chatChannel.unsubscribe()
        this.chatChannel = null
    },
    methods: {
        fetchMessages: function(limit = "", offset = "") {
            return fetch(`/chats/${this.chatData.id}/messages?limit=${limit}&offset=${offset}`, {
                credentials: 'same-origin'
            }).then(function(response) {
                return response.json()
            }).then(function(json) {
                return json.messages
            }).catch(function(error) {
                console.log(error)
            })
        },
        receiveMessage: function(message) {
            if (message.sender_id != this.current_user.id) {
                this.messages.push(message)
                return
            }
            var len = this.messages.length
            if (parseInt(message.created_at) > parseInt(this.messages[len - 1].created_at)) {
                this.messages.push(message)
                return
            }
        },
        sendMessage: function(content) {
            message = {
                content: content, 
                chat_id: this.chatData.id,
                sender_id: this.chatData.current_user.id,
                recipient_id: this.chatData.partner.id,
                created_at: Date.now()
            }
            this.messages.push(message)
            this.chatChannel.send(message)
        },
        sendPendingMessage: function() {
            if (this.pendingMessage.length > 0) { 
                this.sendMessage(this.pendingMessage)
            }
            this.pendingMessage = ""
        },
        sentByCurrentUser: function(message) {
            return message.sender_id == this.current_user.id
        },
        compositionStart: function(event) {
            this.inComposition = true;
            this.enterToSend = false
        },
        compositionEnd: function(event) {
            this.inComposition = false;
        },
        keyEnter: function(event) {
            if (this.enterToSend) {
                this.pendingMessage = this.pendingMessage.replace(/\n$/, '')
                this.sendPendingMessage()
            } else {
                this.enterToSend = true
            }
        },
        showMoreMessages: function() {
        },
    }
}
</script>
