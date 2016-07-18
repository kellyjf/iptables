select oob_time_sec,oob_time_usec,printf("%x",oob_protocol),ip_protocol,ip_id,ip_saddr_str,ip_daddr_str,oob_prefix from pkt order by oob_time_sec,oob_time_usec;
