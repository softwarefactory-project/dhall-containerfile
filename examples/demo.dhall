let Containerfile = ../package.dhall

in    Containerfile.from "fedora"
    # Containerfile.emptyLine
    # Containerfile.run
        "Install emacs"
        [ "dnf update -y", "dnf install -y emacs-nox", "dnf clean all" ]
    # Containerfile.entrypoint [ "emacs" ]
