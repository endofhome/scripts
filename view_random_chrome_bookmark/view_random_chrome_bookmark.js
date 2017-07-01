#!/usr/bin/env node

const fs = require('fs');
const opn = require('opn');
const links = [];

fs.readFile("/Users/tombarnes/Library/Application Support/Google/Chrome/Default/Bookmarks", 'utf-8', function read(err, data) {
    if (err) {
        throw err;
    }
    const content = JSON.parse(data);

    content["roots"]["bookmark_bar"]["children"].forEach(function (child) {
        if (child.type === "folder") {
            child["children"].forEach(function (firstChild) {
                if (firstChild.type === "folder") {
                    firstChild["children"].forEach(function (secondChild) {
                        if (secondChild.type === "folder") {
                            secondChild["children"].forEach(function (thirdChild) {
                                if (thirdChild.type === "folder") {
                                    thirdChild["children"].forEach(function (fourthChild) {
                                        if (fourthChild.type === "folder") {
                                            fourthChild["children"].forEach(function(fifthChild) {
                                                links.push(fifthChild["url"]);
                                            })
                                        }
                                        links.push(fourthChild["url"]);
                                    });
                                }
                                links.push(thirdChild["url"]);
                            });
                        }
                        links.push(secondChild["url"]);
                    });
                } else {
                    links.push(firstChild["url"]);
                }
            });
        } else {
            links.push(child["url"]);
        }
    });
    const index = Math.random() * links.length;
    opn(links[Math.floor(index)]);
    process.exit(0);
});


 