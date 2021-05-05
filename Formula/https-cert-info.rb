class HttpsCertInfo < Formula
  desc "View a summary of the HTTPS certificate for a server"
  homepage "https://github.com/liamdawson/https-cert-info"
  url "https://github.com/liamdawson/https-cert-info/archive/v0.1.0.tar.gz"
  sha256 "9a3c54cde53a8ebfebf77a31b6ff9b85fdfc9e4781547a1126da3c7efbbf933e"
  license "Apache-2.0"
  head "https://github.com/liamdawson/https-cert-info.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://dl.bintray.com/liamdawson/bottles-repo"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "39c3ffd4bc0ddfd2f17a20ec0fb1022474c7897bd8effe1c8df0fa409984618e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "222090b5dd5a1b69d77520206d283fbb5e8f1221c23bb5be03014a09e7113323"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/https-cert-info-*/out"].first
    bash_completion.install "#{out_dir}/https-cert-info.bash"
    fish_completion.install "#{out_dir}/https-cert-info.fish"
    zsh_completion.install "#{out_dir}/_https-cert-info"
  end

  test do
    output = shell_output("#{bin}/https-cert-info tls-v1-2.badssl.com 1012")

    assert_match "badssl.com", output
  end
end
