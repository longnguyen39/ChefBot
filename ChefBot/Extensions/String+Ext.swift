//
//  String+Ext.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import Foundation

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //length = 62
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomNo(length: Int) -> String {
    let letters = "0123456789" //length = 10
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func generateImgName(username: String) -> String {
    let name = username.lowercased()
    var imgName = ""
    
    if name.isEmpty {
        imgName = "person.circle"
    } else {
        if name.first == "a" {
            imgName = "a.circle"
        } else if name.first == "q" {
            imgName = "q.circle"
        } else if name.first == "w" {
            imgName = "w.circle"
        } else if name.first == "e" {
            imgName = "e.circle"
        } else if name.first == "r" {
            imgName = "r.circle"
        } else if name.first == "t" {
            imgName = "t.circle"
        } else if name.first == "y" {
            imgName = "y.circle"
        } else if name.first == "u" {
            imgName = "u.circle"
        } else if name.first == "i" {
            imgName = "i.circle"
        } else if name.first == "o" {
            imgName = "o.circle"
        } else if name.first == "p" {
            imgName = "p.circle"
        } else if name.first == "s" {
            imgName = "s.circle"
        } else if name.first == "d" {
            imgName = "d.circle"
        } else if name.first == "f" {
            imgName = "f.circle"
        } else if name.first == "g" {
            imgName = "g.circle"
        } else if name.first == "h" {
            imgName = "h.circle"
        } else if name.first == "j" {
            imgName = "j.circle"
        } else if name.first == "k" {
            imgName = "k.circle"
        } else if name.first == "l" {
            imgName = "l.circle"
        } else if name.first == "z" {
            imgName = "z.circle"
        } else if name.first == "x" {
            imgName = "x.circle"
        } else if name.first == "c" {
            imgName = "c.circle"
        } else if name.first == "v" {
            imgName = "v.circle"
        } else if name.first == "b" {
            imgName = "b.circle"
        } else if name.first == "n" {
            imgName = "n.circle"
        } else if name.first == "m" {
            imgName = "m.circle"
        } else {
            imgName = "person.circle"
        }
    }
    
    return imgName
}
