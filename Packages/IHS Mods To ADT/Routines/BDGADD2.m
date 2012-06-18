BDGADD2 ; IHS/ANMC/LJF - A&D DETAILED-DAY SURGERY ;  
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/22/2007 added day surgery release date/time PATCH 1007 item 1007.36
 ;
 ; check VA Surgery file for data
 S X="BSRPEP" X ^%ZOSF("TEST") I $T D  Q
 . NEW DAYCT,DGDS
 . S DAYCT=$$ADS^BSRPEP("D",BDGT)
 . I DAYCT>0 D LINES
 ;
 ; And then IHS Day Surgery file
 NEW DATE,DFN,DSN,DGDS,DGZA,DAYCT,NAME,END,RELDT
 S DATE=BDGT-.0001,END=BDGT+.24,DAYCT=0
 F  S DATE=$O(^ADGDS("AA",DATE)) Q:'DATE  Q:DATE>END  D
 . S DFN=0
 . F  S DFN=$O(^ADGDS("AA",DATE,DFN)) Q:'DFN  D
 .. S DSN=0 F  S DSN=$O(^ADGDS("AA",DATE,DFN,DSN)) Q:'DSN  D
 ... ;
 ... Q:'$D(^ADGDS(DFN,"DS",DSN,0))  S DGZ=^(0)
 ... ;IHS/ITSC/WAR 11/24/03 TYPO
 ... ;I $P($G(^ADGDS(DFN,"DS",DGDSN,2)),U,3,4)["Y"  Q   ;noshow/cancel
 ... I $P($G(^ADGDS(DFN,"DS",DSN,2)),U,3,4)["Y"  Q   ;noshow/cancel
 ... S RELDT=$$FMTE^XLFDT($P($G(^ADGDS(DFN,"DS",DSN,2)),U))  ;release date cmi/anch/maw 2/22/2007 PATCH 1007 item 1007.36
 ... ;
 ... S NAME=$$GET1^DIQ(2,DFN,.01)                           ;patient
 ... S X=$$GET1^DIQ(200,+$P(DGZ,U,6),.01)                   ;surgeon
 ... S DGDS(NAME,DFN)=X_U_$$GET1^DIQ(9000001,DFN,1102.99)   ;and age
 ... S $P(DGDS(NAME,DFN),U,3)=$$GET1^DIQ(45.7,+$P(DGZ,U,5),.01)  ;srv
 ... S $P(DGDS(NAME,DFN),U,4)=$$GET1^DIQ(9000001,DFN,1118)  ;community
 ... S $P(DGDS(NAME,DFN),U,5)=$G(RELDT)  ;cmi/anch/maw 2/22/2007 PATCH 1007 item 1007.36
 ... S DAYCT=$G(DAYCT)+1
 ;
 I $G(DAYCT) D LINES
 Q
 ;
 ;
LINES ; loop thru patients found and list in alpha order
 NEW NAME,DFN
 ;
 D SET^BDGADD("",.VALMCNT)
 D SET^BDGADD($$SP(5)_"Day Surgeries: "_DAYCT,.VALMCNT)
 D SET^BDGADD($$REPEAT^XLFSTR("-",48),.VALMCNT)
 ;
 S NAME=0 F  S NAME=$O(DGDS(NAME)) Q:NAME=""  D
 . S DFN=0 F  S DFN=$O(DGDS(NAME,DFN)) Q:'DFN  D LINE
 Q
 ;
LINE ; set up display line
 NEW LINE
 S LINE=$$SP(5)_$E($$GET1^DIQ(2,DFN,.01),1,20)                ;name
 S LINE=$$PAD(LINE,28)_$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 S LINE=$$PAD(LINE,38)_$E($P(DGDS(NAME,DFN),U),1,20)          ;surgeon
 S LINE=$$PAD(LINE,60)_$P(DGDS(NAME,DFN),U,2)                 ;age
 S LINE=$$PAD(LINE,70)_$E($P(DGDS(NAME,DFN),U,3),1,18)        ;service
 S LINE=$$PAD(LINE,90)_$E($P(DGDS(NAME,DFN),U,4),1,20)        ;village
 S LINE=$$PAD(LINE,112)_$P(DGDS(NAME,DFN),U,5)                ;release date cmi/anch/maw 2/22/2007 added PATCH 1007 item 1007.36
 D SET^BDGADD(LINE,.VALMCNT)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
