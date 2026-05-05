cask "jbr@21" do
  arch arm: "aarch64", intel: "x64"

  version "21.0.10,1163.110"
  sha256 arm:   "ea377bd127553b48cd2c630d18e75b5537fda734eae7a9d4b38fff6adad6eef7",
         intel: "d18f07dd79bcccabf6dc26e264ba7edf5330c66fc011a8ec52057a62a75932a0"

  url "https://cache-redirector.jetbrains.com/intellij-jbr/jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg",
      verified: "cache-redirector.jetbrains.com/"
  name "JetBrains Runtime 21"
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
  conflicts_with cask: ["jbr", "jbr@17"]
  depends_on :macos

  pkg "jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg"

  uninstall pkgutil: "com.jetbrains.jbr"

  # No zap stanza required
end
