#!/usr/bin/perl
use IO::Socket;
#//*Autor: Raul Ernesto Perez Barcenas*//
#//*Matricula: 148661*//
#//*Version: 1.0*//
#//*Asignatura: Programacion Integrativa (UACJ)*//
$socket = new IO::Socket::INET ( PeerAddr  => 'localhost', PeerPort  =>  7890, Proto => 'tcp', )
or die "No se pudo conectar al server.\n";
sub ChekcsumCalc 
{
    $i = 0;
    $S = 0;
    $temp = 0;
    $Size = length($_[0]);
    while ($i < $Size) 
    {
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
    print "\n Selecciona tu opcion:\n [U]=Sensor UPDATE     [R]=Observador REQUEST \n";
	$x = <STDIN>;
    if ($x == 'u'||$x == 'U') 
    {
        $f0 = "U";
        $sum += ChekcsumCalc($f0);
        print "Ingrese el nombre del sensor (max. 8 caract.):\n";
        $f1 = <STDIN>;
        chop($f1);
        while (not length($f1) == 8) 
	{
            if (length($f1) > 8) 
	    {
                print "\nEl nombre no puede ser de mas de 8 caracteres!\n";
                $f1 = <STDIN>;
                chop($f1);
            }
	    else
	    {
                if (length($f1) < 8) 
		{
                    $f1 = $f1.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f1);
        print "Ingrese los datos del sensor:\n";
        $f2 = <STDIN>;
        chop($f2);
        while (not length($f2) == 8) 
	{
            if (length($f2) > 8) 
	    {
                print "\nLos datos no pueden sobrepasar los 8 caracteres!\n";
                $f2 = <STDIN>;
                chop($f2);
            }
	    else
	    {
                if (length($f2) < 8) 
		{
                    $f2 = $f2.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f2);
        print "Capture el tiempo en el siguiente formato (HHMMSS):\n";
        $f3 = <STDIN>;
        chop($f3);
        while (not length($f3) == 6) 
	{
            if (length($f3) > 6) 
	    {
                print "El tiempo no puede exceder los 6 caracteres!";
                $f3 = <STDIN>;
                chop($f3);
            }
	    else
	    {
                if (length($f3) < 6) 
		{
                    $f3 = $f3.' ';
                }
            }
        }
        $sum += ChekcsumCalc($f3);
        print "Capture la fecha en el formato (DDMMYYYY):\n";
        $f4 = <STDIN>;
        chop($f4);
        while (not length($f4) == 8) 
	{
            if (length($f4) > 8) 
	    {
                print "\nLa fecha no puede exceder los 8 caracteres:\n";
                $f4 = <STDIN>;
                chop($f4);
            }
	    else
	    {
                if (length($f4) < 8) 
		{
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
    }
    else 
    {
        if($x == 'r'||$x == 'R')
	{
		$sum = 0;
		$f0 = "R";
		print "\nIngrese el nombre del observador:\n";
		$f1 = <STDIN>;
		chop($f1);
        while (not length($f1) == 8) 
	{
            if (length($f1) > 8) 
	    {
                print "\nEl nombre no puede exceder los 8 caracteres!\n";
                $f1 = <STDIN>;
                chop($f1);
            }
	    else
	    {
                if (length($f1) < 8) 
		{
                    $f1 = $f1.' ';
                }
            }
        }
        print "Ingrese el nombre del sensor (8 carac. max.):\n";
        $f2 = <STDIN>;
        chop($f2);
        while (not length($f2) == 8) 
	{
            if (length($f2) > 8) 
	    {
                print "\nEl nombre del sensor no puede exceder 8 caracteres!\n";
                $f2 = <STDIN>;
                chop($f2);
            }
	    else
	    {
                if (length($f2) < 8) 
		{
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
        print "Nombre sensor: ";
        print $f1;
        print "\n";
        print "Datos: ";
        print $f2;
        print "\n";
        print "Tiempo: ";
        print $f3;
        print "\n";
        print "Fecha: ";
        print $f4;
        }
    }
    print "\n";
    print "Presione (1) para continuar o cualquier otra tecla para salir.\n";
    $option = <STDIN>;
}
