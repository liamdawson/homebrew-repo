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
    root_url "https://github.com/liamdawson/homebrew-repo/releases/download/buildkite_waiter-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "d4f2c53c4a69757a2458dc3117c11c54f9de1395159e525ae5e11052d93d6312"
    sha256 cellar: :any_skip_relocation, ventura:      "8a2bf2c0a311a4ab88983029d3bc56d1bcb7ed175a9164605f7bc53e987a2292"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "48c358467292969ac345ab49d3037c34d22df7c53d7925be7c0f11690039ef87"
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
