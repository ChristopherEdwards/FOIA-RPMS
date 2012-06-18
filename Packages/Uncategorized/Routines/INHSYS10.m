INHSYS10 ;SLT,JPD,WOM; 20 Oct 95 16:03;GIS system configuration compilation/installation utility; program split from INHSYS 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1992 SAIC
 Q
LOOP(INUT,INREPRT,INDELETE) ;
 ; Input:
 ;  INUT - Routine to run and Transaction file name
 ;  INREPRT - 0 - No report
 ;            1 - Report
 ;  INDELETE - If 0/not passed/string then delete
 ;                    IBxxxxW,IBxxxxnn programs
 ;             else do not delete programs
 ;Loop through PASS1 and PASS2
 N %PASS,%LFILES,AA,%SAV
 K ^UTILITY($J),^UTILITY("INHSYS",$J),^UTILITY("INHSYSUT",$J)
 S %DRVR=$P(INUT," -"),INDELETE=+$G(INDELETE)
 X "D EN^@%DRVR"   ;used eXecute so that ^TCQ program does not crash!
 I $D(^UTILITY("INHSYS")),'$$LOCKFL^INHSYSUT(.INLKFLS) D
 .F %PASS=1:1:2 D INST^INHSYS05(%DRVR,.%PASS,INREPRT) Q:INPOP
 .Q:INPOP  D PASS3^INHSYS06
 .Q:INPOP  D PASS4^INHSYS06
 E  S INPOP=1
 ;Unlock files/Clean up ^UTILITY/Remove IB routines
 S AA="" F  S AA=$O(INLKFLS(AA)) Q:AA=""  D UNLK^INHSYSUT(AA)
 K ^UTILITY($J),^UTILITY("INHSYS",$J),^UTILITY("INHSYSUT",$J)
 D:'INDELETE RMRTN^INHUT3($E(%DRVR,1,$L(%DRVR)-1))
 D ALLSUMER^INHSYS11()  ;if error summary is requested, display it on the user's current device
 ;
 W !!,"File transfer ",$S('INPOP:"completed.",1:"aborted!")
 Q
RUN(INREPRT,INSELTT) ;
 ; Input:
 ; INREPRT - 0 - No report
 ;           1 - Report
 ; INSELTT -Array of selected files
 ;
 N INORDR,INROU K ^UTILITY($J),^UTILITY("SVD",$J),^UTILITY("INHSYS",$J)
 S INORDR=""
 F  S INORDR=$O(INSELTT(INORDR)) Q:'INORDR  D PARSE(INSELTT(INORDR),.INROU,INREPRT) Q:INPOP
 Q:INPOP  I $D(INROU) D
 .D NTRNL^INHSYS04(.INROU,$E($O(INROU(""),-1),1,6)_"W")
 .I INREPRT,$E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 Q
PARSE(INPTT,INROU,INREPRT) ;begin data collection for a transaction type
 ;input:
 ;  INPTT - ien^.01 parent transaction type from INTERFACE
 ;            TRANSACTION TYPE file
 ;  INREPRT - 0 - No report
 ;            1 - Report
 ;output:
 ;  INROU - array of compiled routines where INROU(routine)=""
 ;          Must be passed by referrence as the second parameter
 ;
 ;set global with file numbers
 I INREPRT D HEAD^INHSYS03(1)
 ;
 ;build storage buffer with transaction type data
 D XTRK^INHSYS01(+INPTT,"^INRHT(","^UTILITY($J,4000,",4000,INREPRT,0)
 I INPOP K ^UTILITY($J) Q
 ;
 I INREPRT,$E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 ;
 ;resolve all pointer relationships (ien to .01)
 D EXPAND^INHSYS03(INREPRT) Q:INPOP
 ;
 I INREPRT,$E(IOST)="C",INCR W $$RPTFOOT^INHUT5,@IOF
 ;
 ;format data into a routine
 D RTNBFR^INHSYS04(+INPTT,.INROU)
 Q
