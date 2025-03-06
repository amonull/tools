# TODO:

## Fix Theming
Themes applied/available on host do not get applied to container gui apps due to it not having access to them on its file structure to fix this copy contents of /usr/share/icons and /usr/share/themes into the containers folders (preferred over mounting those folders to avoid the risk of overwriting them) put them in containers home folder the same goes for host folders/files: .config/Trolltech, .gtkrc-*, and set env vat QA_STYLE_OVERRIDE to whatever the current qt theme is. 
