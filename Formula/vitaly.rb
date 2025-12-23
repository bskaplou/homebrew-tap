class Vitaly < Formula
  desc "VIA/Vial API client and cli tool for guiless keyboard configuration."
  homepage "https://github.com/bskaplou/vitaly"
  version "0.1.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.16/vitaly-aarch64-apple-darwin.tar.xz"
      sha256 "e86d28b906126499d05f8e2608ee99ba3b13492b8ecebf539967a0dba3e729a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.16/vitaly-x86_64-apple-darwin.tar.xz"
      sha256 "62024e262f5f14351c583481a0c1accf70e5b11c2c7149676db2533bd90a6a00"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "vitaly" if OS.mac? && Hardware::CPU.arm?
    bin.install "vitaly" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
