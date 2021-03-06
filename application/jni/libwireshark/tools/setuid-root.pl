#!/usr/bin/perl -w
#
# setuid-root - Enable/disable setuid for tshark and dumpcap.
#
# $Id: setuid-root.pl.in 22736 2007-08-30 04:16:11Z gerald $
#
# Copyright 2007, Luis Ontanon and Gerald Combs
#
# Wireshark - Network traffic analyzer
# By Gerald Combs <gerald@wireshark.org>
# Copyright 1998 Gerald Combs
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

sub usage() {
  die <<FIN
Usage: $0 {enable|disable} [revert owner]

Examples:
  $0 enable		# Changes owner to root and enables setuid
  $0 disable		# Changes owner to \$SUDO_USER and disables setuid
  $0 disable kurtv	# Changes owner to kurtv and disables setuid
FIN
}

$< == 0 or die "only root can run this script";

$bin_prefix = "/usr/local/bin";

if ($#ARGV < 0) { usage(); }

$command = shift;
$command =~ tr/A-Z/a-z/;

$tshark_bin = "tshark";
$dumpcap_bin = "";

die "Don't know prefix path" if length($bin_prefix) < 1;
die "Don't know tshark binary name" if length($tshark_bin) < 1;
die "Don't know dumpcap binary name" if length($dumpcap_bin) < 1;

$revert_owner = "";
if ($#ARGV >= 0) {
  $revert_owner = shift;
}

if (length($revert_owner) < 1 && length($ENV{SUDO_USER}) > 0) {
  $revert_owner = $ENV{SUDO_USER};
}

if ($command eq "enable") {
  system("chown root $bin_prefix/$tshark_bin");
  system("chown root $bin_prefix/$dumpcap_bin");
  system("chmod ug+s $bin_prefix/$tshark_bin");
  system("chmod ug+s $bin_prefix/$dumpcap_bin");
  exit 0;
} 

if ($command eq "disable"){
  system("chmod ug-s $bin_prefix/$tshark_bin");
  system("chmod ug-s $bin_prefix/$dumpcap_bin");
  die "Can't revert owner" if length($revert_owner) < 1;
  system("chown $revert_owner $bin_prefix/$tshark_bin");
  system("chown $revert_owner $bin_prefix/$dumpcap_bin");
  exit(0);
}

usage();
