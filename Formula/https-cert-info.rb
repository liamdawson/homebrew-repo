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
    root_url "https://github.com/liamdawson/homebrew-repo/releases/download/https-cert-info-0.1.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "66a857cc3ddc93bef65372a994fa7ae0f93bd6e9baeb09d936fcf5c96b203e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1031f5b287de5f44bf5ea314832056a2b07060463ef94f3722681d59580e997c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts and manpage are generated in the crate's build directory, which includes a fingerprint hash.
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
