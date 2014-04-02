Casey Allred

Project 4

My program is executed by running:

vm.exe proj4.asm

which is a 32bit windows executable.

Because in the windows terminal when you push enter it adds a carige return and a new line, I convert that to just a new line as that is what my assembly expected and allows it to work on any magor os. If that needs to be adjusted I can do that.

As I discussed with you my labels all must end with a ':' which occurs everywhere, I did this for ease or parsing. If it doesn't have a ':' its not a label then if its not an instruction its invalid.  I know roughly how to change it to accept any type of label if needed, but really like the simplicity of having a ':' at the end.
