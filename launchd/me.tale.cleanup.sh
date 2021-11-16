#!/bin/bash
command rm -rf "$HOME/.bash_history"
command rm -rf "$HOME/.bash_profile"
command rm -rf "$HOME/.bash_history"
command rm -rf "$HOME/.swiftpm"
command rm -rf "$HOME/.pnpm-debug.log"
command rm -rf "$HOME/.pkg-cache"
command rm -rf "$HOME/.npm/tmp"
command rm -rf "$HOME/.node_repl_history"
command rm -rf "$HOME/.lesshst"
command rm -rf "$HOME/.cups"
command rm -rf "$HOME/.bundle"
command rm -rf "$HOME/Library/Developer/Xcode/DerivedData"
command rm -rf "$HOME/Library/Logs/DiagnosticReports"

command rm -rf $HOME/Trash/*
command rm -rf $HOME/.pnpm-store/v3/tmp/*
command rm -rf $HOME/.kube/cache/http/*
command brew cleanup
