BSDROUT2 ; IHS/ANMC/LJF - MORE SUBROUTINES ;  [ 10/29/2004  4:59 PM ]
 ;;5.3;PIMS;**1001,1003**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/01/2004 PATCH 1001 fixed logic on range of chart requests
 ;             04/14/2005 PATCH 1003 fixed use of wrong variable
 ;             06/10/2005 PATCH 1003 incomplete chart status display fixed
 ;
HED ;EP -- rerouted from BSDROUT1 if printing short form
 I $G(SDCNT)>0 W @IOF
 W !,"FACILITY: ",$$GET1^DIQ(40.8,$$DIV^BSDU,.01)
 W !?7,"**",$E($$CONF^BSDU,1,25),"**"
 S BSDPG=$G(BSDPG)+1 W !,"PAGE ",BSDPG,?10,"OUTPATIENT ROUTING SLIP"
 ;
 W !,"NAME: ",$$GET1^DIQ(2,DFN,.01)
 W ?30,"HRCN: ",$$HRCN^BDGF2(DFN,+$G(DUZ(2)))
 W !,"DOB:  ",$$GET1^DIQ(2,DFN,.03)
 W ?27,"APPT DT: ",$$FMTE^XLFDT(SDATE,5)
 I $$DEAD^BDGF2(DFN) W !,"** PATIENT DIED ON ",$$DOD^BDGF2(DFN)," **"
 ;
 Q:BSDPG>1       ;rest only needs to be on first page
 ;
 D STATUS(DFN) W !
 Q
 ;
STATUS(DFN) ;EP; -- called to check if patient's chart is incomplete
 ;        or pulled for day surgery
 ; called by BSDROUT1
 NEW X Q:DFN=""
 ;
 I $D(^DPT(DFN,.1)) D
 . W !!,"Current Status:  INPATIENT on ward ",^DPT(DFN,.1)
 ;
 ;IHS/ITSC/LJF 6/10/2005 PATCH 1003 only display once
 NEW FOUND S FOUND=0
 ;S X=0 F  S X=$O(^BDGIC("B",DFN,X)) Q:'X  D
 S X=0 F  S X=$O(^BDGIC("B",DFN,X)) Q:'X  Q:FOUND  D
 . ;
 . Q:$P($G(^BDGIC(X,0)),U,17)]""     ;deleted
 . Q:$P($G(^BDGIC(X,0)),U,14)]""     ;completed
 . S FOUND=1                         ;PATCH 1003 new line
 . W !,"Current Status:  ACTIVE INCOMPLETE CHART"
 . ;I $P($G(^BDGIC(X,0)),U,18)]"" W !?8,$P(^BDGIC(X,0),U,18)  ;comments
 . I $P($G(^BDGIC(X,0)),U,18)]"" W !?17,"(",$P(^BDGIC(X,0),U,18),")"  ;comments
 ;end of PATCH 1003 changes
 ;
 NEW X S X=$O(^ADGDS(DFN,"DS",DT))
 I X]"",X\1=DT W !,"Current Status:  ACTIVE DAY SURGERY PATIENT"
 ;
 NEW DATE,X S DATE=9999999-DT,X=DATE-.0001
 S X=$O(^SRF("AIHS3",DFN,X)) Q:'X
 I X\1=DATE W !,"Current Status:  DAY SURGERY/SDA PATIENT"
 Q
 ;
 ;
CRLOOP ;EP; process chart requests for date
 ; called by BSDROUT for each clinic
 ; assumes VA variables SDREP,SDX,SDSTART,SDSTOP,ORDER,SDATE are set
 NEW CLN,IEN,DFN,BSDX,CRDT
 S CLN=0 F  S CLN=$O(^SC(CLN)) Q:'CLN  D
 . Q:'$$OKAY(CLN)                   ;not on list or inactive
 . S IEN=0
 . F  S IEN=$O(^SC(CLN,"C",SDATE,1,IEN)) Q:'IEN  D
 .. S DFN=+$G(^SC(CLN,"C",SDATE,1,IEN,0)) Q:'DFN
 .. S BSDX=$G(^SC(CLN,"C",SDATE,1,IEN,9999999))   ;IHS data
 .. I 'SDREP,SDX["ADD" Q:$P(BSDX,U,4)]""           ;already printed
 .. D CRSET(CLN,SDATE,DFN,ORDER)
 Q
 ;
CRSET(CLN,DATE,DFN,ORDER) ;EP; process single chart request
 ; called by CRLOOP and by chart request software
 NEW HRCN,TERN,BSDMODE
 ;
 S HRCN=$$HRCN^BDGF2(DFN,+$$FAC^BSDU(CLN))  ;chart #
 S TERM=$$HRCNT^BDGF2(HRCN)                 ;terminal digit format
 I $$GET1^DIQ(9009020.2,+$$DIVC^BSDU(CLN),.18)="NO" D
 . S TERM=$$HRCND^BDGF2(HRCN)               ;use chart # per site param
 ;
 ;set chart request as first item for day-makes extra forms print
 ;too hard to find first cr for patient for day AND hopefully
 ;chart request not being made if patient already has appt
 ;
 S BSDMODE="CR"
 ;
 I ORDER="" D  Q  ;make sure all cr for date are printed
 . I $D(^TMP("SDRS",$J,$$GET1^DIQ(2,DFN,.01)," "_TERM,DFN,DATE)) D
 .. NEW I F I=.01:.01:.99 Q:'$D(^TMP("SDRS",$J,$$GET1^DIQ(2,DFN,.01)," "_TERM,DFN,(DATE+I)))
 .. D NMO^BSDROUT0(DFN,(DATE_I),CLN,TERM,"",1)
 . E  D NMO^BSDROUT0(DFN,DATE,CLN,TERM,"",1)
 ;
 ;IHS/ITSC/LJF 6/1/2004 PATCH #1001 ranges for chart requests
 I ORDER=1,SDSTART]"",SDSTART]$E(TERM,1,2) Q   ;before beginning
 I ORDER=1,SDSTOP]"",$E(TERM,1,2)]SDSTOP Q     ;after end
 ;I ORDER=4,SDSTART]$$GET1^DIQ(2,P,.01) Q   ;before beginning
 ;I ORDER=4,$$GET1^DIQ(2,P,.01)]SDSTOP Q   ;before beginning
 I ORDER=4,SDSTART]"",SDSTART]$$GET1^DIQ(2,DFN,.01) Q   ;before beginning   ;IHS/ITSC/LJF 10/25/2004 PATCH 1003
 I ORDER=4,SDSTOP]"",$$GET1^DIQ(2,DFN,.01)]SDSTOP Q     ;after end of range ;IHS/ITSC/LJF 10/25/2004 PATCH 1003
 ;IHS/ITSC/LJF 6/1/2004 PATCH #1001 END OF CHANGES
 ;
 I ORDER=1 D TDO^BSDROUT0(DFN,DATE,CLN,TERM,"",1) Q
 I ORDER=2 D CLO^BSDROUT0(DFN,DATE,CLN,TERM,"",1) Q
 I ORDER=3 D PCO^BSDROUT0(DFN,DATE,CLN,TERM,"",1) Q
 D NMO^BSDROUT0(DFN,DATE,CLN,TERM,"",1) Q
 Q
 ;
 ;
OKAY(C) ; returns 1 if okay to use this clinic
 ;IHS/ITSC/LJF 4/15/2004 rewrote subroutine
 NEW X
 I VAUTC=0,'$D(VAUTC(C)) Q 0          ;not on list of selected clinics
 I VAUTD=0 S X=$P(^SC(C,0),U,15) I '$D(VAUTD(+X)) Q 0
 S X=$G(^SC(C,"I")) I 'X Q 1          ;active clinic
 I ($P(X,U)>DT)!($P(X,U,2)'>DT) Q 1   ;outside inactive dates
 Q 0                                  ;otherwise don't use
 ;
