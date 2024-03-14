class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b4808bf8b9777f77e2b6fee93352461605dbcd59dc3e753fbd257c0c1eadc68c"
  license "Apache-2.0" # or MIT
  head "https://github.com/liamdawson/buildkite_waiter.git", branch: "main"

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
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/buildkite_waiter.bash"
    fish_completion.install "completions/buildkite_waiter.fish"
    zsh_completion.install "completions/_buildkite_waiter"
  end

  test do
    stdout, stderr, status = Open3.capture3(
      "#{bin}/buildkite_waiter by-url https://buildkite.com/my-great-org/my-pipeline/builds/1",
    )

    assert_equal false, status.success?
    assert_equal "", stdout
    assert_match "failed to load access token", stderr
  end
end
