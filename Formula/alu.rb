class Alu < Formula
  desc "Agent Logic Unit — deterministic math evaluation CLI for AI agents"
  homepage "https://github.com/DakshBardoliwala/ALU-CLI"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.2/alu-aarch64-apple-darwin.tar.xz"
      sha256 "28b3722a5a23086743b5b697e68675a25bfa05750a5e9b22401d008fe78074ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.2/alu-x86_64-apple-darwin.tar.xz"
      sha256 "ab1047011fe313b571cd06047cd8027657e828a1d3e22a553222978bf91419cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.2/alu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1bd12ca5ee87638132b8774b27329e13d9d39727246fb4b6d8e05aa1886b8a73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.2/alu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "291b7349b16b7904ce02aefcabd65cd409631ec8a94492d898d9d84ff1ac98ea"
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
