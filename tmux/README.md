# tmux - how to

### Installation
Open your favourite terminal and type `sudo apt-get install tmux`

### Run
In your favourite terminal type `tmux`

### Hot keys
[follow this link](./hotkey.md)

### Manual
Type `man tmux`

### Settings
* Add this code to `.bashrc`:
```bash
# Making SSH_AUTH_SOCK work between detaches in tmux/screen
if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/agent_sock" ] ; then
   unlink "$HOME/agent_sock" 2>/dev/null
   ln -s "$SSH_AUTH_SOCK" "$HOME/agent_sock"
   export SSH_AUTH_SOCK="$HOME/agent_sock"
fi
```
* Restart tmux and terminal

### Enjoy it =)
