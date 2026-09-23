set -U fish_greeting ""

if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

alias in="sudo pacman -S"
alias yin="yay -S"
alias ss="sudo pacman -Ss"
alias sy="yay -Ss"
alias update="yay -Syu"
alias remove="sudo pacman -Rns"

alias ls="eza --icons --color=always"
alias ll="eza -al --icons --color=always"
#alias la "eza -al --icons --color=always"

#niri-specific
alias usr="cd ~/.config/hypr/user/"

alias gdu="gdu --no-delete"


zoxide init fish | source
