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

- url: `/chats/`
- root redirect to this page
- list: all chats of current user, paged per 20, sort by update time
  - info: last message, user(avatar, name)
  - link: `/chats/:id`

## Chat Room

- url: `/chats/:id` or `/users/:user_id/chat` (redirect to corresponding chat)
- list: last 50 messages
  - info: message(content, timestamp, attachment), user(avatar, name)
- action: scroll up to load more 20 messages
- use Action Cable to communicate with server
- form: 
  - message content
  - upload image
  - submit button (or press enter)

# Models Spec

## User

- devise user attributes
- avatar, name, status
- has many users

## Chat

- has many users
- has many messages

## Message

- belongs to chat
- belongs to attachment
- methods: last, next, from
- save to redis instead of to db, a cron job saves messages in redis into db periodically

## CachedMessageDecorator

- decorates Message
- methods: last, next, from
- fetch messages from redis if exists, delegate to Message otherwise
