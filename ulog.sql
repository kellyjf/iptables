drop table if exists ct;

CREATE TABLE ct (
			flow_start_sec		INT UNSIGNED,
			flow_start_usec		INT UNSIGNED,
			flow_end_sec		INT UNSIGNED,
			flow_end_usec		INT UNSIGNED,
			orig_ip_saddr		INT UNSIGNED,
			orig_ip_daddr		INT UNSIGNED,
			orig_l4_sport		SMALLINT UNSIGNED,
			orig_l4_dport		SMALLINT UNSIGNED,
			orig_ip_protocol	TINYINT UNSIGNED,
			icmp_type		TINYINT UNSIGNED,
			icmp_code		TINYINT UNSIGNED,
			orig_raw_pktlen		INT UNSIGNED,
			orig_raw_pktcount	INT UNSIGNED,
			reply_raw_pktlen	INT UNSIGNED,
			reply_raw_pktcount	INT UNSIGNED,
			ct_mark			INT UNSIGNED
		);
drop table if exists pkt;
CREATE TABLE pkt (
			oob_time_sec		INT UNSIGNED,
			oob_time_usec		INT UNSIGNED,
			oob_in			VARCHAR(20),
			oob_out			VARCHAR(20),
			oob_protocol		SMALLINT UNSIGNED,
			ip_saddr_str		VARCHAR(20),
			ip_daddr_str		VARCHAR(20),
			ip_id			SMALLINT UNSIGNED,
			ip_protocol		TINYINT UNSIGNED,
			oob_prefix		VARCHAR(64),
			oob_mark		INT UNSIGNED,
			tcp_sport		SMALLINT UNSIGNED,
			tcp_dport		SMALLINT UNSIGNED,
			udp_sport		SMALLINT UNSIGNED,
			udp_dport		SMALLINT UNSIGNED,
			icmp_type		TINYINT UNSIGNED,
			icmp_code		TINYINT UNSIGNED,
			arp_saddr		INT UNSIGNED,
			arp_daddr		INT UNSIGNED,
			raw_pktlen		INT UNSIGNED,
			raw_pktcount		INT UNSIGNED,
			oob_uid			INT UNSIGNED
		);
