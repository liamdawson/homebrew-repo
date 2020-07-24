class BuildkiteWaiter < Formula
  desc "Notify when a Buildkite build finishes"
  homepage "https://github.com/liamdawson/buildkite_waiter"
  url "https://github.com/liamdawson/buildkite_waiter/archive/v0.1.1.tar.gz"
  sha256 "51927f0d66aae0b4396cc5868d6980ff2f192b5a38738b18bf8bf5a82fd59088"
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
