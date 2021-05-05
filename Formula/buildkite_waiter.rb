class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/v0.2.1.tar.gz"
  sha256 "28fcc99b5f556dc0a46349ec7db291c855819d23bd398fbfe785a3cdb30fc022"
  license "Apache-2.0" # or MIT
  revision 1
  head "https://github.com/liamdawson/buildkite_waiter.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/liamdawson/homebrew-repo/releases/download/buildkite_waiter-0.2.1_1"
    sha256 cellar: :any_skip_relocation, catalina:     "17de14a4bc683bbd055623366c0f6b45ec5e072125d8120918ad2c382d3ed399"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58a5548d4cf37fe08fc1a872153295ff6da035dea7b4347bcfc26f60aac79813"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "dbus"
  end

  def install
    cd "buildkite_waiter" do
      system "cargo", "install", *std_cargo_args
    end

    # Completion scripts and manpage are generated in the crate's build directory, which includes a fingerprint hash.
    out_dir = Dir["target/release/build/buildkite_waiter-*/out"].first
    bash_completion.install "#{out_dir}/buildkite_waiter.bash"
    fish_completion.install "#{out_dir}/buildkite_waiter.fish"
    zsh_completion.install "#{out_dir}/_buildkite_waiter"
  end

  test do
    stdout, stderr, status = Open3.capture3(
      "#{bin}/buildkite_waiter by-url https://buildkite.com/my-great-org/my-pipeline/builds/1",
    )

    assert_equal false, status.success?
    assert_equal "", stdout
    assert_match "Unable to retrieve a saved API token", stderr
  end
end
