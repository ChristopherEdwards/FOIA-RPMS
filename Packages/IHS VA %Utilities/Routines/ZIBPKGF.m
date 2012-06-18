ZIBPKGF ; IHS/ADC/GTH - INSTALLATION STATUS REPORT ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 W !!,"EXECUTION UNAUTHORIZED.",!
 Q
 ;
Q2 ;EP - From DIR
 W ! F %=2:1:7 W $P($T(Q2+%),";;",2),!
 ;; This utility reads thru the PACKAGE file for versions and
 ;; dates of installed packages, writes the info to a file,
 ;; and uucp's the file to the area machine and/or a central
 ;; machine, probably cmbsyb.  The info sent to cmbsyb will
 ;; be copied to MailMan for auto processing into the
 ;; Application Implementation Status options.
 Q
 ;
 ; cmbsyb Any Timeplex 9600 .30-30 n:--n:--n: uucpb word: 10sne1
 ; cmbsyb Any ACU 2400 FTS-999-999-9999 n:--n:--n: uucpb word: 10sne1
 ; dpssyg Any Timeplex 9600 .00-15 n:--n:--n: uucpdps word: uucpdps
 ; dpssyg Any ACU2400 FTS-999-999-9999 n:--n:--n: uucpdps word: uucpdps
 ;
OPT ;EP - Set option in OPTION file.
 I $P(^%ZOSF("OS"),"^")'="MSM-UNIX" W !!,"SORRY.  MSM-UNIX only.",! Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 D HOME^%ZIS,DT^DICRW,00:'$L($P(^AUTTSITE(1,0),U,14)),Q2
 NEW DA,DIC,DIE,DIR,DR
 S Y=1,%="Enter a number to choose the systems to which you want this report sent"
 I $L($P(^AUTTSITE(1,0),U,14)) S DIR(0)="N^1:3:0",DIR("A")="Send reports to (1) "_$P($T(SYTM),";;",2)_" (2) "_$P(^(0),U,14)_" or (3) both",DIR("B")=3,DIR("?")=%,DIR("??")="^D Q2^ZIBPKGF" D ^DIR Q:$D(DIRUT)
 S DIC="^DIC(19,",DIC(0)="",X="ZIB INSTALLATION STATUS REPORT",DIC("DR")="1///Installation Status Report;4///R;20///I "_Y_";25///START^ZIBPKGF;200///T@2110;202///25D"
 I $D(^DIC(19,"B",X)) S DIE=DIC,DA=$O(^DIC(19,"B",X,0)),DR="20///I "_Y D ^DIE I 1
 E  KILL DD,DO D FILE^DICN
 W !!,"Done."
 Q
 ;
START ;EP - From TaskMan.
 ; A = Area System Name
 ; D = Date Package Installed
 ; F = File Name
 ; I = HFS Name
 ; L = Location ASUFAC
 ; M = System Name to Receive all Reports
 ; P = Package Prefix
 ; R = Directory
 ; S = Short Description of Package
 ; S(1) = 1st Subscript in PACKAGE
 ; S(2) = 22 node Subscript in PACKAGE
 ; V = Version of Package
 ;
 NEW %ZIS,A,D,DA,DIC,F,I,J,L,M,N,P,R,S,V
 ;
 S R="/usr/spool/uucppublic/",L=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)
 F I=0:0 S I=$O(^%ZIS(1,I)) Q:'I  I ^(I,"TYPE")="HFS" S IOP=$P(^%ZIS(1,I,0),U) D ZIS Q:'POP
 Q:POP!('I)
 S I=$P(^%ZIS(1,I,0),U)
 KILL ^TMP($J)
 ;
 ; rm xmit files over 2 weeks old.
 ;
 S X=$$JOBWAIT^%HOSTCMD("ls -l "_R_"pkg"_L_".* > /usr/mumps/zibpkg.wrk"),IOP=I,%ZIS("IOPAR")="(""/usr/mumps/zibpkg.wrk"":""R"")"
 D ZIS,JDT
 U IO
 F  R %:300 Q:%=""  S %=$P(%,"/",5),X=+$P(%,".",2) I %?1"pkg"6N1"."3N,L=$E(%,4,9),((+X>+J)!(+X<(+J-14))) S X=$$JOBWAIT^%HOSTCMD("rm "_R_%)
 S X=$$JOBWAIT^%HOSTCMD("rm /usr/mumps/zibpkg.wrk")
 ; Initialize namespace, systems, and frequency.
 S %=+$P(^DIC(19,$O(^DIC(19,"B","ZIB INSTALLATION STATUS REPORT",0)),20)," ",2)
 I %>1 S A=$P(^AUTTSITE(1,0),U,14)
 I '(%=2) S M=$P($T(SYTM),";;",2)
 ;
 S F="/usr/spool/uucppublic/pkg"_L_"."_J,IOP=I,%ZIS("IOPAR")="("""_F_""":""W"")"
 D ZIS
 U IO
 S P=""
MAIN ;
 F  S P=$O(^DIC(9.4,"C",P)) Q:P=""  D  W L,U,P,U,S,U,V,U,D,!
 .S (S,V,D)="error",S(1)=$O(^DIC(9.4,"C",P,0))
 .Q:'S(1)
 .S S=$P(^DIC(9.4,S(1),0),U,3)
 .S:S="" S="error"
 .Q:'$D(^DIC(9.4,S(1),"VERSION"))
 .S V=^DIC(9.4,S(1),"VERSION")
 .I '$L(V) S V="error" Q
 .S S(2)=$O(^DIC(9.4,S(1),22,"B",V,0))
 .Q:'S(2)
 .S D=$P(^DIC(9.4,S(1),22,S(2),0),U,3)
 .Q
ENDMAIN ;
 S IOP=I,%ZIS("IOPAR")="(""zib.wrk"")"
 D ZIS,ZISC
 S X=$$JOBWAIT^%HOSTCMD("rm zib.wrk")
 I $D(M) S X=$$JOBWAIT^%HOSTCMD("uucp -r "_F_" "_M_"!~")
 I $D(A) S X=$$JOBWAIT^%HOSTCMD("uucp -r -nroot "_F_" "_A_"!~")
 S ZTREQ="@"
Q ;
 Q
 ;
JDT NEW X1,X2 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S X=X+1,X="00"_X,J=$E(X,$L(X)-2,$L(X)) Q
SYTM ;;cmbsyb
ZIS NEW A,D,F,I,J,L,M,P,R,S,V D ^%ZIS Q
ZISC NEW A,D,F,I,J,L,M,P,R,S,V D ^%ZISC Q
10 ;;abr-ab
11 ;;bji-ao
20 ;;albisc
30 ;;akarea
40 ;;bilcsy
50 ;;okc-ao
51 ;;nsa-oa
60 ;;phx-ao
61 ;;cao-as
70 ;;pordps
80 ;;nav-aa
00 ;;tucdev
 NEW DIE,DR,DA
 S DR="W $J("""",IOM-$L(%)\2)_%,!!"
 S DA=$P($T(@($P(^AUTTAREA($P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,4),0),U,2))),";;",2)
 W !
 F %="A system id for your area computer does not exist in the RPMS SITE file.","Based on your area code, it should probably be '"_DA_"'.","Please enter an area system id into the RPMS SITE file, now.","(Calling DIE for you)." X DR
 S DIE="^AUTTSITE(",DR=".14//"_DA,DA=1
 D ^DIE
 Q
 ;
