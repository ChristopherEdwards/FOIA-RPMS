BLRMENU ; IHS/OIT/MKK - BLRMENU & SUBMENU HEADERS ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1025,1034**;NOV 01, 1997;Build 88
 ;
 Q
 ;
HDR ; EP
 D ^XBCLS
 W $$CJ^XLFSTR("IHS Lab Main Support Menu",IOM)
 Q
 ;
CUMHDR ; EP
 D ^XBCLS
 W $$CJ^XLFSTR("IHS Lab Cumulative Report Menu",IOM)
 Q
 ;
CLRHDR ; EP
 D ^XBCLS
 W $$CJ^XLFSTR("IHS Lab Clear BLR Errors Menu",IOM)
 Q
 ;
REFLHDR ; EP
 D ^XBCLS
 W $$CJ^XLFSTR("IHS Lab Reference Lab Menu",IOM)
 Q
 ;
GENHDR(STR) ; EP
 D ^XBCLS
 W $$CJ^XLFSTR(STR,IOM)
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
LRMENHDR ; EP - LRMENU HeaDeR
 D NOTCHDR("Laboratory Menu",10)
 Q
 ;
BLRNCHDR ; EP - BLRMENU Non Centered HeaDeR
 D NOTCHDR("IHS Lab Main Support Menu",10)
 Q
 ;
BLR2HDR ; EP - Secondary version of BLRMENU Header
 D NOTCHDR("IHS Lab Main Support Menu",10)
 Q
 ;
NOTCHDR(STR,TAB) ; EP - NOT Centered HeaDeR
 D ^XBCLS
 S TAB=$G(TAB,5)
 W ?TAB,STR
 Q
 ;
EXITACT(IEN) ; EP - EXIT Action
 D GENHDR($$GET1^DIQ(19,IEN,"MENU TEXT"))
 Q
 ;
EXITACTN(IEN,TAB) ; EP - Exit Action -- Not centered
 D NOTCHDR($$GET1^DIQ(19,IEN,"MENU TEXT"),$G(TAB))
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
