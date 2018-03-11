<template>
    <div id="vueapp">
        <a href="javascript: void(0)" v-on:click="send_hello">Send hello</a>
    </div>
</template>

<script>
module.exports = {
    props: ['chatData'],
    data: function () {
        return {
        }
    },
    mounted: function() {
        App.chatChannel = App.cable.subscriptions.create({channel: "ChatChannel", chat_id: this.chatData.id}, {
          received: function(message) {
            console.log(message)
          },
        })
    },
    methods: {
        send_hello: function(event) {
            this.send_message("hello")
        },
        send_message: function(content) {
            App.chatChannel.send({content: content, chat_id: this.chatData.id})
        },
    }
}
</script>
