set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf
        $ns flush-trace
        close $nf
        exec nam out.nam &
        exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms SFQ

$ns duplex-link-op $n2 $n3 queuePos 2

set udp [new Agent/UDP]
$udp set class_ 1
$ns attach-agent $n0 $udp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n1 $tcp

set ftp [new Application/FTP] 
$ftp attach-agent $tcp

set sink [new Agent/TCPSink] 
$ns attach-agent $n3 $sink

$ns connect $udp $null
$ns connect $tcp $sink

$ns at 0.3 "$cbr start"
$ns at 0.4 "$ftp start"
$ns at 2.0 "$cbr stop"
$ns at 2.5 "$ftp stop"
$ns at 3.0 "finish"

$ns run
