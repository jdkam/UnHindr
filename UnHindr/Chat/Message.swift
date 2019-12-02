/*
 File: [message.swift]
 Creators: [Jordan]
 Date created: [24/11/2019]
 Date updated: [1/12/2019]
 Updater name: [Jordan]
 File description: [A custom class for messages]
 */

import Foundation

//a structure for what a message object will contain
//1. who the sender is (email)
//2. What the content of the message is
struct Message {
    let sender: String
    let body: String
}
