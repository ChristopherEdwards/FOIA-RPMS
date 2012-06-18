BDGADS2 ; IHS/ANMC/LJF - A&D SUMMARY-DAY SURGERY ;  
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/22/2007 added day surgery release date/time PATCH 1007 item 1007.36
 ;
 ; check VA Surgery file for data
 S X="BSRPEP" X ^%ZOSF("TEST") I $T D  Q
 . NEW DAYCT,DGDS
 . S DAYCT=$$ADS^BSRPEP("S",BDGT)   ;returns DGDS array
 . I DAYCT>0 D LINES
 ;
 ;
 ; And then IHS Day Surgery file
 NEW DATE,DFN,DSN,DAYCT,DGDS,NAME,DGZ
 S DATE=BDGT-.0001,END=BDGT+.24,DGDAYCT=0
 F  S DATE=$O(^ADGDS("AA",DATE)) Q:'DATE  Q:DATE>END  D
 . S DFN=0
 . F  S DFN=$O(^ADGDS("AA",DATE,DFN)) Q:'DFN  D
 .. S DSN=0 F  S DSN=$O(^ADGDS("AA",DATE,DFN,DSN)) Q:'DSN  D
 ... ;
 ... Q:'$D(^ADGDS(DFN,"DS",DSN,0))  S DGZ=^(0)
 ... ;IHS/ITSC/WAR 10/31/03 Chgd next line
 ... ;I $P($G(^ADGDS(DFN,"DS",DGDSN,2)),U,3,4)["Y"  Q   ;noshow/cancel
 ... I $P($G(^ADGDS(DFN,"DS",DSN,2)),U,3,4)["Y"  Q   ;noshow/cancel
 ... S RELDT=$$FMTE^XLFDT($P($G(^ADGDS(DFN,"DS",DSN,2)),U))  ;release date cmi/anch/maw 2/22/2007 PATCH 1007 item 1007.36
 ... ;
 ... S NAME=$$GET1^DIQ(2,DFN,.01)                      ;patient name
 ... S DGDS(NAME,DFN)=$P(DGZ,U,5)                      ;service ien
 ... S $P(DGDS(NAME,DFN),U,5)=$G(RELDT)  ;cmi/anch/maw 2/22/2007 PATCH 1007 item 1007.36
 ... S DAYCT=$G(DAYCT)+1
 ;
 I $G(DAYCT)>0 D LINES
 Q
 ;
 ;
LINES ; loop thru  day surgery patients found and list in alpha order
 NEW NAME,DFN
 ;
 D SET^BDGADS($$SP(5)_"Day Surgeries: "_DAYCT,.VALMCNT)
 D SET^BDGADS($$REPEAT^XLFSTR("-",48),.VALMCNT)
 ;
 S NAME=0 F  S NAME=$O(DGDS(NAME)) Q:NAME=""  D
 . S DFN=0 F  S DFN=$O(DGDS(NAME,DFN)) Q:'DFN  D LINE
 Q
 ;
LINE ; set up display line
 NEW LINE
 S LINE=$$GET1^DIQ(45.7,+$P(DGDS(NAME,DFN),U),99)             ;service
 S LINE=$$PAD(LINE,6)_$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 S LINE=$$PAD(LINE,16)_$E(NAME,1,20)                          ;name
 S LINE=$$PAD(LINE,40)_$P(DGDS(NAME,DFN),U,2)                 ;va status
 S LINE=$$PAD(LINE,50)_$P(DGDS(NAME,DFN),U,5)                ;release date cmi/anch/maw 2/22/2007 added PATCH 1007 item 1007.36
 D SET^BDGADS(LINE,.VALMCNT)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
