ATXTSK ; IHS/OHPRD/TMJ -  CALL TO TASKMAN ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 S ATXGO=0
 D ASK
 K IO("Q")
 D:ATXGO ZIS
 S ATXTSK=0
 I $D(IO("Q")),'POP S ATXTSK=1 D @$S($D(ATXPAT)!(ATXFIL=9000010.07):"TSKMN",1:"TSKMN1")
 D EOJ
 Q
 ;
ASK ;
 W !!,"Do you want to queue the search template creation to another device" S %=2 D YN^DICN
 I %=2 W ! G A
 I %=0 D HELP G ASK
 I %=-1 S ATXTP=0 G A
 I %=1 S ATXGO=1
A Q
 ;
ZIS ;
 W !! S %ZIS="PQ",IOP="Q" D ^%ZIS
 Q
 ;
TSKMN ;CALL TO ATXPVT TO CREATE TEMPLATE WITH PATS ($D(ATXPAT)) OR POVS FOR DATE RANGE
 K ZTSAVE F %="ATXBDT","ATXEDT","ATXTMP","ATXX","ATXTSK","ATXFIL" S ZTSAVE(%)=""
 S:$D(ATXPAT) ZTSAVE("ATXPAT")=""
 S ZTRTN="ZTM^ATXPVT",ZTDESC="TAX SEARCH TEMPLATE",ZTIO=IO,ZTDTH="" D ^%ZTLOAD
 K ZTSK
 Q
 ;
TSKMN1 ;CALL TO ATXRCH FOR EITHER RETROSPECTIVE OR CURRENT LIST OF ALL PTS WHO FALL IN THE TAXONOMY
 K ZTSAVE F %="ATXTSK","ATXX","ATXTMP" S ZTSAVE(%)=""
 S ZTRTN="ZTM^ATXRCH",ZTDESC="TAX SEARCH TEMPLATE",ZTIO=IO,ZTDTH="" D ^%ZTLOAD
 K ZTSK
 Q
 ;
HELP ;
 W !!,"Queuing will free up your terminal.  You should queue for after hours so as",!,"not to slow up the computer.  Queuing to a printer will produce an output",!,"telling the number of entries made into the template you created."
 W:$D(IOF) @IOF
 Q
 ;
EOJ ;
 K ATXGO,ATXQT,IO("Q")
 Q
 ;
