SD53227 ;ALB/RBS - Print Encounter/Visit Date/Time 421 error ; 10/11/00 5:23pm
 ;;5.3;Scheduling;**227**;AUG 13, 1993
 ;
 ;DBIA Integration Reference # 3211.
 ;
 ;This routine will print a report of Encounters with a 421 error code
 ;(invalid date and time) that can or cannot be cleaned up.
 ;
 ;The ^XTMP global will be used as an audit file of all encounters
 ;that have been fixed and retransmitted to the NPCD.
 ;The purge date will be 30 days from last Cleanup option run.
 ; ^XTMP("SD53P227",0)=STRING of 10 fields
 ;  STRING = purge date^run date^start dt/time^stop dt/time...
 ;           ^option run^last cleanup d/t run^DUZ of user...
 ;           ^tot errors^tot fixed^tot searched
 ; ^XTMP("SD53P227",1)=error node of encounters that can't be fixed
 ; ^XTMP("SD53P227",2)=encounters that can be fixed and re-sent
 ; ^XTMP("SD53P227",3)=e-mail report sent to user
 ; ^XTMP("SD53P227,"SENT")=audit trial of all encounters fixed
 Q
 ;*;
 ;
PRINT ; Print report
 K @SDTEMP@(3)                             ;kill E-mail node
 N DASH,ENCPTR,ERRPTR,GTOT,HEAD1,LINE,SDI,SDL,SDX,STR
 N PAGE,SUBT1,SUBT2,TOTALS,XMITPTR,X,Y
 S (ERRPTR,XMITPTR,ENCPTR,SDX,STR,X,Y)=""
 S (EXIT,GTOT,PAGE,SDL,TOTALS)=0
 D HEAD
 ;
 ; loop thru error and fix nodes to setup report info
 F SDI=1,2 D:$O(@SDTEMP@(SDI,""))'=""  Q:EXIT
 .D HDR(SDI) Q:EXIT
 .F  S ERRPTR=$O(@SDTEMP@(SDI,ERRPTR)) Q:ERRPTR=""  D  Q:EXIT
 ..I ($$S^%ZTLOAD) S EXIT=1 Q
 ..S $P(TOTALS,U,SDI)=$P(TOTALS,U,SDI)+1,GTOT=GTOT+1
 ..F  S XMITPTR=$O(@SDTEMP@(SDI,ERRPTR,XMITPTR)) Q:XMITPTR=""  D  Q:EXIT
 ...F  S ENCPTR=$O(@SDTEMP@(SDI,ERRPTR,XMITPTR,ENCPTR)) Q:ENCPTR=""  D  Q:EXIT
 ....S STR=@SDTEMP@(SDI,ERRPTR,XMITPTR,ENCPTR)
 ....Q:$G(STR)=""
 ....D WRT(STR,SDI)
 ....Q:EXIT
 .D TOTAL(SDI,TOTALS,0)
 .S PAGE=0
 S $P(TOTALS,U,3)=GTOT,PAGE=0
 D HDR(2) Q:EXIT
 D MHDR(2)
 S SUBT1="GRAND TOTALS:"
 W !!,SUBT1,!                             ;write to device
 D XML(""),XML(SUBT1),XML("")             ;write to E-mail
 F SDI=1,2,3 D TOTAL(SDI,TOTALS,1)
 S SUBT1="<End of Report>"
 W !!,SUBT1,!
 D XML(""),XML(SUBT1),XML(DASH)
 Q
 ;
LINE1(STR,SDX) ;Format 1st output line
 S SDX=""
 D XMX(1,$E($P(STR,U,2),1,22)),XMX(25,$P(STR,U,4)),XMX(37,$E($P(STR,U,5),1,20)),XMX(60,$$DT($P(STR,U,6)))
 Q
 ;
LINE2(STR,SDX) ; Format 2nd output line
 S SDX=""
 D XMX(50,"New D/T:"),XMX(60,$$DTT(STR))
 Q
 ;
WRT(STR,SDI) ;Write to screen/device or Add to E-mail report file
 S SDX=""
 I CRT,($Y>(IOSL-5)) D HDR(SDI) Q:EXIT
 D LINE1(STR,.SDX)
 W !,SDX
 D LINE2($P(STR,U,7),.SDX)
 W !,SDX
 Q
 ;
XMX(X,Y) ;Set message text value
 S $E(SDX,X)=Y
 Q
 ;
XML(X) ;Set message text line
 ; ^XTMP("SD53P227",3,#) = E-mail report of all records
 S SDL=SDL+1
 S @SDTEMP@(3,SDL)=X
 Q
 ;
DT(SDDT) ;Format slashed date - (Original date/time with seconds)
 Q $E(SDDT,4,5)_"/"_$E(SDDT,6,7)_"/"_(17+$E(SDDT))_$E(SDDT,2,3)_"@"_$P(SDDT,".",2)
 ;
DTT(SDDT) ;Format slashed date - (New date/time without seconds)
 I $E(SDDT)'?1N Q SDDT      ;error msg's will kick out
 Q $E(SDDT,4,5)_"/"_$E(SDDT,6,7)_"/"_(17+$E(SDDT))_$E(SDDT,2,3)_"@"_$E($P(SDDT,".",2)_"0000",1,4)
 ;
HDR(SDI) ; Print header
 S (SDX,X)=""
 I PAGE,CRT D  Q:EXIT
 .S DIR(0)="E" D ^DIR K DIR
 .I $D(DIRUT)!$D(DTOUT)!$D(DUOUT) S EXIT=1 Q
 .S EXIT='+$G(Y)
 W @IOF
 S PAGE=PAGE+1,X="Page: "_PAGE,SDX=RUNDT,$E(SDX,(80-$L(X)))=X
 W TITLE,!,SDX,!,$S(SDI=1:SUBT1,1:SUBT2),!,HEAD1,!,DASH
 Q
 ;
MHDR(SDI) ; Sets up the Mail msg header
 S (SDX,X)="",X="Page: 1",SDX=RUNDT,$E(SDX,(80-$L(X)))=X
 D XML(""),XML(TITLE),XML(SDX)
 S SDX="",X="Summary of Encounters",$E(SDX,(80-$L(X)\2))=X
 D XML(SDX),XML(DASH)
 Q
 ;
TOTAL(SDI,TOTALS,Y) ; Print out totals
 S X="Total Encounters "
 S X=X_$S(SDI=1:"Unsendable:",SDI=2:"Flagged...:",SDI=3:"Searched..:",1:"")
 S X=X_$J(+$P(TOTALS,U,SDI),10)
 W !,X
 D:Y XML(X)
 Q
 ;
HEAD ; Setup header and sub-header lines
 N X
 S SDTEMP="^XTMP(""SD53P227"")",$P(DASH,"-",80)="",X=TITLE
 S:SDRTYP="R" X=$P(TITLE," & Cleanup")
 S TITLE="",$E(TITLE,(80-$L(X)\2))=X,X=""
 S X="Date Run:  "_$P($$FMTE^XLFDT(TIMESTRT),":",1,2),$E(RUNDT,(80-$L(X)\2))=X,X=""
 S X="Error listing of Encounters not updated"
 S $E(SUBT1,(80-$L(X)\2))=X
 S X="Preview list of Encounters to be updated"
 S:FIX X="Encounters Updated and Flagged for Retransmission"
 S $E(SUBT2,(80-$L(X)\2))=X,X=""
 ;
 D XMX(1,"Patient"),XMX(25,"SSN"),XMX(37,"Location"),XMX(60,"Encounter Date/Time")
 S HEAD1=SDX
 Q
 ;
NOFIND ; Nothing to report
 N DASH,HEAD1,LINE,SDI,SDL,SDX,STR
 N PAGE,SUBT1,SUBT2,X,Y
 S (SDI,SDL,SDX,STR,SUBT1,SUBT2,X,Y)=""
 S (EXIT,PAGE,SDL)=0
 D HEAD,HDR(1)
 K @SDTEMP@(3)                             ;kill E-mail node
 S X="No Outpatient Encounter 421 Error records found."
 W !!,X
 D XML(""),XML(X),XML("")
 S X="<End of Report>"
 W !!,X
 D XML(X),XML("")
 Q
