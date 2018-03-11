<template>
    <div :class="messageClass">
        <div>
            <img :src="avatarOrGravatar" class="message-avatar"></img>
        </div>
        <div class="card">
            <div class="card-body">
                <span class="message-content">
                    {{ message.content }}
                </span>
            </div>
            <div class="card-footer">
                {{ pretty_sent_at }}
            </div>
        </div>
    </div>
</template>

<script>
module.exports = {
    props: ['message', 'user', 'sentByCurrentUser'],
    data: function() {
        return {}
    },
    methods: {
    },
    computed: {
        pretty_sent_at: function() {
            return moment(this.message.sent_at).format("YYYY.MM.DD HH:mm:ss")
        },
        avatarOrGravatar: function() {
            if (this.user.avatar.thumb) {
                return this.user.avatar.thumb
            } else {
                return gravatar.url(this.user.email)
            }
        },
        messageClass: function() {
            if (this.sentByCurrentUser) {
                return "message message-right"
            } else {
                return "message message-left"
            }
        },
    },
}
</script>
