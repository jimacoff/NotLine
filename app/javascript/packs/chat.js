import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import Chatroom from './chat/chatroom.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', function() {
    const chatData = document.getElementById('chat-data').dataset.json
    const vueapp = new Vue({
        el: '#vueapp',
        template: `<Chatroom :chatData='${chatData}'/>`,
        components: { Chatroom }
    })
})
