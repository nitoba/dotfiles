.PHONY: help install setup check dry-run verbose dotfiles nodejs flatpaks

# Default target
help:
	@echo "Fedora Bluefin Development Setup - Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install       - Install Ansible dependencies"
	@echo "  make setup         - Run full setup playbook"
	@echo "  make check         - Dry-run (check mode)"
	@echo "  make dry-run       - Same as check"
	@echo "  make verbose       - Run with verbose output"
	@echo "  make dotfiles      - Setup dotfiles only"
	@echo "  make nodejs        - Setup Node.js tools only"
	@echo "  make flatpaks      - Install Flatpak apps only"

# Install Ansible and dependencies
install:
	@echo "Installing Ansible..."
	pip3 install ansible --user
	@echo "Installing Ansible collections..."
	ansible-galaxy collection install -r requirements.yml || true

# Run full setup
setup:
	@echo "Running full setup playbook..."
	./run-setup.sh

# Check mode (dry-run)
check:
	@echo "Running playbook in check mode..."
	ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --check

dry-run: check

# Verbose mode
verbose:
	@echo "Running playbook with verbose output..."
	ansible-playbook -i inventory.ini playbook.yml --ask-become-pass -v

# Setup dotfiles only (example - add tags to playbook first)
dotfiles:
	@echo "Setting up dotfiles..."
	ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --tags dotfiles

# Setup Node.js tools only (example - add tags to playbook first)
nodejs:
	@echo "Setting up Node.js and package managers..."
	ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --tags nodejs

# Install Flatpaks only (example - add tags to playbook first)
flatpaks:
	@echo "Installing Flatpak applications..."
	ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --tags flatpaks
