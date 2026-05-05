cask "jbr@17" do
  arch arm: "aarch64", intel: "x64"

  version "17.0.14,1367.22"
  sha256 arm:   "32c7c9e731d3cc82b7c16abdfdd80b8a9b8d8a84c4d214eea59ea65e25d9e147",
         intel: "1bed0b291431d267f76e0b17c340fb8b0fd9f66ac490f1b70937d91010665908"

  url "https://cache-redirector.jetbrains.com/intellij-jbr/jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg",
      verified: "cache-redirector.jetbrains.com/"
  name "JetBrains Runtime 17"
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
  conflicts_with cask: ["jbr", "jbr@21"]
  depends_on :macos

  pkg "jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg"

  uninstall pkgutil: "com.jetbrains.jbr"

  # No zap stanza required
end
