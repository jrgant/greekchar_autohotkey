
# Load Packages -----------------------------------------------------------

pacman::p_load(dplyr, rvest, stringr)


# Import Character Table --------------------------------------------------

url <- "https://www.keynotesupport.com/websites/greek-letters-symbols.shtml"

codes <- read_html(url) %>%
  html_node("table") %>%
  html_table()

names(codes) <- c("char", "alt", "htmlname", "entity", "descr", "unicode")



# Format and Generate AutoHotkey Codes ------------------------------------

pretty <- codes %>%
  filter(grepl(x = htmlname, pattern = "\\&")) %>%
  mutate(alt = str_extract(alt, "[0-9]{3}"),
         hotkey = paste0("\\", 
                         str_extract(htmlname, "(?<=\\&)[A-Za-z]+(?=\\;)")))


# Write to Text File ------------------------------------------------------

txtdir <- # fill in with the target directory

writeLines(paste0(":*C:", pretty$hotkey, ":: \n", 
                  "SendInput {Alt Down}",
                  "{Numpad", substring(pretty$alt, 1, 1),"}",
                  "{Numpad", substring(pretty$alt, 2, 2),"}",
                  "{Numpad", substring(pretty$alt, 3, 3),"}",
                  "{Alt Up} \n",
                  "return \n"),
           con = txtdir)
