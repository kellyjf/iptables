

ulogd.db : ulog.sql
	sqlite3 $@ < $^

install : ulogd.db
	sudo cp -f ulogd.db /var/log/ulogd
	
sh-% :
	sudo ip netns exec $* bash

run-% :
	sudo ulogd -v -c ./$*.conf

inspect :
	sqlite3 /var/log/ulogd/ulogd.db

clean:
	rm -f ulogd.db
	
