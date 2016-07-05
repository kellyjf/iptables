

ulogd.db : ulog.sql
	sqlite3 $@ < $^

install : ulogd.db
	sudo cp -f ulogd.db /var/log/ulog
	
sh-% :
	sudo ip netns exec $* bash

run-% :
	sudo ulogd -v -c ./$*.conf

inspect :
	sqlite3 /var/run/ulog/ulogd.db

clean:
	rm -f ulogd.db
	
