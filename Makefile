

ulogd.db : ulog.sql
	sqlite3 $@ < $^

