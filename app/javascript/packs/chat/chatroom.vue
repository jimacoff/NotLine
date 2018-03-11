<template>
    <div id="vueapp">
        <div class="messages" v-for="message in messages">
            <Message :message="message" :user="current_user" :key="$uuid.v4()" :sentByCurrentUser="true" v-if="sentByCurrentUser(message)" />
            <Message :message="message" :user="partner" :key="$uuid.v4()" :sentByCurrentUser="false" v-else />
        </div>
        <div class="message-input">
            <textarea placeholder="Input Message" v-model="pendingMessage" v-on:compositionstart="compositionStart" v-on:compositionend="compositionEnd" v-on:keyup.enter="keyEnter"></textarea>
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
            messages: this.chatData.messages,
            inComposition: false,
            enterToSend: true,
            pendingMessage: "",
        }
    },
    mounted: function() {
        _this = this
        App.chatChannel = App.cable.subscriptions.create({channel: "ChatChannel", chat_id: this.chatData.id}, {
          received: function(message) {
              _this.receiveMessage(message)
          },
        })
    },
    methods: {
        sendMessage: function(content) {
            App.chatChannel.send({
                content: content, 
                chat_id: this.chatData.id,
                sender_id: this.chatData.current_user.id,
                recipient_id: this.chatData.partner.id,
            })
        },
        sendPendingMessage: function() {
            this.sendMessage(this.pendingMessage)
            this.pendingMessage = ""
        },
        receiveMessage: function(message) {
            this.messages.push(message)
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
                this.sendPendingMessage()
            } else {
                this.enterToSend = true
            }
        },
    }
}
</script>
