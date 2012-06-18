ZIBRPI1 ; IHS/ADC/GTH - REMOTE PATCH INSTALLATION (1) ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 W !!,"EXECUTION UNAUTHORIZED.",!
 Q
 ;
OPT ;EP - Set option in OPTION file.
 I $P(^%ZOSF("OS"),"^")'["MSM" W !!,"SORRY.  MSM only.",! Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 D HOME^%ZIS,DT^DICRW,00:'$L($P(^AUTTSITE(1,0),U,14))
 NEW ZIB,ZIBAREA,D,DA,DIC,DIE,DR,I,O,POP,W
 D HFS
 I POP W !,"HFS not available." Q
 D OS,HELP^ZIBRPI2("GEN")
 S Y=1,%="Enter a number to choose the systems to which you want this report sent"
 I $L($P(^AUTTSITE(1,0),U,14)) S DIR(0)="N^1:3:0",DIR("A")="Send reports to (1) "_$P($T(SYTM),";;",2)_" (2) "_$P(^(0),U,14)_" or (3) both",DIR("B")=2,DIR("?")=%,DIR("??")="^D HELP^ZIBRPI2(""SYSID"")" D DIR I $D(DIRUT) D ZISC Q
 KILL DIR
 S ZIBAREA="20///I "_Y
 S DIR(0)="F^1:245",DIR("A")="From what "_$P(O,U)_" directory do you want to restore patches",DIR("?")="Enter the full path name of a directory",DIR("??")="^D HELP^ZIBRPI2(""DIRECT"")"
 S:D("IN")]"" DIR("B")=D("IN")
 ; The following line is non-standard M because of the Q:$L(X)
 F  D DIR Q:$D(DIRUT)  D HC(O("LS")_Y_"* > "_W) S IOP=I,%ZIS("IOPAR")="("""_W_""":""R"")" D ZIS U IO R X:300 U IO(0) Q:$L(X)  W "  Directory does not exist (or empty).",*7
 S D=Y
 D ZISC
 Q:$D(DIRUT)
 S ZIBAREA=ZIBAREA_" S:0 %="""_D
 S (DIR(0),DIR("B"))="Y",DIR("A")="If action routine '(A/B)9<pkg><patch#>' exists, do you want it ran",DIR("??")="^D HELP^ZIBRPI2(""ACTION"")"
 D DIR
 Q:$D(DIRUT)
 S ZIBAREA=ZIBAREA_U_Y_""""
 S DIC="^DIC(19,",DIC(0)="",X="ZIB REMOTE PATCH INSTALLATION",DIC("DR")="1///Remote Patch Installation;4///R;"_ZIBAREA_";25///START^ZIBRPI;200///T@2315;202///1D"
 F ZIB="ZIB REMOTE PATCH INSTALLATION","AZHL REMOTE PATCH INSTALLATION" I $D(^DIC(19,"B",ZIB)) S DIE=DIC,DA=$O(^DIC(19,"B",ZIB,0)),DR=".01///"_X_";"_ZIBAREA_";25///START^ZIBRPI" D DIE I 1 Q
 E  D FILE
 W !!,"Done."
 Q
 ;
DIE NEW D,E,F,I,J,L,N,O,P,V,W D ^DIE Q
DIR NEW D,E,F,I,J,L,N,O,P,V,W D ^DIR Q
FILE NEW D,E,F,I,J,L,N,O,P,V,W KILL DD,DO D FILE^DICN Q
HC(%) NEW D,E,F,I,J,L,N,O,P,V,W S %=$$JOBWAIT^%HOSTCMD(%) Q
XMD NEW D,E,F,I,J,L,N,O,P,V,W D ^XMD Q
ZIS NEW D,E,F,I,J,L,N,O,P,V,W D ^%ZIS Q
ZISC NEW D,E,F,I,J,L,N,O,P,V,W D ^%ZISC Q
 ;
HFS ;
 F I=0:0 S I=$O(^%ZIS(1,I)) Q:'I  I ^(I,"TYPE")="HFS" S IOP=$P(^%ZIS(1,I,0),U),%ZIS("IOPAR")="(""/usr/spool/uucppublic/work.zib"":""W"")" D ZIS Q:'POP
 I 'I,'$D(POP) S POP=1
 Q:POP
 S I=$P(^%ZIS(1,I,0),U)
 Q
 ;
OS ;
 S O=$P($P(^%ZOSF("OS"),","),"-",2)
 S O("PF")=$P($T(PATTERN^ZIBRPI),";",3)
 S W=$P($T(WORK^ZIBRPI),";",3)
 I O["UNIX" S (D("IN"),D("OUT"))=$P($T(PUB^ZIBRPI),";",3),O("RM")="rm ",O("LS")="ls -l ",W=D("OUT")_W Q
 S %=$G(^AUTTSITE(1,1)),D("IN")=$P(%,U),D("OUT")=$P(%,U,2),O("RM")="DEL ",O("LS")="DIR /B "
 Q
 ;
SYTM ;;dpssyg
10 ;;abr-ab
11 ;;bji-ao
20 ;;albisc
30 ;;akarea
40 ;;bilcsy
50 ;;okc-ao
51 ;;nsa-oa
61 ;;cao-as
60 ;;phx-ao
70 ;;pordps
80 ;;nav-aa
00 ;;tucdev
 NEW DIE,DR,DA
 S DA=$P($T(@($P(^AUTTAREA($P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,4),0),U,2))),";;",2),DR="W $J("""",IOM-$L(X)\2)_X,!!"
 W !!
 F X="A system id for your area computer does not exist in the RPMS SITE file.","Based on your area code, it should probably be '"_DA_"'.","Please enter an area system id into the RPMS SITE file, now.","(Calling DIE for you)." X DR
 S DIE="^AUTTSITE(",DR=".14//"_DA,DA=1
 D DIE
 Q
