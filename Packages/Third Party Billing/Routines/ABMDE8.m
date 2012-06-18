ABMDE8 ; IHS/ASDST/DMJ - Edit Page 8 - WORKSHEET DATA ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DSD/DMJ - 6/17/98 -  NOIS CKA-0698-110070
 ;            Modified to include more than just room charges on Page 8C
 ;
 ; IHS/SD/SDR - 10/15/02 - V2.5 P2 - 888-0501-N0008
 ;           Modified to put Supplies lock on Charge Master page instead of Medical
 ;
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Modified to allow page 8H to display when vt=998 (dental)
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for new page 8K
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20329
 ;   Display anesthesia page if anesthesia charge on visit
 ;
A ;EP - Entry Point to Page 8A
 S ABMP("LBL")="A",ABMP("LOC")=10,ABMP("SB")=27 G SCRN ;MEDICAL
B ;EP - Entry Point to Page 8B
 S ABMP("LBL")="B",ABMP("LOC")=1,ABMP("SB")=21 G SCRN ;SURGICAL
C ;EP - Entry Point to Page 8C
 S ABMP("LBL")="C",ABMP("LOC")=2,ABMP("SB")=25 G SCRN ;R&B
D ;EP - Entry Point to Page 8D
 S ABMP("LBL")="D",ABMP("LOC")=6,ABMP("SB")=23 G SCRN ;RX
E ;EP - Entry Point to Page 8E
 S ABMP("LBL")="E",ABMP("LOC")=3,ABMP("SB")=37 G SCRN ;LAB
F ;EP - Entry Point to Page 8F
 S ABMP("LBL")="F",ABMP("LOC")=4,ABMP("SB")=35 G SCRN ;XRAY
G ;EP - Entry Point to Page 8G
 S ABMP("LBL")="G",ABMP("LOC")=5,ABMP("SB")=39 G SCRN ;ANESTH
H ;EP - Entry Point to Page 8H
 S ABMP("LBL")="H",ABMP("LOC")=8,ABMP("SB")=43 G SCRN ;MISC
I ;EP - Entry Point to Page 8I
 S ABMP("LBL")="I",ABMP("LOC")=7,ABMP("SB")=33 G SCRN ;DDS
J ;EP - Entry Point to Page 8J
 S ABMP("LBL")="J",ABMP("LOC")=9,ABMP("SB")=45 G SCRN ;SUPPLY
K ;EP - Entry point to page 8K
 S ABMP("LBL")="K",ABMP("LOC")=8,ABMP("SB")=47 G SCRN  ;AMBULANCE
 ;
SCRN K ABM,ABME,DUOUT,DTOUT,DIROUT,DIRUT
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)="A3",("ABCDEFGIJ"[ABMP("LBL")) G CHK
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)'="A3",("K"[ABMP("LBL")) G CHK
 I ABMP("LBL")="G" D CPTLIST^ABMCPTCK(ABMP("CDFN")) I '$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,0)),'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,0)),($O(ABMCPTS(70000),-1)=1) G CHK
 I ABMP("VTYP")=998,"CI"[ABMP("LBL") G CHK
 I $D(ABMP("DDL"))!$D(ABMP("WORKSHEET")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMP("SB"),0)) G CHK
 I ABMP("VTYP")'=111&(ABMP("LBL")="I") G CHK
 I $D(^ABMDPARM(DUZ(2),1,11,ABMP("LOC"))) G CHK
 I ABMP("VTYP")=997,ABMP("LBL")'="D" G CHK
 I ABMP("VTYP")=996,ABMP("LBL")'="E" G CHK
 I ABMP("VTYP")=995,ABMP("LBL")'="F" G CHK
 D @("^ABMDE8"_ABMP("LBL")) W ! S ABMP("OPT")=$S(ABMP("LBL")="B":"ADESVNJBQM",1:"ADEVNJBQM") D SEL^ABMDEOPT
CHK I "AENVSDBM"'[$E(Y) G XIT
 I ABMP("LBL")="K",$E(Y)="N" S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=8!($D(ABMP("WORKSHEET")))) ABMP("QUIT")="" G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(ABMP("LBL")="A"&($E(Y)="B"))
 I $E(Y)="B" S ABMP("LBL")=$C($A(ABMP("LBL"))-1) G @(ABMP("LBL"))
 I $E(Y)="N" S ABMP("LBL")=$C($A(ABMP("LBL"))+1) G @(ABMP("LBL"))
 I $E(Y)="V" S ABM("DO")=$S("AB"[ABMP("LBL"):"^ABMDE5B",ABMP("LBL")="C":"^ABMDE8CA",ABMP("LBL")="E":"^ABMDE8EA",ABMP("LBL")="D":"^ABMDE8DA",1:"V1") D @ABM("DO") G SCRN
 S ABM("DO")=$S($E(Y)="E":"E1^ABMDEMLE",$E(Y)="A":"A1^ABMDEML",$E(Y)="D":"D1^ABMDEMLB",1:"S1^ABMDEMLA")
 N I F I="C","D","J" D
 .I ABMP("LBL")=I,"AE"[$E(Y) S ABM("DO")=$E(Y)_"^ABMDE8"_I
 S:$E(Y)="M" ABM("DO")="MODE"
 D @ABM("DO")
 G SCRN
 ;
V1 S ABMZ("TITL")="PAGE 8 - VIEW OPTION" D SUM^ABMDE1
 D ^ABMDERR
 Q
MODE ;CHANGE MODE OF EXPORT THIS PAGE
 W !
 S DR=$A(ABMP("LBL"))+6
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 D ^DIE
 D EXP^ABMDEVAR
 Q
RBLD ;REBUILD PAGE LINE ITEMS FROM PCC    
 Q
 ;
XIT K ABM,ABMZ,ABME,ABMP("LOC"),ABMP("LBL")
 Q
