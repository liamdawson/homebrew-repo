class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/v0.2.1.tar.gz"
  sha256 "28fcc99b5f556dc0a46349ec7db291c855819d23bd398fbfe785a3cdb30fc022"
  license "Apache-2.0" # or MIT
  head "https://github.com/liamdawson/buildkite_waiter.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://dl.bintray.com/liamdawson/bottles-repo"
    sha256 cellar: :any_skip_relocation, catalina:     "09c24fcf5c1df4433df64fc071af24f0a7111c5f86c6ef41b7b32ee18def0daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c25b894613a517e5b76c691bb283075bd50fd937676f6af08819017d0ed33fc5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "openssl@1.1"

  def install
    cd "buildkite_waiter" do
      system "cargo", "install", *std_cargo_args
    end

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
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
