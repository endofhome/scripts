Scrape the Register of Members' Financial Interests for Members of Parliament in the UK and produce a CSV documenting which MPs employ family members.

`list_of_mps.txt` is a list of MPs, one per line, in a certain-and-quite-obvious format. 
I provide a list but acknowledge that it is not perfect and/or up-to-date: you can of course use your own.

output files are `mps_employ.csv`, and in the case of errors, `errors.csv`, written in this directory.

**Usage:**

_macOs/Linux_
* clone this repo
* ensure that you have `curl` available on your system. for mac users, you can install `curl` with `homebrew` - hit up a search engine if this is new to you. Linux users, you can probably handle this.
* from your terminal, navigate to this directory and type `./mps_employ.sh`
* if the file will not execute, you may need to set permissions: `chmod +x mps_employ.sh` should do it.
* output files will be written in the same directory as the script.

_Windows_
* you will need a unix-like environment like Cygwin etc. Git for Windows provides a simple out-of-the-box solution including `curl`.
* the above steps apply.