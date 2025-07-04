let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKO2e6AWSa6JXn4bkk4Ca/xoTu3ZBK11jnS8TCHa9FTN"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJMxtioCDpXJl5xB3t/8wCwC0X5l7rngc4/nZ9beAdR"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHT0U6ZIDOUbw3+Tn3qYeREdoBu+tcQSaLUHa7YrbLHF"
  ];
in
{
  "anthropic-key.age".publicKeys = keys;
}
