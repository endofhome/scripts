#!/usr/bin/env node

const fs = require('fs');
const username = require("os").userInfo().username;
const links = [];
const outputPath = '/out/bookmarks-backup.json';
const args = process.argv.slice(2);

const validated = function(args) {
    if (args.length > 1) {
        console.log("Only one argument, the name of a single directory or bookmark, can be provided.");
        process.exit(1);
    }
    return args[0]
};

function writeFileOrPrintError() {
    if (links.length > 0) {
        console.log("Writing backup file...");
        fs.writeFileSync('./out/bookmarks-backup.json', JSON.stringify(links), {}, (err) => {
            if (err) throw err;
        });
        console.log(`Bookmarks backed up to ${outputPath}`);
    } else {
        console.log(`No bookmark or directory with the name \"${target}\" found.`)
        process.exit(1);
    }
}

const target = validated(args);

fs.readFile(`/Users/${username}/Library/Application Support/Google/Chrome/Default/Bookmarks`, 'utf-8', (err, data) => {
    if (err) throw err;
    const content = JSON.parse(data);

    content["roots"]["bookmark_bar"]["children"].forEach(child => {
        if (child.name === target) {
            links.push(child)
        }
    });

    writeFileOrPrintError();
    process.exit(0);
});