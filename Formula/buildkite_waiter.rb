class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/v0.0.1-alpha.3.tar.gz"
  sha256 "35d986c3f5bd0e4d696fde20f6351d962689a65eb3280409b2f7b34b36f338b0"
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
