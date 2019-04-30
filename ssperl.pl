use IO::Socket;

$| = 1;

$socket = new IO::Socket::INET (LocalHost => 'localhost', LocalPort => '7890', Proto => 'tcp', Listen => 5, Reuse => 1 );

die "Couldn't open socket" unless $socket;

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
print "\nWaiting...";
while(1)
{
	$client_socket = "";
	$client_socket = $socket->accept();
	$peer_address = $client_socket->peerhost();
	$peer_port = $client_socket->peerport();

	print "\n New Connection from: ( $peer_address , $peer_port ) ";

	 while (1)
	 {
	 	$i = 1;
		$s = 0;
		$cadena = "";
		$f0 = "";	$f1 = "";	$f2 = "";	$f3 = "";	$f4 = "";	$f5 = "";
		$F = "";
		$aux2 = "";

		$client_socket->recv($recieved_data,2048);
		$f0 = substr($recieved_data,0,1);
		if ($f0 eq "U") {
			print "\nSensor\n";
			$f1 = substr($recieved_data,1,8);	$f2 = substr($recieved_data,9,8);	$f3 = substr($recieved_data,17,6);	$f4 = substr($recieved_data,23,8); $f5 = substr($recieved_data,31,4);
			$s += ChekcsumCalc($f0); $s += ChekcsumCalc($f1); $s += ChekcsumCalc($f2); $s += ChekcsumCalc($f3); $s += ChekcsumCalc($f4);
			if ($s == $f5) {
				$F = $f1.','.$f2.','.$f3.','.$f4;
				print $F;
				print "\n";
				if (-e "sensor.txt") {
					open(WRITE, ">> sensor.txt") || die "Error al crearse el archivo: $!";
					print WRITE $F;	print WRITE "\n";
					close(WRITE);
				} else {
					open(WRITE, "> sensor.txt") || die "Error al crearse el archivo: $!";
					print WRITE $F;	print WRITE "\n";
					close(WRITE);
				}
				$send_data = "Success";
				$client_socket->send($send_data);
			}

		} else {
			if ($f0 eq "R") {
				print "\n Observer";
				$f1 = substr($recieved_data,1,8); $f2 = substr($recieved_data,9,8); $f3 = substr($recieved_data,17,4);
				$s += ChekcsumCalc($f0); $s += ChekcsumCalc($f1); $s += ChekcsumCalc($f2);
				if ($s == $f3) {
				print "\nLos cheksum son iguales\n";
				$F = $f1.','.$f2;
				print $F;
				print "\n";
				if (-e "observer.txt") {
					open(WRITE, ">> observer.txt") || die "Unable to create File $!";
					print WRITE $F;	print WRITE "\n";
					close(WRITE);
				} else {
					open(WRITE, "> observer.txt") || die "Unable to create File $!";
					print WRITE $F;	print WRITE "\n";
					close(WRITE);
				}
				$sent = 0;
				if (-e "sensor.txt") {
					open(READ, "sensor.txt");
					while(<READ>){
						$aux = substr($_,0,8);
						if ($f2 eq $aux) {
							$send_data = $_;
							$sent = 1;
						}
					}
					if ($sent == 1) {
						print "Success";
						$client_socket->send($send_data);
					} else {
						print "Not Found";
						$client_socket->send("Data not Found");
					}
				} else {
					$send_data = "ERROR FILE NOT FOUND";
					$client_socket->send($send_data);
				}
			}
			}
		}
	}
}
