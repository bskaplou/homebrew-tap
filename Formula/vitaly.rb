class Vitaly < Formula
  desc "VIA/Vial API client and cli tool for guiless keyboard configuration."
  homepage "https://github.com/bskaplou/vitaly"
  version "0.1.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.29/vitaly-aarch64-apple-darwin.tar.xz"
      sha256 "180ebdcb344503e5f6bd0cf0f3be4ee14865ec1988918f05d4d7c3896121a6e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.29/vitaly-x86_64-apple-darwin.tar.xz"
      sha256 "7c7220578db88b2274c07850613613ed5885103abee62f8e0004aa8c1565b884"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.29/vitaly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb676044ac2f4497b1462b66bba72e90fd89d72a548af6dbab2b99d640c2422c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.29/vitaly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0bcffdd1e2e01e193b0ef4474603bad777d74d074589a8e0086fbaea7e8ff4c1"
    end
  end
  license "MIT"

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
    bin.install "vitaly" if OS.mac? && Hardware::CPU.arm?
    bin.install "vitaly" if OS.mac? && Hardware::CPU.intel?
    bin.install "vitaly" if OS.linux? && Hardware::CPU.arm?
    bin.install "vitaly" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
