{...}: {
  services.soju = {
    enable = true;
    hostName = "luna_silly_irc_bouncer";
    tlsCertificate = "/var/certs/foxgirl.cert";
    tlsCertificateKey = "/var/certs/foxgirl.key";
  };
}
