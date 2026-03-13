# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS='_-' # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            # Right-side prompt with exit codes and background processes
            #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Custom Aliases
alias pipes='./pipes.sh -p 10 -t 2 -r 10000 -R'
alias cpipes='pipes'
alias disk='cd /mnt/c/Users/PC'
alias kali='cd'
alias root='sudo -i'
alias share='cd /usr/share'
alias cls='clear'
alias dracnmap='cd ~/Dracnmap/ && sudo bash dracnmap-v2.2.sh'
alias 'cd-'='cd ..'
alias holmes='cd ~/Mr.Holmes && source venv/bin/activate && python3 MrHolmes.py'
alias venv='python3 -m venv venv && source venv/bin/activate'
alias zphisher='cd ~/zphisher/ && bash zphisher.sh'
alias backup='cp ~/.zshrc /mnt/c/Users/PC/BackupKali/.zshrc_$(date +%Y-%m-%d)'
alias gitlink='python gitlink.py'
alias myip='curl ifconfig.me'
search_user() {
    local user="$1"
    maigret --id-type username -a "$user" -n 10
}
sqlmap() {
	local url="$1"
	command sqlmap -u "$url" --batch --level=5 --risk=3 --threads=10 --delay=0 --timeout=10 --retries=1 --keep-alive --null-connection --crawl=20 --forms --technique=BEUSTQ --dbs --tables --random-agent --tamper=between,charencode,equaltolike,space2comment,space2plus,unionalltounion
}
dirb() {
	local url="$1"
	command dirb "$url" /usr/share/dirb/wordlists/common.txt,/usr/share/dirb/wordlists/big.txt,/usr/share/dirb/wordlists/extensions_common.txt -a 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' -o dirb_scan.txt -S -r -z 10 -X .php,.html,.txt,.bak,.old,.zip,.sql,.js,.xml -f | grep -v -E "\(CODE:(503|403|404|400|301)\)"
}
waf() {
	local url="$1"
	wafw00f "$url"
}
open_ports() {
	local domain="$1"
	sudo nmap -p- --open -sS -vvv -Pn -n --min-rate 5000 "$domain"
}

alias cat="batcat --paging=never"

alias fzf="fzf --preview 'batcat --paging=never --color=always {}'"

c() {
    local file="$1"

    if [[ -z "$file" ]]; then
        echo "Uso: c archivo.c"
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        echo "Archivo no encontrado"
        return 1
    fi

    local output="${file%.c}"

    gcc "$file" -Wall -Wextra -g -o "$output" && ./"$output"
}

alias dev="tmux new-session -A -s dev \; set -g status off \; split-window -h -p 40"

alias install-gnome="dconf load /org/gnome/terminal/ < gnome-terminal-config.dconf"

# ============================
#   DIRB WORDLISTS (single line)
# ============================
all_lists="/usr/share/dirb/wordlists/big.txt,\
/usr/share/dirb/wordlists/catala.txt,\
/usr/share/dirb/wordlists/common.txt,\
/usr/share/dirb/wordlists/euskera.txt,\
/usr/share/dirb/wordlists/extensions_common.txt,\
/usr/share/dirb/wordlists/indexes.txt,\
/usr/share/dirb/wordlists/mutations_common.txt,\
/usr/share/dirb/wordlists/small.txt,\
/usr/share/dirb/wordlists/spanish.txt"
light_lists="/usr/share/dirb/wordlists/common.txt,/usr/share/dirb/wordlists/small.txt,/usr/share/dirb/wordlists/indexes.txt,/usr/share/dirb/wordlists/extensions_common.txt"
heavy_lists="/usr/share/dirb/wordlists/big.txt,/usr/share/dirb/wordlists/mutations_common.txt"
# ============================
#       DIRB LIGHT SCAN
# ============================
dirb_light(){ local url="$1"; command dirb "$url" "$light_lists" -a 'Mozilla/5.0' -o "dirb_light_$(date +%Y%m%d_%H%M%S).txt" -S -r -z 10 -X php,html,txt -f | grep -v -E "\(CODE:(403|404|400|301)\)"; }
# ============================
#       DIRB HEAVY SCAN
# ============================
dirb_heavy(){ local url="$1"; command dirb "$url" "$heavy_lists" -a 'Mozilla/5.0' -o "dirb_heavy_$(date +%Y%m%d_%H%M%S).txt" -S -r -z 5 -X php,html,txt,bak,zip,old,sql -f | grep -v -E "\(CODE:(403|404|400|301)\)"; }

# ============================
#       DIRB FULL SCAN
# ============================
dirb_full(){ local url="$1"; command dirb "$url" "$all_lists" -a 'Mozilla/5.0' -o "dirb_all_$(date +%Y%m%d_%H%M%S).txt" -S -r -z 10 -X php,html,txt,bak,old,zip,sql,js,xml -f | grep -v -E "\(CODE:(503|403|404|400|301)\)"; }

dirb_help(){
	echo """ [1] <---- dirb_light {url} ----> Light scan to url"""
	echo """ [2] <---- dirb_heavy {url} ----> Heavy scan to url"""
	echo """ [3] <---- dirb_full {url} ----> Full scan to url"""
}
# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

### NUCLEI ALIASES AND HELP ###

# === NUCLEI CORE ===
alias nuclei-tech='nuclei -t technologies/ -rl 10'
alias nuclei-core='nuclei -t exposures/ -t misconfiguration/ -t headers/ -rl 10 -nc'

# === NUCLEI WEBAPP TYPES ===
alias nuclei-api='nuclei -t api/ -t misconfiguration/cors/ -rl 10 -nc'
alias nuclei-auth='nuclei -t vulnerabilities/auth/ -t misconfiguration/auth/ -rl 10 -nc'
alias nuclei-cloud='nuclei -t cloud/ -rl 10 -nc'
alias nuclei-takeover='nuclei -t takeovers/ -rl 10 -nc'

# === NUCLEI CMS ===
alias nuclei-wp='nuclei -t wordpress/ -t misconfiguration/ -rl 10 -nc'
alias nuclei-joomla='nuclei -t joomla/ -rl 10 -nc'
alias nuclei-drupal='nuclei -t drupal/ -rl 10 -nc'

# === SAFE CVE MODE ===
alias nuclei-cve-safe='nuclei -t cves/ -s high,critical -rl 10 -nc'

# === SMART MODE === 
alias nuclei-smart='nuclei -t technologies/ -t exposures/ -t misconfiguration/ -t headers/ -rl 10 -nc'

# ===NUCLEI HELP===
nuclei-help() {
  cat << "EOF"

==================== NUCLEI ALIASES HELP ====================

[ CORE – USAR SIEMPRE ]
  nuclei-tech       → Detecta tecnologías / stack
  nuclei-core       → exposures + misconfiguration + headers
  nuclei-smart      → tech + core (scan rápido recomendado)

[ WEBAPP TYPES ]
  nuclei-api        → APIs / JSON / Backends (CORS, auth, leaks)
  nuclei-auth       → Login / Register / Reset password
  nuclei-cloud      → AWS / GCP / Azure misconfigs
  nuclei-takeover   → Subdomain takeovers (usar con -l subs.txt)

[ CMS ]
  nuclei-wp         → WordPress
  nuclei-joomla     → Joomla
  nuclei-drupal     → Drupal

[ CVEs ]
  nuclei-cve-safe   → Solo CVEs High/Critical (modo limpio)

--------------------------------------------------------------
USO:
  nuclei-core -u https://target.com
  nuclei-api -u https://api.target.com
  nuclei-takeover -l subs.txt

FLOW RECOMENDADO:
  1) nuclei-tech
  2) nuclei-core
  3) alias específico según stack
  4) validar manual (Burp)

==============================================================

EOF
}

globe() {
    # verde poco saturado (suave, no chillón)
    echo -e "\e]10;#66cc66\a"

    # asegurar que al salir o Ctrl+C se restaure el color
    trap 'echo -e "\e]10;\a"; trap - INT TERM EXIT' INT TERM EXIT

    ~/.cargo/bin/globe -sc2 -g10

    # restaurar al terminar normalmente
    echo -e "\e]10;\a"
    trap - INT TERM EXIT
}


### START PART ###
clear
fastfetch
alias skullr="/usr/local/bin/skullr"
