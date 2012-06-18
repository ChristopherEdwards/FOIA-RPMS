BWRPSNP ;IHS/ANMC/MWR - REPORT: SNAPSHOT OF PROGRAM ;15-Feb-2003 22:10;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW PRINT SNAPSHOT" TO DISPLAY FROM 1/1 CURRENT
 ;;  YEAR TO PRESENT #PATIENTS, #PAPS, #MAMS, #DELINQUENT NEEDS, ETC.
 ;
 D SETVARS^BWUTL5 S BWFAC=DUZ(2)
 N A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S,X,Y
 D TITLE^BWUTL5("PROGRAM SNAPSHOT")
 D ASKSAVE G:BWPOP EXIT
 D DEVICE  G:BWPOP EXIT
 D GATHER
 D:BWA STORE
 D ^BWRPSNP1
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="DEQUEUE^BWRPSNP"
 F BWSV="A","FAC" D
 .I $D(@("BW"_BWSV)) S ZTSAVE("BW"_BWSV)=""
 D ZIS^BWUTL2(.BWPOP,1,"HOME")
 Q
 ;
ASKSAVE ;EP
 ;---> ASK IF THIS REPORT SHOULD BE SAVED FOR LATER RETRIEVAL.
 N DIR,DIRUT,Y
 W !!?3,"Should today's Snapshot be stored for later retrieval and"
 W " comparisons?"
 S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 S BWA=0 D HELP1
 D ^DIR K DIR W !
 S:$D(DIRUT) BWPOP=1
 S:Y BWA=1
 Q
 ;
DEQUEUE ;EP
 ;---> QUEUED REPORT
 N A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S,X,Y
 D SETVARS^BWUTL5,GATHER,STORE,^BWRPSNP1,EXIT
 Q
 ;
STORE ;EP
 ;---> STORE REPORT DATA IN FILE #9002086.71.
 Q:'BWA
 N BWDR,BWI,DA,DIC,DIE,X,Y
 S BWDR=".02////"_BWFAC,Y=.02
 F BWI=A,B,C,D,E,F,G,H,S,J,K,L,P,Q,R D
 .S Y=Y+.01,BWDR=BWDR_";"_Y_"////"_BWI
 N A,B,C,D,E,F,G,H,S,J,K,L,P,Q,R D
 .D DIC^BWFMAN(9002086.71,"ML",.Y,"","","",BWDT)
 .Q:Y<0
 .D DIE^BWFMAN(9002086.71,BWDR,+Y)
 Q
 ;
 ;
GATHER ;EP
 ;---> GATHER DATA
 S (A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S)=0
 ;---> USE BWDT SO THAT THE DATE WON'T CHANGE IF RUN SPANS MIDNIGHT.
 D SETVARS^BWUTL5 S BWDT=DT
 ;
 ;---> PATIENT DATA
 F  S N=$O(^BWP(N)) Q:'N  S Y=^BWP(N,0) D
 .;---> QUIT IF PATIENT IS NOT ACTIVE.
 .Q:$P(Y,U,24)
 .;---> QUIT IF PATIENT IS DECEASED.
 .Q:$$DECEASED^BWUTL1($P(Y,U))
 .;---> TOTAL WOMEN IN REGISTER.
 .S A=A+1
 .;---> WOMEN PREGNANT.
 .I $P(Y,U,13)&($P(Y,U,14)>BWDT) S B=B+1
 .;---> DES DAUGHTERS.
 .S:$P(Y,U,15) C=C+1
 .;---> WOMEN WITH CERVICAL TX NEEDS NOT SPECIFIED OR NOT DATED.
 .I 5[$P(Y,U,11)!('$P(Y,U,12)) S D=D+1
 .;---> IF DATE DUE=NULL IT WAS COUNTED LINE ABOVE, SO DON'T COUNT
 .;---> IT IN THE LINE BELOW: +$P(Y,U,19).
 .;---> WOMEN WITH CERVICAL TX NEEDS SPECIFIED AND PAST DUE.
 .I 5'[$P(Y,U,11)&($P(Y,U,12)<BWDT)&(+$P(Y,U,12)) S E=E+1
 .;---> WOMEN WITH BREAST TX NEEDS NOT SPECIFIED OR NOT DATED.
 .I 8[$P(Y,U,18)!('$P(Y,U,19)) S F=F+1
 .;---> WOMEN WITH BREAST TX NEEDS SPECIFIED AND PAST DUE.
 .I 8'[$P(Y,U,18)&($P(Y,U,19)<BWDT)&(+$P(Y,U,19)) S G=G+1
 ;
 ;---> PROCEDURE DATA
 S N=0
 F  S N=$O(^BWPCD("S","o",N)) Q:'N  S Y=^BWPCD(N,0) D
 .Q:"o"'[$P(Y,U,14)
 .Q:$P(Y,U,5)=8
 .S H=H+1 S:$P(Y,U,13)<BWDT S=S+1
 ;
 ;---> TOTAL PAPS, CBES, AND MAMS FOR THIS YEAR (SINCE JAN 1).
 S N=$E(BWDT,1,3)_"0000",BWENDDT1=BWDT+.9999
 F  S N=$O(^BWPCD("D",N)) Q:'N!(N>BWENDDT1)  D
 .S M=0
 .F  S M=$O(^BWPCD("D",N,M)) Q:'M  S Y=^BWPCD(M,0) D
 ..;---> BELOW IS HARD CODED FOR IENS IN ^BWPN (PAP, CBE, OR MAM) AND
 ..;---> ^BWDIAG (ERROR/DISREGARD).  COULD BE MORE ROBUST BY LOOKING
 ..;---> AT #.10 FIELD OF ^BWPN AND #.23 FIELD OF ^BWDIAG.
 ..Q:$P(Y,U,5)=8
 ..I $P(Y,U,4)=1 S P=P+1 Q                                    ;---> PAP
 ..I $P(Y,U,4)=25!($P(Y,U,4)=26)!($P(Y,U,4)=28) S Q=Q+1 Q     ;---> MAM
 ..I $P(Y,U,4)=27 S R=R+1                                     ;---> CBE
 ;
 ;---> NOTIFICATION DATA
 S N=0
 F  S N=$O(^BWNOT("AOPEN",N)) Q:'N  D
 .S M=0
 .F  S M=$O(^BWNOT("AOPEN",N,M)) Q:'M  D
 ..I '$D(^BWNOT(M,0)) K ^BWNOT("AOPEN",N,M) Q
 ..S Y=^BWNOT(M,0)
 ..S:$P(Y,U,14)="o" J=J+1
 ..S:$P(Y,U,14)="o"&($P(Y,U,13)<BWDT) K=K+1
 ;---> LETTERS QUEUED
 S N=0 F  S N=$O(^BWNOT("APRT",N)) Q:'N  D
 .S M=0 F  S M=$O(^BWNOT("APRT",N,M)) Q:'M  S L=L+1
 Q
 ;
 ;
HELP1 ;EP
 ;;Answer "YES" to store the results of today's snapshot after they
 ;;have been printed out.  These results can then be retrieved in the
 ;;future (by calling up today's date) and compared to other Snapshots
 ;;in order to look at the trends and progress of your program over
 ;;time. (Note: If a previous snapshot for today has been run, it will
 ;;be overwritten by this or any later run today.)
 ;;
 ;;Answer "NO" to simply print today's Snapshot without storing it.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
HELPTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
