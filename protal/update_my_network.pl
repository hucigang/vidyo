#!/usr/bin/perl -w
use strict;
use File::Copy;

my $status = 0;
open (RCLOCAL, "/etc/rc.local") || die "open /etc/rc.local failed";
open (TMPLOCAL, ">/tmp/rc.local") || die "open /tmp/rc.local failed";

my $portal2_3=<<AAAA
ifconfig eth0 down
ifconfig eth0 hw ether bc:ae:c5:3f:ad:ed
ifconfig eth0 up
ifconfig eth1 down
ifconfig eth1 hw ether bc:ae:c5:3f:ad:25
ifconfig eth1 up
AAAA
;

my $portal3_0=<<CCCC
CCCC
;

my $portal3_1=<<BBBB
ifconfig eth0 down
ifconfig eth0 hw ether d4:ae:52:cf:b5:58
ifconfig eth0 up
ifconfig eth1 down
ifconfig eth1 hw ether d4:ae:52:cf:b5:59
ifconfig eth1 up
BBBB
;

while (<RCLOCAL>){
	if ($_ =~ /updateKeyStore/){
		print TMPLOCAL $_;
		$status = 1;
	}
	if ($_ =~ /\/opt\/vidyo\/setupnetwork.sh/){
		$status = 0;
	}

	if ($status eq 1){
		print TMPLOCAL $portal3_1;
		$status = -1;
	}else{
		print TMPLOCAL $_ if ($status eq 0);
	}
}

close(TMPLOCAL);
close(RCLOCAL);
unlink("/etc/udev/rules.d/70-persistent-net.rules") if (-e "/etc/udev/rules.d/70-persistent-net.rules");
copy ("/tmp/rc.local", "/etc/rc.local");


if [ 1 == 0 ]; then
my $vidyo_ip_file = "/opt/vidyo/conf.d/eth0.conf";

my $ip = `ifconfig eth0 | grep "inet " | grep -oE '([0-9]{1,3}\.?){4} ' | head -n 1 | sed -e s'/ //g'`;
my $mask = `ifconfig eth0 | grep "inet " | grep -oE '([0-9]{1,3}\.?){4} ' | head -n 2 | tail -n 1 | sed -e s'/ //g'`;
my $gw = `ip route show | grep default | cut -d" " -f3`;

chomp($ip);
chomp($mask);
chomp($gw);

print "[".$ip."]\n";
my @tmpfiles = split('/', $vidyo_ip_file);
my $tmpfile = "/tmp/".$tmpfiles[$#tmpfiles];
open (IPFILE, $vidyo_ip_file) || die "open $vidyo_ip_file failed";
open (TMPIPFILE, ">$tmpfile") || die "open $tmpfile failed";
while(<IPFILE>){
	if ($_ =~ m/IPV4_ADDRESS/){
		print TMPIPFILE "IPV4_ADDRESS=".$ip."\n";
	}elsif ($_ =~ m/IPV4_ADDRESS/){
	}elsif ($_ =~ m/IPV4_ADDRESS/){
	}else{
		print TMPIPFILE $_;
	}
}
close (IPFILE);
close (TMPIPFILE);

copy ($tmpfile, $vidyo_ip_file);

exec("cat /etc/hostname > /proc/sys/kernel/hostname");
fi
