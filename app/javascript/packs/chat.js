import 'babel-polyfill'
import 'whatwg-fetch'
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import App from './chat/app.vue'
import Chatroom from './chat/chatroom.vue'
import Message from './chat/message.vue'
import UUID from 'vue-uuid'
import moment from 'moment'
import gravatar from 'gravatar'

Vue.use(UUID)
Vue.use(TurbolinksAdapter)
Vue.component('Message', Message)
Vue.component('Chatroom', Chatroom)
window.moment = moment
window.gravatar = gravatar
const pageData = document.getElementById("chats-data").dataset.json
const vueapp = new Vue({
    el: '#vueapp',
    template: `<App :pageData='${pageData}'/>`,
    components: { App }
})
