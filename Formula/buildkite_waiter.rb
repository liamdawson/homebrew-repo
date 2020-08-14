class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/v0.2.1.tar.gz"
  sha256 "28fcc99b5f556dc0a46349ec7db291c855819d23bd398fbfe785a3cdb30fc022"
  license "Apache-2.0" # or MIT

  depends_on "rust" => :build

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
    system "#{bin}/program", "help"
  end
end
