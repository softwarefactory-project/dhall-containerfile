let Containerfile = ../package.dhall

in    Containerfile.from "fedora"
    # Containerfile.emptyLine
    # Containerfile.run
        "Install emacs"
        [ "dnf update -y", "dnf install -y emacs-nox", "dnf clean all" ]
    # Containerfile.volume [ "/data" ]
    # Containerfile.label
        ( toMap
            { description = "a text editor"
            , maintainer = "tdecacqu@redhat.com"
            }
        )
    # Containerfile.emptyLine
    # Containerfile.entrypoint [ "emacs" ]
