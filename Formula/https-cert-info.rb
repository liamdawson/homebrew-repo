class HttpsCertInfo < Formula
  desc "View a summary of the HTTPS certificate for a server"
  homepage "https://github.com/liamdawson/https-cert-info"
  url "https://github.com/liamdawson/https-cert-info/archive/v0.1.0.tar.gz"
  sha256 "9a3c54cde53a8ebfebf77a31b6ff9b85fdfc9e4781547a1126da3c7efbbf933e"
  license "Apache-2.0" # or MIT

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
