#!/bin/sh

# Suspend the computer
suspend_computer() {
  dunstify "Suspending" && sleep 1
  # Call systemctl to suspend the computer
  systemctl suspend
}

# Main function
main() {
  suspend_computer
}

# Execute the main function
main
