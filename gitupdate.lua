local shell = require("shell")
print("Setting path to: " .. "/home/git ") 
shell.setWorkingDirectory("/home/git") 
 

print("downloading newest beerobot.lua from github")
shell.execute("wget -f https://raw.githubusercontent.com/darqen27/LuaStuff/master/beeserver.lua", PATH)


