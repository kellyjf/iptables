import struct
import sys
import socket
import signal
import time

signal.signal(signal.SIGINT, signal.SIG_DFL)

def msocket(addr):
	s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.getprotobyname("udp"))
	a1=socket.inet_pton(socket.AF_INET, addr)
	a2=struct.pack("=I",0)
	aa=a1+a2
	b=struct.pack("@i",5)
	s.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, b)
	s.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, aa)
	return s

def runserver(addr):
	svr = msocket(addr)
	svr.bind((addr,5444))
	svr.settimeout(5)
	time.sleep(4)
	while True:
		try:
			msg=svr.recv(128)
			print "MSG: ",msg
		except Exception as e:
			print e

def runclient(addr):
	i = 0
	cln = msocket(addr)
	cln.connect((addr,5444))
	while True:
		i = i+1
		print "Hello %05d"%(i)
		cln.send("Hello %05d"%(i))
		time.sleep(2)

if __name__ == "__main__":
	if len(sys.argv)>1:
		print "Running Server"
		runserver("225.5.5.5")	
	else:
		print "Running Client"
		runclient("225.5.5.5")	
