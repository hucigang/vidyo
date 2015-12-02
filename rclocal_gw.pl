#!/usr/bin/perl -w
use strict;

my $gw=<<DDDD
gw=`grep gateway /etc/network/interfaces | awk ‘{print \$NF}’`
route delete -net 0.0.0.0
route add -net 0.0.0.0 gw \$gw
DDDD
;


open (RCLOCAL, "/etc/rc.local") || die "open /etc/rc.local failed";
open (TMPLOCAL, ">/tmp/rc.local") || die "open /tmp/rc.local failed";

while (<RCLOCAL>){
        if ($_ =~ /^exit/){
            print TMPLOCAL $gw;
            print TMPLOCAL $_;
        }else{
            print TMPLOCAL $_;
        }
}

close(RCLOCAL);
close(TMPLOCAL);


copy ("/tmp/rc.local", "/etc/rc.local");
