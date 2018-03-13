NotLine
===

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
- V list: last 50 messages
  - V info: message(content, timestamp), user(avatar, name)
- V action: click to load more messages
- V auto scroll to bottom if not viewing old messages
- show scroll to bottom if viewing old messages
- V use Action Cable to communicate with server
- V form: 
  - V message content
  - V submit button (or press enter)
- V update latest messages in this chat continuously
- send "read until" to server

## Messages API
- V url: `/chats/:chat_id/messages`
- V parameters: limit, offset

# Models Spec

## User

- V devise user attributes
- V avatar, name, status
- V has many chats

## Chat

- V title
- V has many users
- V has many messages

## Message

- V id, content, sender id, recipient id
- V belongs to chat
- V belongs to sender
- V belongs to recipient
- read at

# ActionCable

- V can authorize user using the chat

# Improvement
- group chat
- attachment
- link detection
- V integrate chat to one page
- show how many unreads
- V store messages together
- V messages in newly created chat
