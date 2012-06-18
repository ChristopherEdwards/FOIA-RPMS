BDGPI3 ; IHS/ANMC/LJF,WAR - DAY SURGERY DETAILS ;  [ 02/20/2004  8:59 AM ]
 ;;5.3;PIMS;**1003**;MAY 28, 2004
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 added DFN to parameter list
 ;                                   code assumes DFN is set
 ;
EN(SRDR,BDGDS,DFN) ;EP; -- main entry point for BDG PI - DAY SURGERY;IHS/ITSC/LJF PATCH 1003
 ; SRDR = ien in Surgery file
 ; BDGDS = ien in Day Surgery file
 ; At least one of these must be set
 ;
 ; first check for data in Surgery file
 K DIERR    ;if set, make DIC call below choose wrong patient
 I $G(SRDR),$T(VIEW^BSRLA0)]"" D  Q
 . S DIC=130,DIC(0)="EMQ",X=$$HRCN^BDGF2(DFN,DUZ(2)) D ^DIC Q:Y<1
 . NEW SRDR S SRDR=+Y
 . D VIEW^BSRLA0,PAUSE^BDGF
 ;
 ;
 ; else check Day Surgery file
 Q:'$G(BDGDS)   ;ien not sent to routine
 NEW X,IENS,LINE
 S IENS=BDGDS_","_DFN_","
 S LINE="Surgery Date/Time: "_$$GET1^DIQ(9009012.01,IENS,.01)
 S LINE=$$PAD(LINE,40)_"Procedure: "_$$GET1^DIQ(9009012.01,IENS,1)
 W !,LINE
 ;
 S X=$$GET1^DIQ(9009012.01,IENS,9)            ;d/t to observation
 S LINE=$$PAD($S(X]"":"   To Observation: "_X,1:""),40)
 S LINE=LINE_"Specialty: "_$$GET1^DIQ(9009012.01,IENS,4)
 W !,LINE
 ;
 S LINE=$$PAD("Ward:"_$S(X]"":$$GET1^DIQ(9009012.01,IENS,2),1:""),40)  ;ward
 S LINE=LINE_"Surgeon: "_$$GET1^DIQ(9009012.01,IENS,5)         ;surgeon
 W !,LINE
 ;
 S LINE=$$PAD("  Rm:"_$S(X]"":$$GET1^DIQ(9009012.01,IENS,3),1:""),40)  ;room
 S LINE=LINE_"Diagnosis: "_$$GET1^DIQ(9009012.01,IENS,1.5)       ;dx
 W !,LINE
 ;
 S X=$$GET1^DIQ(9009012.01,IENS,7)             ;release date/time
 I X]"" D
 . S LINE=""
 . S LINE=$$PAD(LINE,41)_"Released: "_X
 . W !,LINE
 . S LINE=$$PAD(LINE,41)_"     LOS: "_$$GET1^DIQ(9009012.01,IENS,8)_" hrs"
 . W !,LINE
 E  D
 . I $$GET1^DIQ(9009012.01,IENS,12)="YES" D  Q
 .. S LINE=$$PAD(LINE,38)_"**CANCELLED**" W !,LINE
 . I $$GET1^DIQ(9009012.01,IENS,13)="YES" D  Q
 .. S LINE=$$PAD(LINE,38)_"**NO-SHOW**" W !,LINE
 ;
 S BDGWP=$$GET1^DIQ(9009012.01,IENS,6,"Z","BDGWP")
 I $O(BDGWP(0)) W !,"Interview Comments:"
 F I=1:1 Q:'$D(BSDWP(I))  W !?4,BDGWP(I)
 ;
 S X=$$GET1^DIQ(9009012.01,IENS,16)
 I X]"" W !,"Post-Op Comments: "_X
 ;
 D PAUSE^BDGF
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
