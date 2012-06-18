ASUW2ST1 ; IHS/ITSC/LMH - CONSOLIDATE MASTER RECS ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine will re-extract data from history transactions files
 ;based on a selected extract date.
 ;WAR 5/19/99 REM'D and changed next 3 lines for clarity
 ;I $G(ASUL(1,"AR","WHSE"))>2 W !,"WAREHOUSE FLAG NOT SET FOR IHS" Q
 ;D ASUW2ST4,ASUW2ST5
 ;I ASUL(1,"AR","WHSE")>2 Q
 I $G(ASUL(1,"AR","WHSE"))>2 D
 .W !,"WAREHOUSE FLAG NOT SET FOR IHS"
 E  D
 .D ASUW2ST4,ASUW2ST5
 Q
ASUW2ST4 ;EP
 K ^TMP("ASUW4",$J),^TMP("ASUWI") D ^ASUWMVHS
 D:'$D(U) ^XBKVAR
 D:'$D(IOF) HOME^%ZIS
 W !!,"Moving Area Masters to consolidation Global ^TMP(""ASUW"",$J,4,",!!
 S ASUG("TRGBL")="^TMP(""ASUW"",$J,4,"
 S (ASUC,ASUC(2))=0
 D ASUW2ST7
 F ASUC=ASUC:1 S ASUHDA=$O(@ASUG("E#")) Q:ASUHDA=""  D  ;DFM P1 8/27/98
 .W "."
 .S ASUV(0)=^TMP("ASUW",$J,4,ASUHDA,0) ;DFM P1 8/27/98
 .S ASUV(1)=^TMP("ASUW",$J,4,ASUHDA,1) ;DFM P1 8/27/98
 .S ASUV(4)=$G(^TMP("ASUW",$J,4,ASUHDA,4)) ;DFM P1 8/27/98
 .S ASUV("TRCODE")=$P(ASUV(1),U)
 .S ASUV("IDX")=$P(ASUV(1),U,5)
 .Q:ASUV("IDX")']""
 .S ASUR("KEY")=$S(ASUV("TRCODE")="4A":1,ASUV("TRCODE")="4C":2,1:3)_(ASUV("IDX")*.000001)
 .S ASUV("SV",1)=$G(^TMP("ASUW4",$J,ASUR("KEY"),1))
 .S ASUV("SV",4)=$G(^TMP("ASUW4",$J,ASUR("KEY"),4))
 .I ASUV("TRCODE")["C" D                               ;LMH 3/29/00
 ..S ASUC(2)=$G(ASUC(2))+1
 ..;S ASUU(0)=^TMP("ASUWI",$J,ASUR("KEY"))             ;LMH 3/29/00
 ..;S ^TMP("ASUWA",$J,ASUV("IDX"),ASUU(0))=""
 .F ASUC(1)=1:1:17 S:$P(ASUV(1),U,ASUC(1))]"" $P(ASUV("SV",1),U,ASUC(1))=$P(ASUV(1),U,ASUC(1))
 .F ASUC(1)=1:1:4 S:$P(ASUV(4),U,ASUC(1))]"" $P(ASUV("SV",4),U,ASUC(1))=$P(ASUV(4),U,ASUC(1))
 .S ^TMP("ASUW4",$J,ASUHDA,0)=ASUV(0)                  ;LMH 3/29/00
 .S ^TMP("ASUW4",$J,ASUHDA,1)=ASUV("SV",1)             ;LMH 3/29/00
 .S ^TMP("ASUW4",$J,ASUHDA,4)=ASUV("SV",4)             ;LMH 3/29/00
 .S ^TMP("ASUWI",$J,ASUR("KEY"))=ASUHDA ;DFM P1 8/27/98
 W !,"Processed ",$J($FN(ASUC,","),8)," Area Master transactions",!,"Combined  ",$J($FN(+$G(ASUC(2)),","),8)," of them",!!
 K ^TMP("ASUW",$J,4) M ^TMP("ASUW4",$J)=^TMP("ASUW",$J,4)
 K ASUC("TR"),ASUC,ASUV,ASUR
 Q
ASUW2ST5 ;EP
 K ^TMP("ASUW5",$J),^TMP("ASUWI") D ^ASUWMVHS
 D:'$D(U) ^XBKVAR
 D:'$D(IOF) HOME^%ZIS
 S ASUU(0)=""
 W !,"Moving Station Masters to consolidation Global ^TMP(""ASUW"",$J,5,",!!
 S ASUG("TRGBL")="^TMP(""ASUW"",$J,5,",ASUC=0 D ASUW2ST7
 F ASUC=ASUC:1 S ASUHDA=$O(@ASUG("E#")) Q:ASUHDA=""  D  ;DFM P1 8/27/98
 .W "."
 .S ASUV(0)=^TMP("ASUW",$J,5,ASUHDA,0) ;DFM P1 8/27/98
 .S ASUV(1)=^TMP("ASUW",$J,5,ASUHDA,1) ;DFM P1 8/27/98
 .S ASUV(5)=$G(^TMP("ASUW",$J,5,ASUHDA,5)) ;DFM P1 8/27/98
 .S ASUV("TRCODE")=$P(ASUV(1),U)
 .S ASUV("IDX")=$P(ASUV(1),U,5)
 .Q:ASUV("IDX")']""
 .S ASUR("KEY")=$S(ASUV("TRCODE")="5A":1,ASUV("TRCODE")="5B":2,ASUV("TRCODE")="5C":3,1:4)_(ASUV("IDX")*.000001)
 .S ASUV("SV",1)=$G(^TMP("ASUW5",$J,ASUR("KEY"),1))
 .S ASUV("SV",5)=$G(^TMP("ASUW5",$J,ASUR("KEY"),5))
 .I ASUV("TRCODE")["C" D
 ..S ASUC(2)=$G(ASUC(2))+1
 ..;S ASUU(0)=^TMP("ASUWI",$J,ASUR("KEY"))        ;LMH 3/30/00 
 ..;S ^TMP("ASUWA",$J,ASUV("IDX"),ASUU(0))=""
 .F ASUC(1)=1:1:20 S:$P(ASUV(1),U,ASUC(1))]"" $P(ASUV("SV",1),U,ASUC(1))=$P(ASUV(1),U,ASUC(1))
 .F ASUC(1)=1:1:20 S:$P(ASUV(5),U,ASUC(1))]"" $P(ASUV("SV",5),U,ASUC(1))=$P(ASUV(5),U,ASUC(1))
 .S ^TMP("ASUW5",$J,ASUHDA,0)=ASUV(0)             ;LMH 3/24/00
 .S ^TMP("ASUW5",$J,ASUHDA,1)=ASUV("SV",1)        ;LMH 3/24/00
 .S ^TMP("ASUW5",$J,ASUHDA,5)=ASUV("SV",5)        ;LMH 3/24/00
 .S ^TMP("ASUWI",$J,ASUR("KEY"))=ASUHDA ;DFM P1 8/27/98
 W !,"Processed ",$J($FN(ASUC,","),8)," Station Master transactions",!,"Combined  ",$J($FN(+$G(ASUC(2)),","),8)," of them",!!
 K ^TMP("ASUW",$J,5) M ^TMP("ASUW",$J,5)=^TMP("ASUW5",$J)
 K ASUC("TR"),ASUC,ASUV,ASUR
 Q
ASUW2ST7 ;EP ;
 S ASUHDA="" ;DFM P1 8/27/98
 S ASUG("E#")=ASUG("TRGBL")_"ASUHDA)" ;DFM P1 8/27/98
 Q
SV1 ;EP
 S ASUV("XB","MEDIUM")="F",XBMED=ASUV("XB","MEDIUM")
 I ASUW("SV DIR")]"" D
 .S ASUV("XB","DIRECTORY")=ASUW("SV DIR")
 E  D
 .S ASUV("XB","DIRECTORY")="/u/ihs/ftp/pub"
 S XBUF=ASUV("XB","DIRECTORY")
 S:'$D(ASUL(1,"AR","WHSE")) ASUL(1,"AR","WHSE")=1
ASUW2ST9 ;EP
 I ASUL(1,"AR","WHSE")>2 Q
 S XBGL="ASUPDATA" D ^XBGSAVE K XBGL
 I XBFLG D
 .S ASURX="W !,""Save of ASUPDATA Unsucessful -""" D ^ASUUPLOG
 .F ASUF("XB")=1:1 Q:'$D(XBFLG(ASUF("XB")))  D
 ..S ASURX="W """_XBFLG(ASUF("XB"))_""",!" D ^ASUUPLOG
 E  D
 .I '$D(ASUV("XB")) D
 ..S ASUV("XB","MEDIUM")="F"
 ..S ASUV("XB","DIRECTORY")="/u/ihs/ftp/pub"
 .S X2=$E(ASUK("DT","FM"),1,3)_"0101",X1=ASUK("DT","FM") D ^%DTC S X=X+1
 .S ASURX="W !,""Save of ^ASUPDATA global to "_ASUV("XB","DIRECTORY")_"/ASUP"_ASUK("ASUFAC")_"."_X_" Successful"",!"  D ^ASUUPLOG
 K XBFLG,ASUV("XB")
 Q
 S XBGL="ASUTRSV",XBMED="F" D ^XBGSAVE K XBGL
 I XBFLG D
 .S ASURX="W !,""Save of ASUTRSV Unsucessful -""" D ^ASUUPLOG
 .F ASUF("XB")=1:1 Q:'$D(XBFLG(ASUF("XB")))  D
 ..S ASURX="W """_XBFLG(ASUF("XB"))_""",!" D ^ASUUPLOG
 K XBFLG
 Q
REXT ;EP;RE-EXTRACT
 S DIR(0)="Y",DIR("A")="Do you wish to Re-Extract Transactions"
 S DIR("?",1)="Enter 'Y' to re-extract previously extracted, or"
 S DIR("?")=" 'N' to be prompted for a regular extract of updated transactions."
 D ^DIR K DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 G:Y CONTURXT
 S DIR(0)="Y",DIR("A")="Do you wish to Extract Updated Transactions"
 S DIR("?",1)="Enter 'Y' to extract updated transactions, or"
 S DIR("?")=" 'N' to end this option selection."
 D ^DIR K DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 I 'Y Q
 G BEGIN^ASUW2STO
CONTURXT ;
 K ^ASURX("R0R") S ASULA("X")="0R"
 S ASUW("TY RUN")=^ASUSITE(1,0)
 S $P(ASUW("TY RUN"),U,2)=8
 D:'$D(U) ^XBKVAR
 I '$D(IO(0)) S IOP=$I D ^%ZIS
 S ASUP("TYP")=$G(ASUP("TYP")) S:ASUP("TYP")']"" ASUP("TYP")=0
REXT2 ;EP ; RE-EXTRACT DATA
 S DIR(0)="D",DIR("A")="Enter Re-Extract Date",DIR("?")="^D DTHLP^ASUW2ST1" D ^DIR Q:$D(DTOUT)  Q:$D(DUOUT)!($D(DIROUT))
 S ASUW("DT EXT")=Y X ^DD("DD")
 S ASURX="W @IOF" D ^ASUUPLOG
 S ASURX="W !,""Re-extracting selected date of "_Y_"""" D ^ASUUPLOG
 K DIR,Y G OPNHFS^ASUW2STO
DTHLP ;LIST DATES EXTRACTED
 W !,"Enter the Extracted Date on records to be re-extracted.  Dates are:"
 S X=0 F  S X=$O(^ASUML("B",X)) Q:X'?1N.N  W !,$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 Q
