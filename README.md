NotLine
===

# Installation

# Deploy

# Test

# Pages Spec

## Login / Sign up

- devise gem
- email / twitter

## User Info

- url: `/users/info`(for current user), `/users/:id` (other user)
- show: avatar, name, status

## Edit User Info

- url: `/users/edit`
- form: avatar, name, status

## People

- url: `/users`
- list: all users, paged per 20, sort by name
  - info: avatar, name, status
  - link: Info(`/users/:id`)
  - link: Chat(`/users/:id/chat`)

## Chat List

- url: `/chats/`
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
