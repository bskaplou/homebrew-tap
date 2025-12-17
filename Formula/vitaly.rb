class Vitaly < Formula
  desc "VIA/Vial API client and cli tool for guiless keyboard configuration."
  homepage "https://github.com/bskaplou/vitaly"
  version "0.1.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.14/vitaly-aarch64-apple-darwin.tar.xz"
      sha256 "3b38bb51cfd3038eebe7465027e65effc081b1ca6c753648fb5e3f5b1a418b74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bskaplou/vitaly/releases/download/v0.1.14/vitaly-x86_64-apple-darwin.tar.xz"
      sha256 "3c2812a6dcc4b8d920b87a31b337d49fcc65303d4a1d6f96a49ca1d5d96a7e34"
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
