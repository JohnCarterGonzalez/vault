{ pkgs
, lib
, config
, inputs
, ...
}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.marksman ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    mdl = {
      enable = true;
      fail_fast = true;
      description = "Markdown Linter";
      entry = "mdl";
      files = "\\.md$";
      settings = {
        configPath = ".mdlrc"; # Path to the mdl configuration file
        json = true; # Format output as JSON
        verbose = true; # Increase verbosity
        warnings = true; # Show Kramdown warnings
      };
    };
  };
}
