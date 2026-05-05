cask "jbr" do
  arch arm: "aarch64", intel: "x64"

  version "25.0.2,432.48"
  sha256 arm:   "f68498d7865f5bc867aee73328a117ae3fe0e5994ac516a5ba92a831261ff9bf",
         intel: "957ace792e5d539f7de443a4d41385ddb0331bac208df7369bf176852089d348"

  url "https://cache-redirector.jetbrains.com/intellij-jbr/jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg",
      verified: "cache-redirector.jetbrains.com/"
  name "JetBrains Runtime"
  desc "JetBrains Runtime JVM"
  homepage "https://github.com/JetBrains/JetBrainsRuntime"

  livecheck do
    url :homepage
    regex(/^jbr-release-(#{version.major}(?:\.\d+)*?)b(\d+(?:\.\d+)*)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  # JBR does not use unique identifiers
  conflicts_with cask: ["jbr@21", "jbr@17"]
  depends_on :macos

  pkg "jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg"

  uninstall pkgutil: "com.jetbrains.jbr"

  # No zap stanza required
end
