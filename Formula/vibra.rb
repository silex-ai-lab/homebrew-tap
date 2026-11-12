class Vibra < Formula
  desc "Menu bar monitor for local AI coding agents"
  homepage "https://github.com/silex-ai-lab/silex_vibra"
  url "https://github.com/silex-ai-lab/silex_vibra/archive/35fdc057c900029df2811eee2aeb3516b41706e0.tar.gz"
  version "0.4.2"
  sha256 "793bd77037cf6d99c4ed1b31aa8a31117ecf9de58e723e607066cc2f40fc5ce8"
  license "Apache-2.0"

  depends_on macos: :sonoma

  def install
    # Homebrew already sandboxes the build; SwiftPM cannot nest another sandbox.
    inreplace "Makefile", "swift build -c", "swift build --disable-sandbox -c"
    system "make", "app", "SIGN_IDENTITY="
    prefix.install "build/Vibra.app"
    (bin/"vibra").write_env_script opt_prefix/"Vibra.app/Contents/MacOS/Vibra", {}
  end

  def caveats
    <<~EOS
      Launch the menu bar app with:
        open #{opt_prefix}/Vibra.app

      Query agent status with:
        vibra --query

      Quit any older Vibra copy before launching this one. This formula does
      not replace /Applications/Vibra.app or change login items.

      This source build is ad-hoc signed, not Developer ID signed or notarized.
      macOS may require Automation approval again after an upgrade.
      Notifications may be unavailable with ad-hoc signing.
    EOS
  end

  test do
    ENV["VIBRA_HOME"] = testpath.to_s
    output = JSON.parse(shell_output("#{bin}/vibra --query"))
    assert_equal [], output.fetch("sessions")
    assert_kind_of Hash, output.fetch("settings")
    assert_match(/\A\d{4}-\d{2}-\d{2}T/, output.fetch("generatedAt"))
    assert_match "authorization:", shell_output("#{bin}/vibra --notifications")
    system "/usr/bin/codesign", "--verify", "--deep", "--strict", prefix/"Vibra.app"
    plist = prefix/"Vibra.app/Contents/Info.plist"
    app_version = shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' #{plist}").strip
    assert_equal version.to_s, app_version
  end
end
