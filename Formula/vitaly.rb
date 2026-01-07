class Vitaly < Formula
  desc "VIA/Vial API client and cli tool for guiless keyboard configuration."
  homepage "https://github.com/bskaplou/vitaly"
  version "0.1.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.30/vitaly-aarch64-apple-darwin.tar.xz"
      sha256 "ce996d4c47ca01cf9adc3676042d60b4b4b53ed6ded4f937d96b71b6c7e55e77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.30/vitaly-x86_64-apple-darwin.tar.xz"
      sha256 "5dc954881d9062114cc8f7c06951202b8b58cc49b2d84731612da6b26b05bbd1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.30/vitaly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7498d3603bffb2415b48e9ae1cae54b1a3b204cc3daec601b7af9b952c54cb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.30/vitaly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8a2f86396fb7e7057c812c65288f767c8b0933820ba41c5f2eae47fa04bb10d1"
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
