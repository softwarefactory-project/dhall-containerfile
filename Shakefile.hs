-- Interpret using this command:
--    podman run -it --rm -v $(pwd):/data:Z quay.io/software-factory/shake-factory
--
-- Learn more at: https://softwarefactory-project.io/cgit/software-factory/shake-factory/tree/README.md

import Development.Shake
import ShakeFactory
import ShakeFactory.Dhall

main = shakeMain $ do
  want ["README.md", "package.dhall"]
  "README.md" %> dhallReadmeAction
  "package.dhall" %> dhallTopLevelPackageAction "./Containerfile/package.dhall"
  "//package.dhall" %> dhallPackageAction
  dhallDocsRules "dhall-containerfile"
  dhallReleaseRules "./Containerfile/package.dhall"
  cleanRules
