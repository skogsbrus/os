let
  johanan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINug6YZP5It5utF3UALqq+Wq93Taj+xtzaOMv6qwVfWc contact@skogsbrus.xyz";
  keeper = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrqJCVHXS7bxmyOtRlhR6YzgY6bFqTyrzfctHA+1NBg root@keeper";
  router = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZ7KL8gkdoBcFYF1AJUQgmXn0xUbl02nFYScqCV6kwT root@router";
  keeper2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGM23/K1hDtf6weSQbfuhLnMpg54KIumxlu+hQXxyKe0 root@keeper";

  user_keys = [ johanan ];
  host_keys = [ keeper2 router ];
in
{
  "secrets/authelia_cfg_yaml.age".publicKeys = user_keys ++ host_keys;
  "secrets/authelia_users_yaml.age".publicKeys = user_keys ++ host_keys;
  "secrets/nullmailer_remotes.age".publicKeys = user_keys ++ host_keys;
  "secrets/backblaze_b2_backup_prod_rclone_config.age".publicKeys = user_keys ++ host_keys;
  "secrets/morot.age".publicKeys = user_keys ++ host_keys;
  "secrets/icecreamiscream.age".publicKeys = user_keys ++ host_keys;
  "secrets/cybercorp.age".publicKeys = user_keys ++ host_keys;
}
