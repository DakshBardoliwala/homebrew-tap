class AdnServer < Formula
  desc "Architectural Discovery Navigation — a high-performance code knowledge graph and MCP server for AI agents."
  homepage "https://github.com/DakshBardoliwala/ADN"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.2.0/adn-server-aarch64-apple-darwin.tar.xz"
      sha256 "79ca2e1539f3d5398cc1f13342000b8f17499240a719ed6b5ad670cd4407d2ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.2.0/adn-server-x86_64-apple-darwin.tar.xz"
      sha256 "89668d4cf2648ea376636cacc962f2ac0f527f21c4212cc5b5d7bc2631445493"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.2.0/adn-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d96c38c333a1a2343b84a4713592a8d079c94b5e92e59a1c41c65f6fc10cb7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ADN/releases/download/v0.2.0/adn-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a72399fd64a259ca796d2a373f6bf6987628059f5dc70f8d21cf0afff95660c"
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
