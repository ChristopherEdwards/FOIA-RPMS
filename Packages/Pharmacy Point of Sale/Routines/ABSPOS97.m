ABSPOS97 ; IHS/FCS/DRS - MSM Win NT 4.40 busted! ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; This routine demonstrates the problem:
 W !,"TESTING $$ AND ERRORS",!
 W "Testing on ",$ZV,!
 K X
 W "Now we call $$SUBROU",!
 S X=$$SUBROU(1)
 W "Back from call to $$SUBROU with $D(X)=",$D(X)
 I $D(X) W ", X=",X,!
 Q
SUBROU(ARG)        ;
 W !,"Now in SUBROU with ARG=",ARG,!
 ; This $$NEWTRAP doesn't seem to help
 ;I $$NEWTRAP N $ESTACK S $ECODE="",$ETRAP="Q:$Q 0 Q"
 W "$Q=",$Q,!
 N X S X="TRAP^"_$T(+0)
 S @^%ZOSF("TRAP")
 ;S $ZT="TRAP^"_$T(+0)
 W "And $ZT=",$ZT,!
 W "^%ZOSF(""TRAP"")=",^%ZOSF("TRAP"),!
 W "And now we make an error happen:",!
 X $T(+1)
 W "SHOULD NOT REACH THIS LINE!!!!",!
 Q 1
TRAP() W "At the error trap",!
 W "$Q=",$Q,!
 Q:$Q 2 Q
NEWTRAP()          ; do you need the new error trapping?
 N X S X=$ZV
 N Y S Y="MSM for Windows NT, Version "
 I X'[Y Q 0
 S X=$P(X,Y,2)
 S X=$P(X,".",1,2)
 Q X'<4.4 ; v4.4 and up needs it
