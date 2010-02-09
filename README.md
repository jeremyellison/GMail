**GMail**

To get up and running, do the following:

`git init`

`git config branch.master.remote 'origin'; git config branch.master.merge 'refs/heads/master'`

`git submodule init`

`git submodule add git@github.com:twotoasters/three20.git Libraries/three20`

`git submodule add git://github.com/Objective3/ElementParser.git Libraries/ElementParser`

`git submodule add git@github.com:twotoasters/UISpec.git Libraries/UISpec`

`git add . .gitignore .gitattributes`

`git commit -am "initial commit"`

Then remove and re-add the Three20, ElementParser, and UISpec both targets.
