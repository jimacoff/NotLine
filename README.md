NotLine
===

# Installation

# Deploy

# Test

# Pages Spec

## Navbar
- V bootstrap
- V link: people, chat, sign in/up/out, edit info

## Login / Sign up

- V devise gem
- V email
- twitter

## User Info

- V url: `/users/:id`
- V show: avatar, name, status

## Edit User Info

- V url: `/users/edit`
- V form: avatar, name, status

## Edit User Password

- V url: `/users/edit_password`
- V form: current password, password, confirmation

## People

- V url: `/users`
- V list: all users, paged per 20, sort by name
  - V info: avatar, name, status
  - V link: Chat(`/users/:id/chat`)

## Chat List

- V url: `/chats/`
- V root redirect to this page
- list: all chats of current user, paged per 20, sort by update time
  - info: last message, user(avatar, name)
  - link: `/chats/:id`
- update latest messages from all people continuously

## Chat Room 
- V url: `/chats/:id` or `/users/:user_id/chat` (redirect to corresponding chat)
- list: last 50 messages
  - info: message(content, timestamp, attachment), user(avatar, name)
- action: scroll up to load more 20 messages
- use Action Cable to communicate with server
- form: 
  - message content
  - submit button (or press enter)
- update latest messages in this chat continuously

# Models Spec

## User

- devise user attributes
- avatar, name, status
- has many users

## Chat

- title
- has many users
- has many messages

## Message

- id, content, relative id, sender id, recipient id
- belongs to chat
- belongs to sender
- belongs to recipient
- methods: last, next, from
- save to redis instead of to db, a cron job saves messages in redis into db periodically

## CachedMessageDecorator

- decorates Message
- methods: last, next, from
- fetch messages from redis if exists, delegate to Message otherwise

# ActionCable

- can authorize user using the chat
