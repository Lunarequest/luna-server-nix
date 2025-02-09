{pkgs,config,...}: {
    networking.wg-quick.interfaces = {
        wg0 = {
            address = ["10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64"];
            listenPort = 51820;
            privateKeyFile = "${config.sops.secrets.vpn.path}";

            postUp = ''
                ${pkgs.iptables}
            '';
        };
    };
}
