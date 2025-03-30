#!/usr/bin/env bash

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --no-filter --enable flathub
flatpak install --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1 )
flatpak remote-delete fedora
