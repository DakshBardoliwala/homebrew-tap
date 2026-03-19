class Alu < Formula
  desc "Agent Logic Unit — deterministic math evaluation CLI for AI agents"
  homepage "https://github.com/DakshBardoliwala/ALU-CLI"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.1.0/alu-aarch64-apple-darwin.tar.xz"
      sha256 "18c980daec75a179a99e454cab8c9be99abc770d96c1b21d56c45634067ce60b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.1.0/alu-x86_64-apple-darwin.tar.xz"
      sha256 "fa9a3c68cfb3377fbca62617819e6f21be01f7b425a047750c530adcee1f089e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.1.0/alu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e326b728088666ad9b99be1ca54cc7016248abb17d026215ce71af7de426faf6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.1.0/alu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8b7787d9aafdd6aae8a4904e6e85b9edec325f7372406835b2c3190e63d34b21"
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
    bin.install "alu" if OS.mac? && Hardware::CPU.arm?
    bin.install "alu" if OS.mac? && Hardware::CPU.intel?
    bin.install "alu" if OS.linux? && Hardware::CPU.arm?
    bin.install "alu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
