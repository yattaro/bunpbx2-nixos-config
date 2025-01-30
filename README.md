# bunpbx2
## reproducible Asterisk PBX configuration for voip.ms

Required configuration

secrets.nix
```nix
{
  asterisk.did_number = ""; # DID phone number
  asterisk.sip_server = ""; # domain name of SIP gateway
  asterisk.sip_server_ip = ""; # IP of SIP gateway
  asterisk.sip_user = "";
  asterisk.sip_pass = "";
}
```

TODO: integrate with some form of secrets manager rather than plaintext
