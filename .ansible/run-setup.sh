#!/usr/bin/env bash

# Ansible Setup Script for Fedora Bluefin
# This script configures a new Fedora Bluefin machine with development tools

set -e

ANSIBLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$ANSIBLE_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Fedora Bluefin
check_os() {
    log_info "Checking operating system..."
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot detect operating system"
        exit 1
    fi

    source /etc/os-release
    log_info "Detected: $PRETTY_NAME"

    if [[ "$ID" != "fedora" ]]; then
        log_warning "This playbook is designed for Fedora Bluefin/Silverblue"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check for required tools
check_requirements() {
    log_info "Checking for required tools..."

    if ! command -v ansible-playbook &> /dev/null; then
        log_warning "Ansible not found. Installing via pip..."
        pip3 install ansible --user
    fi

    if ! command -v git &> /dev/null; then
        log_error "Git not found. Please install git first."
        exit 1
    fi

    log_success "All requirements met"
}

# Install Ansible collections (if needed)
install_collections() {
    if [[ -f "$ANSIBLE_DIR/requirements.yml" ]]; then
        log_info "Installing Ansible collections..."
        ansible-galaxy collection install -r "$ANSIBLE_DIR/requirements.yml" || log_warning "Failed to install some collections"
    fi
}

# Run the playbook
run_playbook() {
    log_info "Running Ansible playbook..."
    cd "$ANSIBLE_DIR"

    ansible-playbook \
        -i inventory.ini \
        playbook.yml \
        --extra-vars "dotfiles_dest=$DOTFILES_DIR" \
        "$@"
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║   Fedora Bluefin Development Environment Setup          ║"
    echo "║   Ansible Playbook Runner                                ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    check_os
    check_requirements
    install_collections

    # Ask for sudo password upfront
    log_info "This playbook requires sudo privileges for some tasks."
    sudo -v

    # Keep sudo alive
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    run_playbook "$@"

    log_success "Setup complete! Please reboot your system to apply all changes."
    echo ""
    log_info "To reboot, run: systemctl reboot"
}

# Run main function
main "$@"
