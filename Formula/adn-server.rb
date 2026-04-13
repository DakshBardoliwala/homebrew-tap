class AdnServer < Formula
  desc "Architectural Discovery Navigation — a high-performance code knowledge graph and MCP server for AI agents."
  homepage "https://github.com/DakshBardoliwala/ADN"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.1.3/adn-server-aarch64-apple-darwin.tar.xz"
      sha256 "60af8ca2ae71c2a8e99dda03e9999df82953e11d72eb0c95936e7ea56f8dee2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.1.3/adn-server-x86_64-apple-darwin.tar.xz"
      sha256 "d36e21890a1478a53d2beb3cf67d91240abc12ae732a1d074231bc0d40029d7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.1.3/adn-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42fb90c8aa64f7718fbd15465a8714e5510a9cc3d1ea33ec1462bf555a5c95a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.1.3/adn-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b784eecda552c971bdb4e4f184b4c1ed2901948cc55c8262aa901f76ed2620b"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "adn" if OS.mac? && Hardware::CPU.arm?
    bin.install "adn" if OS.mac? && Hardware::CPU.intel?
    bin.install "adn" if OS.linux? && Hardware::CPU.arm?
    bin.install "adn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
