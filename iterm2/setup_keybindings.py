#!/usr/bin/env python3
"""
Configure iTerm2 keybindings via the iTerm2 Python API.
This script sets up Ctrl+Tab to cycle through tabs like browser tab switching.
"""

import iterm2
import sys


async def main():
    app = await iterm2.async_get_app()
    
    if app is None:
        print("Error: iTerm2 is not running or API access is not available")
        print("Please ensure iTerm2 is running and try again")
        sys.exit(1)
    
    # Get the current profile (use first available or default)
    profiles = await app.profiles
    
    if not profiles:
        print("Error: No iTerm2 profiles found")
        sys.exit(1)
    
    # We'll configure all profiles with the keybinding
    for profile in profiles:
        print(f"Configuring keybindings for profile: {profile.name}")
        
        # Set Ctrl+Tab to select next tab
        await profile.async_set_keyboard_shortcut(
            "0x09^@", "com.iterm2.action.next-tab"
        )
        
        print(f"  ✓ Ctrl+Tab configured to select next tab")
    
    print("iTerm2 keybindings configured successfully!")


if __name__ == "__main__":
    iterm2.run_until_complete(main())
