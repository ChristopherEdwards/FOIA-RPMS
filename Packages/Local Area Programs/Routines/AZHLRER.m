AZHLRER ; DSM/GTH - REMOTE ERROR REPORTING ;  [ 04/07/93  1:01 PM ]
 ;;1.9X;DSM REMOTE ERROR REPORTING;;FEB 19, 1993
 ;
 I $P(^%ZOSF("OS"),"^")'="MSM-UNIX" W !!,"SORRY.  MSM-UNIX only.",! Q
 W *7,!?10,"Please read the internal documentation in this routine",!?10,"before running the utility."
 Q
 ;
 ; Read thru ^UTILITY("%ER", extracting errors from the past
 ; AZHLFREQ days for selected namespace(s).  Write the errors to a
 ; unix file, with abbreviated global notation, pack the unix
 ; file, and uucp to a user at the identified destination.
 ; uucp to systems, according to parameter (ENTRY ACTION of option).
 ; Remove errors in ^("%ER" more than 180 days old.
 ;
 ; This routine is non-interactive.  It is designed to run in
 ; background from TaskMan, only.
 ;
 ; Entry point OPT is used to set an option into the OPTION file,
 ; which is scheduled for each day at 6 PM, which begins the process
 ; at START.  The value of the argument of the IF statement in the
 ; ENTRY ACTION of the option determines if the errors get sent to
 ; (1) system id at SYTM; (2) area office, or (3) both.
 ;
 ; Use entry point DEOPT to unschedule the option in the OPTION
 ; file set with entry point OPT.
 ;
 ; cmbsyb Any Timeplex 9600 .30-30 n:--n:--n: uucpb word: 10sne1
 ; cmbsyb Any ACU 2400 FTS-999-999-9999 n:--n:--n: uucpb word: 10sne1
 ; dpssyg Any Timeplex 9600 .00-15 n:--n:--n: uucpdps word: uucpdps
 ; dpssyg Any ACU2400 FTS-999-999-9999 n:--n:--n: uucpdps word: uucpdps
 ;
OPT ;EP - Set option in OPTION file.
 I $P(^%ZOSF("OS"),"^")'="MSM-UNIX" W !!,"SORRY.  MSM-UNIX only.",! Q
 S:'$D(DUZ(0)) DUZ(0)="@" D HOME^%ZIS,DT^DICRW,00:'$L($P(^AUTTSITE(1,0),U,14))
 NEW AZHLAREA,AZHLSYTM,DA,DIC,DIE,DR S AZHLSYTM=$P($T(SYTM),";;",2),%=1
 I $L($P(^AUTTSITE(1,0),U,14)) F  D  Q:(%=U)!(0<%&(4>%))
 .W !,"Do you want the errors sent to :",!?10,"1.  ",AZHLSYTM," only",!?10,"2.  ",$P(^(0),U,14)," only",!?10,"3.  both",?40,"=> " R %:DTIME
 .I '$T!(%[U) S %=U Q
 .S %=+% I %<1!(%>3) W *7," ??   1, 2, or 3, please.",!!
 .Q
 Q:%=U  S AZHLAREA="20///I "_%
 S DIC="^DIC(19,",DIC(0)="",X="AZHL REMOTE ERROR REPORTING",DIC("DR")="1///Remote Error Reporting;4///R;"_AZHLAREA_";25///START^AZHLRER;200///T@1800;202///1D"
 I $D(^DIC(19,"B",X)) S DIE=DIC,DA=$O(^DIC(19,"B",X,0)),DR=AZHLAREA D ^DIE I 1
 E  K DD,DO D FILE^DICN
 W !!,"Done."
 Q
 ;
START ;EP - From TaskMan.
 ; Open a HFS.  QUIT if unsuccessful.
 NEW AZHLIOP
 F AZHLIOP=0:0 S AZHLIOP=$O(^%ZIS(1,AZHLIOP)) Q:'AZHLIOP  I ^(AZHLIOP,"TYPE")="HFS" S IOP=$P(^%ZIS(1,AZHLIOP,0),U) D ^%ZIS Q:'POP
 Q:POP!('AZHLIOP)  S AZHLIOP=$P(^%ZIS(1,AZHLIOP,0),U)
 ;
 NEW AZHL,AZHLAREA,AZHLFILE,AZHLFREQ,AZHLJUDT,AZHLLOC,AZHLNMSP,AZHLSYTM,C,D,E,F,G,I,V,Y
 ; rm xmit files over 2 weeks old.
 S AZHLLOC=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10),X=$$JOBWAIT^%HOSTCMD("ls -l /usr/spool/uucppublic/*"_$E(AZHLLOC,3,6)_"z* > azhlrer.wrk"),IOP=AZHLIOP,%ZIS("IOPAR")="(""azhlrer.wrk"":""R"")" D ^%ZIS,JDT U IO
 F  R % Q:%=""  S %=$P(%,"/",5),X=+$E(%,$F(%,"z"),$F(%,"z")+2) I ((%?2.4U4N1"z"3N.1".z")!(%?1"%"4N1"z"3N.1".z")),$E(AZHLLOC,3,6)=$E(%,$F(%,"z")-5,$F(%,"z")-2),((+X>+AZHLJUDT)!(+X<(+AZHLJUDT-14))) D
 . S X=$$JOBWAIT^%HOSTCMD("rm /usr/spool/uucppublic/"_%)
 . Q
 S X=$$JOBWAIT^%HOSTCMD("rm azhlrer.wrk")
 ; Set C x-ref with namespaces not in PACKAGE file.
 F %=2:1 Q:$P($T(C),U,%)=""  I '$D(^DIC(9.4,"C",$P($T(C),U,%))) S ^DIC(9.4,"C",$P($T(C),U,%),0)=""
 ; Initialize namespace, systems, and frequency.
 S AZHLNMSP="",%=0+$P(^DIC(19,$O(^DIC(19,"B","AZHL REMOTE ERROR REPORTING",0)),20)," ",2)
 I %>1 S AZHLAREA=$P(^AUTTSITE(1,0),U,14)
 I '(%=2) S AZHLSYTM=$P($T(SYTM),";;",2)
 S AZHLFREQ=$P(^DIC(19,$O(^DIC(19,"B","AZHL REMOTE ERROR REPORTING",0)),200),U,3),AZHLFREQ=+AZHLFREQ*$S(AZHLFREQ["S":0,AZHLFREQ["H":0,AZHLFREQ["M":30,1:1) I AZHLFREQ<1 S AZHLFREQ=1
 K ^TMP($J)
MAIN ;
 F  S AZHLNMSP=$O(^DIC(9.4,"C",AZHLNMSP)) Q:(AZHLNMSP="")!POP  D
 .S AZHLFILE="/usr/spool/uucppublic/"_AZHLNMSP_$E(AZHLLOC,3,6)_"z"_AZHLJUDT
 .; KILL single-char vars before call to %ZIS.
 .KILL C,D,E,F,G,I,V,Y
 .; Open specific file.
 .S IOP=AZHLIOP,%ZIS("IOPAR")="("""_AZHLFILE_""":""W"")" D ^%ZIS
 .Q:POP  U IO
 .; Get version and date installed.
 .S V="none",I=$O(^DIC(9.4,"C",AZHLNMSP,0)) I I S V=$S($D(^DIC(9.4,I,"VERSION")):^("VERSION"),1:"unk"),%=$O(^DIC(9.4,I,22,"B",V,0)) I % S I=$P(^DIC(9.4,I,22,%,0),U,3)
 .W ?5,"<<< BEGIN '",AZHLNMSP,"' v ",V,", ",I,", REMOTE ERROR REPORTING FOR '",AZHLLOC,"' >>>",!
 .; $O thru ^("%ER" for last AZHLFREQ days.
 .S C=+$H-AZHLFREQ-1,Y=0 F  S C=$O(^UTILITY("%ER",C)) Q:'C  S D=^(C,0) F E=1:1:D I $E($P($P(^UTILITY("%ER",C,E,0),U,2),":"),1,$L(AZHLNMSP))=AZHLNMSP S Y=1 D
 ..; Record 9 system vars.
 ..F F=0:1:9 I $D(^UTILITY("%ER",C,E,F)) W "^(,"_C_","_E_","_F_")=",^(F),!
 ..; Record routine's patch piece.
 ..S X=$P($P(^UTILITY("%ER",C,E,0),U,2),":") X ^%ZOSF("TEST") I  X "ZL @X S %=$T(+2)" W "^(,"_C_","_E_",10)=PATCH PIECE=",$P(%,";",5),!
 ..; Record application vars.
 ..I $D(^UTILITY("%ER",C,E,100)) S G=^(100) F F=100:1:G+100 W "^(,"_C_","_E_","_F_")=",^(F),!
 ..Q
 .; If no errors found for ns, rm file and quit to next $O.
 .I 'Y S X=$$JOBWAIT^%HOSTCMD("rm "_AZHLFILE) Q
 .W ?5,">>> END '",AZHLNMSP,"' REMOTE ERROR REPORTING FOR '",AZHLLOC,"' <<<",!
 .S ^TMP($J,"RER",AZHLFILE)=""
 .Q
ENDMAIN ;
 KILL C,D,E,F,G,I,V,Y S IOP=AZHLIOP,%ZIS("IOPAR")="(""azhlrer.wrk"":""W"")" D ^%ZIS,^%ZISC S X=$$JOBWAIT^%HOSTCMD("rm azhlrer.wrk")
 ; pack files and uucp to appropriate sys ids.
 S AZHLFILE="" F  S AZHLFILE=$O(^TMP($J,"RER",AZHLFILE)) Q:AZHLFILE=""  D
 .S X=$$JOBWAIT^%HOSTCMD("pack "_AZHLFILE)
 .I $D(AZHLSYTM) S X=$$JOBWAIT^%HOSTCMD("uucp -r "_AZHLFILE_".z "_AZHLSYTM_"!~"),X=$$JOBWAIT^%HOSTCMD("uucp -r "_AZHLFILE_" "_AZHLSYTM_"!~")
 .I $D(AZHLAREA) S X=$$JOBWAIT^%HOSTCMD("uucp -r "_AZHLFILE_".z "_AZHLAREA_"!~"),X=$$JOBWAIT^%HOSTCMD("uucp -r "_AZHLFILE_" "_AZHLAREA_"!~")
 .Q
 ; Remove non-PACKAGE namespaces from C x-ref.
 F %=2:1 Q:$P($T(C),U,%)=""  K ^DIC(9.4,"C",$P($T(C),U,%),0)
 ; Remove entries from ^("%ER" more than 180 days old.
 F %=0:0 S %=$O(^UTILITY("%ER",%)) Q:('%)!((+$H-%)<180)  K ^(%)
 K ^TMP($J) S ZTREQ="@"
Q Q
 ;
JDT S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S X=X+1,X="00"_X,AZHLJUDT=$E(X,$L(X)-2,$L(X)) Q
C ;;^%^DI^XB^XQ^ZIB^ZU
SYTM ;;cmbsyb
10 ;;abr-ab
30 ;;akarea
20 ;;albtrn
40 ;;bilcsy
11 ;;bji-ao
61 ;;cao-as
80 ;;nav-aa
51 ;;nsa-oa
50 ;;okc-ao
60 ;;phx-ed
70 ;;pordps
00 ;;tucdev
 NEW DIE,DR,DA S DR="W $J("""",IOM-$L(X)\2)_X,!!"
 S DA=$P($T(@($P(^AUTTAREA($P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,4),0),U,2))),";;",2) W !
 F X="A system id for your area computer does not exist in the RPMS SITE file.","Based on your area code, it should probably be '"_DA_"'.","Please enter an area system id into the RPMS SITE file, now.","(Calling DIE for you)." X DR
 S DIE="^AUTTSITE(",DR=".14//"_DA,DA=1 D ^DIE
 Q
