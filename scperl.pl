use IO::Socket;


$socket = new IO::Socket::INET ( PeerAddr  => 'localhost', PeerPort  =>  7890, Proto => 'tcp', )
or die "Couldn't connect to Server\n";
sub ChekcsumCalc {
    $i = 0;
    $S = 0;
    $temp = 0;
    $Size = length($_[0]);
    while ($i < $Size) {
        $temp += ord($_[0]);
        $i++;
    }
    return $temp;
}
 $option = 1;
 $sum = 0;
while ($option == 1)
{
    $sum = 0;
    $f0 = ""; $f1 = ""; $f2 = ""; $f3 = ""; $f4 = ""; $f5 = "";
    $f = "";
    print "\n Select your action:\n [u]=Sensor     [r]=Observer \n";
	$x = <STDIN>;
    if ($x == 'u') {
        $f0 = "U";
        $sum += ChekcsumCalc($f0);
        print "Insert Sensor NAME:\n";
        $f1 = <STDIN>;
        chop($f1);
        while (not length($f1) == 8) {
            if (length($f1) > 8) {
                print "\nNAME Can't be longer than 8 Characters\n";
                $f1 = <STDIN>;
                chop($f1);
            }else{
                if (length($f1) < 8) {
                    $f1 = $f1.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f1);
        print "Insert Sensor Data:\n";
        $f2 = <STDIN>;
        chop($f2);
        while (not length($f2) == 8) {
            if (length($f2) > 8) {
                print "\nData can't exceed 8 characters\n";
                $f2 = <STDIN>;
                chop($f2);
            }else{
                if (length($f2) < 8) {
                    $f2 = $f2.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f2);
        print "Insert Time(HHMMSS):\n";
        $f3 = <STDIN>;
        chop($f3);
        while (not length($f3) == 6) {
            if (length($f3) > 6) {
                print "TIME Can't exceed 6 characters:";
                $f3 = <STDIN>;
                chop($f3);
            }else{
                if (length($f3) < 6) {
                    $f3 = $f3.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f3);
        print "Insert DATE(DDMMYYYY):\n";
        $f4 = <STDIN>;
        chop($f4);
        while (not length($f4) == 8) {
            if (length($f4) > 8) {
                print "\nDATE Can't exceed 8 characters:\n";
                $f4 = <STDIN>;
                chop($f4);
            }else{
                if (length($f4) < 8) {
                    $f4 = $f4.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f4);
        $f5 = "$sum";
        $f = $f0.$f1.$f2.$f3.$f4.$f5;
        $socket->send($f);
        $socket->recv($recv_data,2048);
        print $recv_data;
    } else {
        if($x == 'r'){
        $sum = 0;
        $f0 = "R";
        print "\nInsert Observer NAME:\n";
        $f1 = <STDIN>;
        chop($f1);
        while (not length($f1) == 8) {
            if (length($f1) > 8) {
                print "\nNAME Can't exceed 8 characters\n";
                $f1 = <STDIN>;
                chop($f1);
            }else{
                if (length($f1) < 8) {
                    $f1 = $f1.' ';
                }
            }
        }
        print "Insert Sensor NAME:\n";
        $f2 = <STDIN>;
        chop($f2);
        while (not length($f2) == 8) {
            if (length($f2) > 8) {
                print "\nSensor NAME can't exceed 8 characters\n";
                $f2 = <STDIN>;
                chop($f2);
            }else{
                if (length($f2) < 8) {
                    $f2 = $f2.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f0); $sum += ChekcsumCalc($f1); $sum += ChekcsumCalc($f2); $f3 = "$sum";
        $f = $f0.$f1.$f2.$f3;
        $socket->send($f);
        $socket->recv($recv_data,2048);
        $f1 = substr($recv_data,0,7); $f2 = substr($recv_data,9,8); $f3 = substr($recv_data,18,6); $f4 = substr($recv_data,25,8);
        print "\n";
        print "Sensor Name: ";
        print $f1;
        print "\n";
        print "DATA: ";
        print $f2;
        print "\n";
        print "Tegistry Time: ";
        print $f3;
        print "\n";
        print "Registry Date: ";
        print $f4;
        }
    }
    print "\n";
    print "Press [1] to continue or any key other key to exit:\n";
    $option = <STDIN>;
}
