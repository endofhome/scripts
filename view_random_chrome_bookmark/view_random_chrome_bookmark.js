#!/usr/bin/env node

const fs = require('fs');
const username = require("os").userInfo().username;
const opn = require('opn');
const links = [];

const addLinksAndTraverseTree = function(child) {
    links.push(child["url"]);
    if (child.type === "folder") {
        child["children"].forEach(child => {
            addLinksAndTraverseTree(child)
        });
    }
};

fs.readFile(`/Users/${username}/Library/Application Support/Google/Chrome/Default/Bookmarks`, 'utf-8', function read(err, data) {
    if (err) {
        throw err;
    }
    const content = JSON.parse(data);

    content["roots"]["bookmark_bar"]["children"].forEach(child => {
        addLinksAndTraverseTree(child)
    });

    const index = Math.random() * links.length;
    opn(links[Math.floor(index)]);
    process.exit(0);
});