APCPAOTH ; IHS/TUCSON/LAB - extract APC imm/skin/mh data AUGUST 14, 1992 ; [ 12/16/03  8:19 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,7**;APR 03, 1998
 ;IHS/CMI/LAB - 1/5/1999 patch 2 for new Immunization package
 ;IHS/CMI/LAB - 12-15-03 patch 7, protect against dangling ptr 
 ;to immunization from v immunization (riverside)
 ;
 ;
 D IMM
 I $D(APCPE("ERROR")) S APCPT("FILE")=9000010.11 D EOJ Q
 D ST
 I $D(APCPE("ERROR")) S APCPT("FILE")=9000010.12 D EOJ Q
 D REP
 D EOJ
 Q
EOJ ;
 Q
IMM ;
 ; get immunizations done
 S APCPT("X")=0,APCPT("IMM")="          " F  S APCPT("X")=$O(^AUPNVIMM("AD",APCP("V DFN"),APCPT("X"))) Q:APCPT("X")=""  S APCPT("Y")=^AUPNVIMM(APCPT("X"),0) D GETIMM
 Q
GETIMM ;
 ;S X=$P(APCPT("Y"),U),X=$P(^AUTTIMM(X,0),U,3) ;IHS/CMI/LAB - patch 2 commented out and replaced with line below
 S X=$P(APCPT("Y"),U)
 Q:'$D(^AUTTIMM(X,0))
 S X=$P(^AUTTIMM(X,0),U,$S($$BI:20,1:3)) ;IHS/CMI/LAB - patch 2 1/5/1999
 S (APCPT("IMM 2"),X)=+X,X=$S(X=1:7,X=2:2,X=3:3,X=4:1,X=6:4,X=7:4,X=11:5,X=12:9,X=14:6,X=15:8,X=34:2,1:10)
 S APCPT("CHAR")=X
 S APCPT("VAL")=$S(APCPT("CHAR")=10:0,1:APCPT("CHAR"))
 I APCPT("IMM 2")=17 S APCPT("IMM")=$E(APCPT("IMM"),1,4)_56_$E(APCPT("IMM"),7)_8_$E(APCPT("IMM"),9,10) Q
 I APCPT("IMM 2")=18 S APCPT("IMM")=$E(APCPT("IMM"),1,4)_56_$E(APCPT("IMM"),7,10) Q
 I APCPT("IMM 2")=8,$P(APCPT("Y"),U,4)="B" S APCPT("IMM")=$E(APCPT("IMM"),1,9)_"A" Q
 I APCPT("IMM 2")=8,$P(APCPT("Y"),U,4)'="B" S APCPT("IMM")=$E(APCPT("IMM"),1,8)_"A"_$E(APCPT("IMM"),10) Q
 I APCPT("IMM 2")=9,$P(APCPT("Y"),U,4)="B" S APCPT("IMM")=$E(APCPT("IMM"),1,9)_"B" Q
 I APCPT("IMM 2")=9,$P(APCPT("Y"),U,4)'="B" S APCPT("IMM")=$E(APCPT("IMM"),1,8)_"B"_$E(APCPT("IMM"),10)
 S APCPT("IMM")=$E(APCPT("IMM"),1,(APCPT("CHAR")-1))_APCPT("VAL")_$E(APCPT("IMM"),(APCPT("CHAR")+1),10)
 Q
 ;IHS/CMI/LAB - patch 2 1/5/1999 new subroutine
BI() ;check to see if new imm package is running
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
 ;IHS/CMI/LAB - end new subroutine patch 2
ST ; get skin test reading is PPD and result if TINE
 S APCPT("X")=0,APCPT("RES")="" F  S APCPT("X")=$O(^AUPNVSK("AD",APCP("V DFN"),APCPT("X"))) Q:APCPT("X")=""  D GETRES
 Q
 ;
GETRES ;
 S APCPT("Y")=$P(^AUPNVSK(APCPT("X"),0),U) I APCPT("Y")="" S APCPE("ERROR")="E010" Q
 S APCPT("Y")=$P(^AUTTSK(APCPT("Y"),0),U,2) I APCPT("Y")="" S APCPE("ERROR")="E010" Q
 I APCPT("Y")=20 S APCPT("RES")=$P(^AUPNVSK(APCPT("X"),0),U,4),APCPT("RES")=$S(APCPT("RES")="N":5,APCPT("RES")="P":6,1:"") Q
 I APCPT("Y")=21 S APCPT("RES")=$P(^AUPNVSK(APCPT("X"),0),U,5)
 I APCPT("RES")="" Q
 S APCPT("RES")=$S(APCPT("RES")<5:1,APCPT("RES")>4&(APCPT("RES")<10):2,APCPT("RES")>9&(APCPT("RES")<20):3,APCPT("RES")>19:4,1:"")
 ;
 Q
REP ;
 ; get reproductive hx info, gravida, lc, method, status
 S (APCPT("AG"),APCPT("ALC"),X,APCPT("AS"),APCPT("AFP"))=""
 Q:'$D(^AUPNREP(APCPV("PATIENT DFN")))
 S APCPT("REP")=^AUPNREP(APCPV("PATIENT DFN"),0)
 I $P(APCPT("REP"),U,3)'=$P(APCPV("V DATE"),".") G METH
 I $E($P(APCPT("REP"),U,2))'="G" G LC
 S APCPT("AG")=+($P($P(APCPT("REP"),U,2),"G",2)) S:$L(APCPT("AG"))=1 APCPT("AG")="0"_APCPT("AG")
LC ;
 S APCPT("ALC")=+($P($P(APCPT("REP"),U,2),"LC",2)) S:$L(APCPT("ALC"))=1 APCPT("ALC")="0"_APCPT("ALC")
METH ;
 I $P(APCPT("REP"),U,8)'=$P(APCPV("V DATE"),".") Q
 S X=$P(APCPT("REP"),U,6) Q:X=""
 S APCPT("AFP")=$S(X=0:4,X=3:6,X=5:4,X=6:3,1:X)
 Q
