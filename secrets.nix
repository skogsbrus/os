let
  johanan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINug6YZP5It5utF3UALqq+Wq93Taj+xtzaOMv6qwVfWc contact@skogsbrus.xyz";
  keeper = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrqJCVHXS7bxmyOtRlhR6YzgY6bFqTyrzfctHA+1NBg root@keeper";
  router = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZ7KL8gkdoBcFYF1AJUQgmXn0xUbl02nFYScqCV6kwT root@router";

  user_keys = [ johanan ];
  host_keys = [ keeper router ];
in
{
  "secrets/authelia_cfg_yaml.age".publicKeys = user_keys ++ host_keys;
  "secrets/authelia_users_yaml.age".publicKeys = user_keys ++ host_keys;
}
