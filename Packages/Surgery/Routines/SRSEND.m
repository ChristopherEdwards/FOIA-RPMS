SRSEND ;B'HAM ISC/MAM - SEND DICTATIONS FROM PC; 9 Nov 1988  8:34 AM
 ;;3.0; Surgery ;;24 Jun 93
USER ; check for user in SURGERY TRANSCRIPTION file (136)
 S SRUSER=$O(^SRT("B",DUZ,0)) I 'SRUSER K DA,DIC,DD,DO,DINUM S X=DUZ,DIC="^SRT(",DIC(0)="L",DLAYGO=136 D FILE^DICN K DIC,DLAYGO S SRUSER=DA
 W @IOF,! S SRTDFN=SRUSER
 I $O(^SRT(SRTDFN,0))="" G ZNODES
 I '$O(^SRT(SRTDFN,1,0)) G CLRQ
 W !,"There is old text remaining in your file.  By transmitting a new batch, the",!,"old text will be erased."
OLD W !!,"Do you want to continue ?  YES// " R X:DTIME I '$T!(X["^") S X="N"
 I X["?" W !!,"Enter RETURN if you would like to transmit a new batch of dictations,",!,"or 'NO' to exit this option." G OLD
 S X=$E(X) I "Yy"'[X G END
 K ^SRT(SRTDFN,1)
CLRQ ; clear print queue
 I '$D(SRQ) G:'$O(^SRT(SRTDFN,"Q",0)) CLRERR W !,"There is old data in the print queue." S SRQ=1 D PRQU^SRSTR
 W !!,"Do you want to clear the print queue ?  NO// " R X:DTIME I '$T!(X="^") G END
 S X=$E(X) S:X="" X="N" I "NnYy"'[X D HELP1 G CLRQ
 S X=$E(X) I "Yy"[X K ^SRT(SRTDFN,"Q")
CLRERR G:'$O(^SRT(SRTDFN,"ER",0)) ZNODES W !,"Do you want to clear the error log ?  NO// " R X:DTIME I '$T!(X["^") G END
 S X=$E(X) S:X="" X="N" I "NnYy"'[X D HELP2 G CLRERR
 S X=$E(X) I "Yy"[X K ^SRT(SRTDFN,"ER")
ZNODES ;
 I '$D(^SRT(SRTDFN,"Q")) S ^SRT(SRTDFN,"Q",0)="^136.03PA^0^0"
 I '$D(^SRT(SRTDFN,"ER")) S ^SRT(SRTDFN,"ER",0)="^136.02PA^0^0"
 G TRANS^SRSBTCH
 Q
END D ^%ZISC D ^SRSKILL K SRTN W @IOF
 Q
HELP1 ;
 W !!,"Enter 'YES' if you would like to clear out the cases already stored in",!,"the print queue, or RETURN to continue.",!
 Q
HELP2 ;
 W !!,"Enter RETURN if you wish to leave the unmatched case numbers in the error",!,"log for further inspection, or 'YES' to clean out the log.",!
 Q
