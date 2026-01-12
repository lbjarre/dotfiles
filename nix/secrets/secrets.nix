let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKO2e6AWSa6JXn4bkk4Ca/xoTu3ZBK11jnS8TCHa9FTN"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJMxtioCDpXJl5xB3t/8wCwC0X5l7rngc4/nZ9beAdR"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHT0U6ZIDOUbw3+Tn3qYeREdoBu+tcQSaLUHa7YrbLHF"
  ];
  # I don't have any specific scoping for which keys can read which secrets so
  # right now I just let all secrets be readable by all keys. This function
  # generates that attribute set for a list of secret names.
  #
  # toAttr :: [ secret ] -> { secret :: { publicKeys = keys; } }
  toAttr =
    secrets:
    let
      value.publicKeys = keys;
      value.armor = true;
      f = name: { inherit name value; };
    in
    builtins.listToAttrs (map f secrets);
in
toAttr [
  "anthropic-key.age"
  "evroc-atlassian-key.age"
  "github-key.age"
  "evroc-gitlab-token.age"
  "evroc-think-devstral.age"
]
