
help:
	@echo "Makefile targets       ";\
	echo  "-----------------------";\
	echo  "install     Build sqlite3 database for log gathering";\
	echo  "run-ulogd   Gather traces to sqlite3 database";\
	echo  "run-pcap    Gather traces to pcap files";\
	echo  "sql         Start sqlite3 console on DB"
 

ulogd.db : ulog.sql
	sqlite3 $@ < $^

install : ulogd.db
	sudo cp -f ulogd.db /var/log/ulogd
	
sh-% :
	sudo ip netns exec $* bash

run-% :
	sudo ulogd -v -c ./$*.conf

x-% :
	sudo ip netns exec $* bash -c "xterm -T $*"

sql :
	sqlite3 /var/log/ulogd/ulogd.db

clean:
	rm -f ulogd.db mcjoin
	
