BTIUU ; IHS/ITSC/LJF - IHS UTILITY CALLS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
MSG(DATA,PRE,POST,BEEP) ;EP; -- writes line to device
 NEW I
 I PRE>0 F I=1:1:PRE W !
 W DATA
 I POST>0 F I=1:1:POST W !
 I $G(BEEP)>0 F I=1:1:BEEP W $C(7)
 Q
 ;
VALMSG() ;EP; -- sets help line message
 Q "- Previous Screen  Q Quit  ?? for More Actions"
 ;
INIT ;EP; -- initialize variables prior to printing report
 S TIUUSR=$$GET1^DIQ(200,DUZ,1)       ;user's initials
 S TIUFAC=$$GET1^DIQ(4,DUZ(2),.01)    ;facility name
 S TIUTIME=$$TIME($$NOW^XLFDT)        ;print time
 S TIUDATE=$$FMTE^XLFDT(DT)           ;print date
 Q
PRTKL ;EP; kill report header variables
 K TIUUSR,TIUFAC,TIUTIME,TIUDATE Q
 ;
CONFID(X) ;EP; return confidential message
 Q "*****Confidential Patient Data Covered by Privacy Act*****"
 ;
TIME(DATE) ;EP returns time in 12:00 PM format for date send
 Q $$UP^XLFSTR($E($$FMTE^XLFDT($E(DATE,1,12),"P"),14,21))
 ;
NUMDATE(D,YR) ;EP; returns external number date with leading zeros
 ; D=date and optionally time
 ; YR=1 for 2 digit year, =0 for 4 digit year
 NEW X
 I 'D Q ""
 I $G(YR) S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 E  S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 I $L(D)>7 S X=X_"@"_$$TIME(D)
 Q X
 ;
ZIS(X,TIURTN,TIUDESC,TIUVAR) ;EP; -- called to select device and send print
 K %ZIS,IOP
 S %ZIS=X D ^%ZIS Q:POP  I '$D(IO("Q")) D @TIURTN Q
 K IO("Q") S ZTRTN=TIURTN,ZTDESC=TIUDESC
 F I=1:1 S J=$P(TIUVAR,";",I) Q:J=""  S ZTSAVE(J)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 Q
 ;
RETURN ;EP; -- ask user to press return with form feed
 NEW X,Y,DIR
 Q:IOST'["C-"
 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR W @IOF
 K DIR Q
 ;
PAUSE ;EP; -- ask user to press return, no form feed
 NEW X,Y,DIR
 Q:IOST'["C-"
 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
 K DIR Q
 ;
 ; -- archive copies of PAD and SP subrtns
PAD(DATA,LENGTH) ; pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; pad spaces
 Q $$PAD(" ",NUM)
