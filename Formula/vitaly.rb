class Vitaly < Formula
  desc "VIA/Vial API client and cli tool for guiless keyboard configuration."
  homepage "https://github.com/bskaplou/vitaly"
  version "0.1.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.20/vitaly-aarch64-apple-darwin.tar.xz"
      sha256 "24c7a0fd8be2b072bd80cb4bff37827218f6d7e0cc5a91e0077ea19430aad08d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.20/vitaly-x86_64-apple-darwin.tar.xz"
      sha256 "375ed5e5ff4241ac86d2209fcbf146e112e56ee9d1f8d1c2668f3d0257974bf9"
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
