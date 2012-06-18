XBVIDEO ; IHS/ADC/GTH - SET VIDEO ATTRIBUTES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Thanks to Don Jackson, DSD/OIRM, for the original routine.
 ;
 ; Set various video attributes.  $X is saved and the cursor
 ; is returned to it's original position thru X IOXY (except
 ; certain attributes).
 ;
 ; In addition to the attributes supported by ENDR^%ZISS,
 ; some color attributes are supported, and other mnemonics
 ; to provide for backward compatibility.
 ;
 ;
 Q
 ;
EN(XB) ;PEP - Set video attribute in XB.  E.g. D EN^XBVIDEO("IOBOFF").
 ;
 Q:'$L($G(XB))
 Q:$D(ZTQUEUED)
 ;
 NEW DX,DY,XBXY
 S DX=$X,DY=$Y,XBXY=0
 ;
 I '$G(IOST(0)) D HOME^%ZIS
 U IO(0)
 ;
 I $L($T(@XB)),$L($P($T(@XB),";;",6)) S XBXY=$P($T(@XB),";;",7),XB=$P($T(@XB),";;",6)
 I $L($T(@XB^%ZISS)) S X=XB D ENDR^%ZISS W @XB X:XBXY IOXY U IO Q
 ;
 I '$L($T(@XB)) U IO Q
 ;
 S XB("LN")=$T(@XB),XB(1)=$P(XB("LN"),";;",2),XB(2)=$P(XB("LN"),";;",3),XB(3)=$P(XB("LN"),";;",4)
 S XB=$P($G(^%ZIS(2,+IOST(0),XB(1))),"^",XB(2),XB(3))
 I XB="" S XB="*0"
 W @XB
 X:XBXY IOXY
 U IO
 Q
 ;
 ; Global locations for mnenomics and colors supported by %ZISS.
 ;
 ;;<subscript>;;<beginning piece>;;<ending piece>;;<desc>;;<var name>;;<X IOXY flag>
 ;
10 ;;5;;1;;1;;TEN PITCH;;IOPTCH10;;1
12 ;;5;;2;;2;;TWELVE PITCH;;IOPTCH12;;1
16 ;;12.1;;1;;250;;SIXTEEN PITCH;;IOPTCH16;;1
BLF ;;5;;9;;9;;BLINK OFF;;IOBOFF;;1
BLN ;;5;;8;;8;;BLINK ON;;IOBON;;1
CLR ;;6;;1;;1;;RESET;;IORESET;;1
CUP ;;8;;1;;1;;CURSOR UP;;IOCUU;;0
DTB ;;17;;2;;2;;DOUBLE HIGH BOTTOM HALF;;IODHLB;;0
DTP ;;17;;1;;1;;DOUBLE HIGH TOP HALF;;IODHLT;;0
HIF ;;7;;2;;2;;HI INTENSITY OFF;;IOINORM;;1
HIN ;;7;;1;;1;;HI INTENSITY ON;;IOINHI;;1
HOM ;;5;;3;;3;;HOME CURSOR;;IOHOME;;0
IOF ;;1;;2;;2;;FORM FEED/CLEAR SCREEN;;;;0
RVF ;;5;;5;;5;;REVERSE VIDEO OFF;;IORVOFF;;1
RVN ;;5;;4;;4;;REVERSE VIDEO ON;;IORVON;;1
ULF ;;6;;5;;5;;UNDERLINE OFF;;IOUOFF;;1
ULN ;;6;;4;;4;;UNDERLINE ON;;IOUON;;1
 ;
 ; Global locations for mnenomics and colors UN-supported by %ZISS.
 ;;<subscript>;;<beginning piece>;;<ending piece>;;<desc>;;<>;;<X IOXY flag>
CYB ;;C;;3;;3;;CYAN BACKGROUND;;;;1
GRF ;;C;;1;;1;;GREEN FOREGROUND;;;;1
REB ;;C;;5;;5;;RED BACKGROUND;;;;1
WHF ;;C;;4;;4;;WHITE FOREGROUND;;;;1
YEF ;;C;;2;;2;;YELLOW FOREGROUND;;;;1
 ;
