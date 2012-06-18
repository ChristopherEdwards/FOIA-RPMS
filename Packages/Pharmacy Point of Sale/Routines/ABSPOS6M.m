ABSPOS6M ; IHS/FCS/DRS - Print log of claim ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
CLAIMLOG(RXI,DEST)         ;EP - from ABSPOS6D
 ;
 ;  optional parameters:  prescription #
 ;  and destination device (already opened)
 ;  Prompts for any missing parameters.
 ; 
 ; Note that it will give you only the most recent transmit/receive
 ;  If there have been retransmissions, DO ^%GSE for claim number,
 ;  and print the entire log file.  The purpose of this part is to
 ;  show when the successful I/O or last failed I/O occurred.
 ;
 I '$D(RXI) S RXI=$$GETRX^ABSPOSIV Q:RXI<1
 I $D(DEST) S IO=DEST
 E  D ^%ZIS I $G(POP) Q
 U IO W "Pharmacy POS Log of activity for one prescription",!
 N REC,X,X1,X2 M REC=^ABSPT(RXI)
 N I F I=0:1:2 I '$D(REC(I)) S REC(I)=""
 W "Prescription #",$P(^ABSPT(RXI,1),U,11) ;$G(^PSRX(RXI,0)),U)
 S X=$P(REC(1),U) I X W " Refill #",X
 W "   (RXI=",RXI,")"
 W !
 W "Patient: "
 S X=$P(REC(0),U,6) I X]"" S X=$P($G(^DPT(X,0)),U) W X
 W ?50,"Visit: "
 S X=$P(REC(0),U,7) I X]"" S X=$G(^AUPNVSIT(X,"VCN")) W X
 W !
 W "Status: "
 S X=$P(REC(0),U,2) W:X'=99 "Q" W X,":",$$STATI^ABSPOSU(X),!
 I X=99 D  W !
 .D DISPRESP^ABSPOSUA
 .;W "Result: ",$$RESULTI^ABSPOSU($P(REC(2),U))
 .;S X=$P(REC(2),U,2,$L(REC(2),U)) I X]"" W " - ",X
 W "Submitted on " S X1=$P(REC(0),U,11) I X1]"" W $$DATETIME^ABSPOSUD(X1),!
 W "  Last activity @" S X2=$P(REC(0),U,8) I X2]"" D
 .W $P($$DATETIME^ABSPOSUD(X2),"@",2)
 I X1]"",X2]"" W "  Elapsed time: " W $$TIMEDIF^ABSPOSUD(X1,X2)
 W !
 S X=$P(REC(0),U,4)
 I X="" W "No entry "
 E  W "See also entry `",X
 S X1=9002313.02 W " in file #",X1,", ",$P(^DIC(X1,0),U),!
 I X]"" D
 .S X=$P(REC(0),U,5)
 .I X="" W "but there is no entry "
 .E  W "     and entry `",X
 S X1=9002313.03 W " in file #",X1,", ",$P(^DIC(X1,0),U),!
 W !
 W "Log of this claim's activity: ",!
 I $$EXISTS^ABSPOSL(RXI) D
 . D PRESSANY^ABSPOSU5()
 . D PRINTLOG^ABSPOSL(RXI)
 E  W "Log file for ",RXI," is not on file.",!
 S X=$P(REC(0),U,12),X1=$P(REC(0),U,4) ; X=where,X1=claim #
 I X,X1 D
 .D PRESSANY^ABSPOSU5() ; now that you've seen end of claim log
 .W !,"Log of transmission, "
 .W "in log file #",$P(X,",")," at line #",$P(X,",",2),":",!
 .D PRCLLOG^ABSPOSL(X,X1) ; 
 ;D PRESSANY^ABSPOSU5()
 ;I IO=$P D  ; printout to screen
 ;D PRESSANY^ABSPOSU5() ; press any key to continue
 I '$D(DEST) D ^%ZISC ; we opened the device so we close it
 ;E  caller opened the device, and the caller should close it.
CZ Q
