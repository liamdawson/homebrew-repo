class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/v0.1.0.tar.gz"
  sha256 "28f162d50afbe736f6bd4de96ce11cd7e19659df929c4915538c4bced0031843"
  license "Apache-2.0" # or MIT

  depends_on "rust" => :build

  def install
    cd "buildkite_waiter" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system "#{bin}/program", "help"
  end
end
