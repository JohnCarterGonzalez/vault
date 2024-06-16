{ pkgs
, lib
, config
, inputs
, ...
}: {
  packages = with pkgs; [ nodePackages.prettier marksman ];

  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    prettier = {
      enable = true;
      fail_fast = true;
      description = "Prettier - Code Formatter";
      entry = "prettier --write";
      files = "\\.md$"; # Match all .md files
      settings = {
        configPath = ".prettirrc";
        embedded-language-formatting = "auto";
        parser = "markdown";
        print-width = 80;
        prose-wrap = "always"; # Wrap prose to print width
        single-quote = false; # Use double quotes
        trailing-comma = "all"; # Print trailing commas wherever possible
        tab-width = 2; # Number of spaces per indentation-level
        use-tabs = false; # Indent with spaces instead of tabs
      };
    };
  };
}
