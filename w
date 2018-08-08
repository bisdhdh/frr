
Problem summery :
To avoid running of the second instance of a FRR daemon, if it is already running. 
https://github.com/FRRouting/frr/issues/2680

Solution :
The following procedures would be performed : 
1.	Verify if the pid file for each daemon is present or not.  If the file is not present, that means the daemon is getting instantiated for the first time. So let it go ahead.  If the file is present proceed to point ‘2’.
2.	Try fetching the properties of the pid file
3.	If it has RW lock, that means one instance of this the daemon is already running. So stop moving ahead and do exit() else let it go ahead.


Please note all above procedure happen at the initial state of daemon’s instantiation, much before it starts any session with other process/allocates resources etc.. and this verification do not have any impact of any operations done later, if the verification succeeds.


I had covered these daemons :

1.	Bgpd
2.	Eigrpd
3.	Isisd
4.	Ldpd
5.	Nhrpd
6.	Ospf6d
7.	Prbd
8.	Ospfd
9.	Ripd
10.	Ripngd
11.	Zebrad
12.	pimd

Daemons that are not covered are :
1.	babled  
2.	sharpd  
3.	watchfrrd  


Test Cases run   :-
root@dev:/var/run/frr# ls -lrt *.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 zebra.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 bgpd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 ripd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 ripngd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 ospfd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 ospf6d.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 isisd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 pimd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 ldpd.pid
-rw-r--r-- 1 root frr  6 Aug  8 02:04 nhrpd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 eigrpd.pid
-rw-r--r-- 1 frr  frr  6 Aug  8 02:04 pbrd.pid
-rw-r--r-- 1 root root 6 Aug  8 02:04 watchfrr.pid

root@dev:/var/run/frr# lsof *.pid
COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
zebra    13138  frr   11uW  REG   0,16        6  241 zebra.pid
bgpd     13145  frr   11uW  REG   0,16        6  634 bgpd.pid
ripd     13156  frr    7uW  REG   0,16        6  636 ripd.pid
ripngd   13164  frr    7uW  REG   0,16        6  638 ripngd.pid
ospfd    13172  frr    8uW  REG   0,16        6  640 ospfd.pid
ospf6d   13180  frr    8uW  REG   0,16        6  642 ospf6d.pid
isisd    13188  frr    7uW  REG   0,16        6  645 isisd.pid
pimd     13196  frr    8uW  REG   0,16        6  667 pimd.pid
ldpd     13207  frr   11uW  REG   0,16        6  678 ldpd.pid
nhrpd    13215  frr   10uW  REG   0,16        6  681 nhrpd.pid
eigrpd   13224  frr    7uW  REG   0,16        6  683 eigrpd.pid
pbrd     13232  frr    7uW  REG   0,16        6  685 pbrd.pid
watchfrr 13240 root    7uW  REG   0,16        6  689 watchfrr.pid

root@dev:/var/run/frr# ps -elf | grep frr
Warning: /boot/System.map-4.4.36-nn3-server not parseable as a System.map
0 T root      2068  2065  0  80   0 -  6280      - 01:49 pts/2    00:00:00 editor /root/frr/.git/COMMIT_EDITMSG
5 S frr      13138     1  0  75  -5 - 275138 ffffff 02:04 ?       00:00:00 /usr/lib/frr/zebra -s 90000000 --daemon -A 127.0.0.1
5 S frr      13145     1  0  75  -5 - 49529 ffffff 02:04 ?        00:00:00 /usr/lib/frr/bgpd --daemon -A 127.0.0.1
5 S frr      13156     1  0  75  -5 - 11781      - 02:04 ?        00:00:00 /usr/lib/frr/ripd --daemon -A 127.0.0.1
5 S frr      13164     1  0  75  -5 - 11744      - 02:04 ?        00:00:00 /usr/lib/frr/ripngd --daemon -A ::1
5 S frr      13172     1  0  75  -5 - 12036      - 02:04 ?        00:00:00 /usr/lib/frr/ospfd --daemon -A 127.0.0.1
5 S frr      13180     1  0  75  -5 - 11882      - 02:04 ?        00:00:00 /usr/lib/frr/ospf6d --daemon -A ::1
5 S frr      13188     1  0  75  -5 - 11846      - 02:04 ?        00:00:00 /usr/lib/frr/isisd --daemon -A 127.0.0.1
5 S frr      13196     1  0  75  -5 - 11959      - 02:04 ?        00:00:00 /usr/lib/frr/pimd --daemon -A 127.0.0.1
4 S frr      13205     1  0  75  -5 - 11201      - 02:04 ?        00:00:00 /usr/lib/frr/ldpd -L
4 S frr      13206     1  0  75  -5 - 11238      - 02:04 ?        00:00:00 /usr/lib/frr/ldpd -E
5 S frr      13207     1  0  75  -5 - 11957      - 02:04 ?        00:00:00 /usr/lib/frr/ldpd --daemon -A 127.0.0.1
5 S frr      13215     1  0  75  -5 - 12382      - 02:04 ?        00:00:00 /usr/lib/frr/nhrpd --daemon -A 127.0.0.1
5 S frr      13224     1  0  75  -5 - 11783      - 02:04 ?        00:00:00 /usr/lib/frr/eigrpd --daemon -A 127.0.0.1
5 S frr      13232     1  0  75  -5 - 11701      - 02:04 ?        00:00:00 /usr/lib/frr/pbrd --daemon -A 127.0.0.1
5 S root     13240     1  0  75  -5 - 11041      - 02:04 ?        00:00:01 /usr/lib/frr/watchfrr -d -r /usr/sbin/servicebBfrrbBrestartbB%s -s /usr/sbin/servicebBfrrbBstartbB%s -k /usr/sbin/servicebBfrrbBstopbB%s -b bB zebra bgpd ripd ripngd ospfd ospf6d isisd pimd ldpd nhrpd eigrpd pbrd
0 S root     13356  9819  0  80   0 -  3556      - 02:34 pts/0    00:00:00 grep --color=auto frr


root@dev:/var/run/frr# cat ospfd.pid 
13172
root@dev:/var/run/frr# cat ospf6d.pid 
13180
root@dev:/var/run/frr# 

root@dev:/usr/lib/frr# ./ospfd 
2018/08/08 02:31:06 unknown: Process 13172 has a write lock on file /var/run/frr/ospfd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./bgpd 
2018/08/08 02:31:12 unknown: Process 13145 has a write lock on file /var/run/frr/bgpd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./eigrpd 
2018/08/08 02:31:18 unknown: Process 13224 has a write lock on file /var/run/frr/eigrpd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./ospf6d 
2018/08/08 02:31:24 unknown: Process 13180 has a write lock on file /var/run/frr/ospf6d.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./ldpd 
2018/08/08 02:31:29 unknown: Process 13207 has a write lock on file /var/run/frr/ldpd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./pimd 
2018/08/08 02:31:45 unknown: Process 13196 has a write lock on file /var/run/frr/pimd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./pbrd 
2018/08/08 02:31:55 unknown: Process 13232 has a write lock on file /var/run/frr/pbrd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./ripd 
2018/08/08 02:32:00 unknown: Process 13156 has a write lock on file /var/run/frr/ripd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./ripngd 
2018/08/08 02:32:09 unknown: Process 13164 has a write lock on file /var/run/frr/ripngd.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./zebra 
2018/08/08 02:32:17 unknown: Process 13138 has a write lock on file /var/run/frr/zebra.pid already! Error :( No such file or directory) 

root@dev:/usr/lib/frr# ./nhrpd 
2018/08/08 02:32:21 unknown: Process 13215 has a write lock on file /var/run/frr/nhrpd.pid already! Error :( No such file or directory) 

