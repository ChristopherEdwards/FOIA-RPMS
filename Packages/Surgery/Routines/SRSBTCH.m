SRSBTCH ;B'HAM ISC/MAM - SURGERY DICTATION TRANSFER ; 16 Nov 1988  7:46 AM
 ;;3.0; Surgery ;**22,48,91**;24 Jun 93
TRANS ;
 W !!,"Transmit the file of operation notes to be merged: ",!!
 S I=0,NEWHDR=0
READ S ENDCASE=0 R X:30,! I '$T!(X["^") W !,"Abnormal end of case data transmission.  Verify quality of initial file and",!,"re-transmit." G END
 D:X["@" HDRCHK G:'NEWHDR READ S I=I+1,^SRT(SRTDFN,1,I,0)=X G:ENDCASE DICT
 G READ
HDRCHK ;
 S SRHDR=$F(X,"@")-1
 I $E(X,SRHDR,99)?1"@"1.8N1"/".E S NEWHDR=1,X=X_"^"_DT
 I X["@###" S (ENDCASE,NEWHDR)=1 W !!,"Transmission completed.  Now sorting and storing dictation.",!
 Q
DICT ; move dictaion into ^SRF
 S J=""
SET S J=$O(^SRT(SRTDFN,1,J)) G:'J END S SRZT=^SRT(SRTDFN,1,J,0),NEWHDR=0
 I SRZT["@" D HDRMTCH G:NEWHDR SET
 S:$D(SRTN) ^SRF(SRTN,12,LINE,0)=SRZT,LINE=LINE+1 W "." G SET
END W !!,"Press RETURN to continue  " R X:DTIME D ^SRSKILL K SRTN W @IOF
 D ^%ZISC Q
USER ; check for user in SURGERY TRANSCRIPTION file (136)
 S SRUSER=$O(^SRT("B",SRSDUZ,0)) I 'SRUSER K DA,DIC,DD,DO,DINUM S X=SRSDUZ,DIC="^SRT(",DIC(0)="L",DLAYGO=136 D FILE^DICN K DD,DO,DIC,DLAYGO S SRUSER=DA
 S SRTDFN=SRUSER
 Q
HDRMTCH ;
 I SRZT["@###" D:$D(LINE) CLSDIC W !!,"Finished.",! S NEWHDR=1 Q
 I SRZT'?0.3" "1"@"1.8N1"/".E Q:$D(SRTN)  G ERR
 D:$D(LINE) CLSDIC
 S SRTN=$E(SRZT,$F(SRZT,"@"),$F(SRZT,"/")-2),LINE=1,S1=$F(SRZT,"/")-1
 G:'$D(^SRF(SRTN,0)) ERR F S2=1:1:80 Q:$E(SRZT,S2,S2+5)?1"/"1A4N
 S DFN=+^SRF(SRTN,0) D DEM^VADPT S SSN=VA("BID"),PTAG=$E(SRZT,S2+1,S2+6),X=$E(SRZT,S1+1,S2-1),%DT="" D ^%DT S SRDT=+Y
 I PTAG'[$E(VA("BID"),1,4)!($E(PTAG)'=$E(VADM(1)))!(^SRF(SRTN,0)'[SRDT) G ERR
 S DA=SRTN,DIE=130 K DR S DR="39////"_DT D ^DIE K DR,^SRF("ADIC",SRTN)
 K ^SRF(SRTN,12) S NEWHDR=1
 Q
ERR ;
 I $D(SRTN) W !,"Case # "_SRTN_" does not match.  This case cannot be processed. "
 I '$D(SRTN) W !,"Cannot process the case with header ==> ",SRZT,"  " S SRTN=$P(SRZT,"@",2)
 S ^SRT(SRTDFN,"ER",SRTN,0)=SRTN,NEWHDR=1
 S $P(^SRT(SRTDFN,"ER",0),"^",3)=$P(^SRT(SRTDFN,"ER",0),"^",3)+1,$P(^SRT(SRTDFN,"ER",0),"^",4)=$P(^(0),"^",4)+1
 S J2=J F J=J2:0 S J=$O(^SRT(SRTDFN,1,J)) Q:J=""!(^SRT(SRTDFN,1,J,0)["@")  S J3=J
 S J=J3 K SRTN,LINE
 Q
CLSDIC ;
 S ^SRT(SRTDFN,"Q",SRTN,0)=SRTN_"^^"_(LINE-1),^SRF(SRTN,12,0)="^^"_(LINE-1)_"^"_(LINE-1)
 S $P(^SRT(SRTDFN,"Q",0),"^",3)=$P(^SRT(SRTDFN,"Q",0),"^",3)+1,$P(^(0),"^",4)=$P(^(0),"^",4)+1
 Q
PRINT ; batch print op reports
 N SRSITE S SRSDUZ=DUZ D USER
 K IOP,%ZIS,POP,IO("Q") S %ZIS("B")="",%ZIS("A")="Print to Device: ",%ZIS="Q" D ^%ZIS G:POP END
 I $E(IOST)'="P" W !!,"This report must be run on a printer.  Please select another device.",!! G PRINT
 I $D(IO("Q")) K IO("Q") S ZTDESC="BATCH PRINT, SURGERY DICTATIONS",ZTRTN="PQ^SRSBTCH",ZTSAVE("SRTDFN")=SRTDFN D ^%ZTLOAD G END
PQ ;
 S (SRTN,SRSOUT)=0
 F  S SRTN=$O(^SRT(SRTDFN,"Q",SRTN)) Q:'SRTN!SRSOUT  S X=$P($G(^SRF(SRTN,8)),"^"),SRSITE=$S(X:$O(^SRO(133,"B",X,0)),1:$O(^SRO(133,0))) Q:'SRSITE  D SET^SROVAR D  S $P(^SRT(SRTDFN,"Q",SRTN,0),"^",2)=DT
 .S SRNON=$S($P($G(^SRF(SRTN,"NON")),"^")="Y":1,1:0) I SRNON D RPT^SRONON Q
 .D ^SROPRPT1 N SRTDFN,SRSOUT D ^SRSKILL
 W:$E(IOST)="P" @IOF I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 K SRTN D ^SRSKILL D ^%ZISC W @IOF
 Q
