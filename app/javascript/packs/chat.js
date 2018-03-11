import 'babel-polyfill'
import 'whatwg-fetch'
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import Chatroom from './chat/chatroom.vue'
import Message from './chat/message.vue'
import UUID from 'vue-uuid'
import moment from 'moment'
import gravatar from 'gravatar'

Vue.use(UUID)
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', function() {
    const chatData = document.getElementById('chat-data').dataset.json
    Vue.component('Message', Message)
    window.moment = moment
    window.gravatar = gravatar
    const vueapp = new Vue({
        el: '#vueapp',
        template: `<Chatroom :chatData='${chatData}'/>`,
        components: { Chatroom }
    })
})
