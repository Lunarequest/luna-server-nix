{...}: {
  boot.kernel.sysctl = {
    "kernel.sysrq" = 0;
    "kernel.kptr_restrict" = 1;
    "kernel.dmesg_restrict" = 1;
    "kernel.perf_event_paranoid" = 2;
    "fs.protected_fifos" = 2;

    "vm.dirty_ratio" = 25;
    "vm.dirty_background_bytes" = 268435456; # 256MiB
    "vm.dirty_expire_centisecs" = 1500;
    "vm.dirty_writeback_centisecs" = 500;

    "net.core.default_qdisc" = "fq";

    "net.ipv6.conf.all.use_tempaddr" = 1; # prefer public addr when SLAA
    #"net.ipv6.conf.default.use_tempaddr" = 1; # as opposed to temporary
    "net.ipv6.conf.all.addr_gen_mode" = 3; # stable random address when link-local
    "net.ipv6.conf.default.addr_gen_mode" = 3; # as opposed to MAC based

    # these tcp options affect both IPv4 and IPv6
    "net.ipv4.tcp_fin_timeout" = 10; # timeout for FIN
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_keepalive_time" = 300; # seconds till first keepalive probe
    "net.ipv4.tcp_keepalive_intvl" = 30; # no reply? send new probe every 30 seconds
    "net.ipv4.tcp_keepalive_probes" = 2; # try 2 times aka until 60 seconds later

    "net.ipv4.tcp_shrink_window" = 1;
    "net.ipv4.tcp_rmem" = "8192 1048576 8388608";
    "net.ipv4.tcp_wmem" = "4096 8192 16777216";
    "net.ipv4.tcp_notsent_lowat" = 8388608;

    # disable flawed features
    "kernel.sched_autogroup_enabled" = 0;
    "vm.watermark_boost_factor" = 0;
    "net.ipv4.tcp_tw_reuse" = 0;

    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;

    # make sure Wireguard, HTTP/3 and QUIC transports are happy
    "net.core.rmem_max" = 26214400; # 25MB
    "net.core.rmem_default" = 2097152; # 2MB
    "net.core.wmem_max" = 26214400; # 25MB

    # these tcp options affect both IPv4 and IPv6
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_probe_threshold" = 32; # mtu probing granularity
    "net.ipv4.tcp_base_mss" = 1240; # mtu probing start, we assume at least MTU 1280
    "net.ipv4.tcp_min_snd_mss" = 456; # RFC879#section-7 and no ATM
    "net.ipv4.tcp_ecn" = 0; # disable ECN since most networks don't support this properly
    "net.ipv4.tcp_fastopen" = 0; # disable fastopen. no browser uses it, privacy issues.
    "net.ipv4.tcp_thin_linear_timeouts" = 1;
  };
}
