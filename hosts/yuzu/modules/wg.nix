{
  pkgs,
  config,
  ...
}: {
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.65.233.103/32" "fc00:bbbb:bbbb:bb01::2:e966/128"];
      listenPort = 51820;
      privateKeyFile = "/run/secrets/wg";
      dns = ["100.64.0.4"];

      peers = [
        {
          publicKey = "bZQF7VRDRK/JUJ8L6EFzF/zRw2tsqMRk6FesGtTgsC0=";
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "138.199.43.91:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
