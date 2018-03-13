<template>
    <div class="room">
        <div class="messages" v-on:scroll="scrollHandler">
            <div style="text-align: center"><a href="javascript: void(0)" v-on:click="showMoreMessages">show more messages</a></div>
            <div v-for="message in messages">
                <Message :message="message" :user="currentUser" :key="message.id" :sentByCurrentUser="true" v-if="sentByCurrentUser(message)" />
                <Message :message="message" :user="partner" :key="message.id" :sentByCurrentUser="false" v-else />
            </div>
        </div>
        <div class="message-input">
            <textarea placeholder="Press enter to send message" v-model="pendingMessage" v-on:compositionstart="compositionStart" v-on:compositionend="compositionEnd" v-on:keyup.enter="keyEnter"></textarea>
            <button class="btn btn-lg btn-primary" v-on:click="sendPendingMessage">Send</button>
        </div>
    </div>
</template>

<script>
module.exports = {
    props: ['chat', 'currentUser'],
    data: function () {
        return {
            messages: this.chat.messages,
            partner: this.chat.partner,
            inComposition: false,
            enterToSend: true,
            pendingMessage: "",
        }
    },
    mounted: function() {
        this.scrollToBottom()
    },
    updated: function() {
        if (this.scrolledAtBottom()) {
            this.scrollToBottom()
        }
    },
    methods: {
        sendMessage: function(content) {
            message = {
                content: content, 
                chat_id: this.chat.id,
                sender_id: this.currentUser.id,
                recipient_id: this.chat.partner.id,
                created_at: Date.now(),
                updated_at: Date.now(),
            }
            this.$emit('send', { message: message })
        },
        sendPendingMessage: function() {
            if (this.pendingMessage.length > 0) { 
                this.sendMessage(this.pendingMessage)
            }
            this.pendingMessage = ""
        },
        sentByCurrentUser: function(message) {
            return message.sender_id == this.currentUser.id
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
            this.$emit('fetch', {id: this.chat.id})
        },
        scrollToBottom: function() {
            var elem = this.messagesElem()
            elem.scrollTop = elem.scrollHeight
        },
        scrollHandler: function() {
        },
        messagesElem: function() {
            return document.querySelector(".messages")
        },
        scrolledAtBottom: function() {
            var elem = this.messagesElem()
            if (elem) {
                return elem.scrollHeight - (elem.scrollTop + elem.offsetHeight) <= 200
            } else {
                return false
            }
        },
        scrolledAtTop: function() {
            var elem = this.messagesElem()
            if (elem) {
                return elem.scrollTop <= 50
            } else {
                return false
            }
        },
    }
}
</script>
