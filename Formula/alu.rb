class Alu < Formula
  desc "Agent Logic Unit — deterministic math evaluation CLI for AI agents"
  homepage "https://github.com/DakshBardoliwala/ALU-CLI"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.0/alu-aarch64-apple-darwin.tar.xz"
      sha256 "dd8c0d82d5fb67e309dd9c414b1e0f4250ce7c36645910a33938922388f05b1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.0/alu-x86_64-apple-darwin.tar.xz"
      sha256 "797404f7cc55372d33033aadb26f71040b5b1e0eff1a05211f16b58e51de7fbe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.0/alu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8876eea9bec8b9d270d412bb52892b8a9583e5ee52e4cb19a84c8c3e4533b2f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DakshBardoliwala/ALU-CLI/releases/download/v0.2.0/alu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "26f5a4ad1d220a06b320f2259b408411c2d132d41cd351acaf686e46613e53bd"
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
