ZIBFR ; IHS/ADC/GTH - LIST UCI'S FOR A GIVEN ROUTINE ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Given a routine name, this routine searches all UCIs and
 ; reports the first line of the selected routine to the user.
 ;
EN ;
 ;Q:'($ZV?1"MSM".E!($ZV?1"DSM".E))  ; Only works for MSM or DSM.;IHS/SET/GTH XB*3*9 10/29/2002
 S %=$$VERSION^%ZOSV(1) I '(%["Cache"),'(%["MSM") Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 R !,"Please enter full routine name to locate: ",%ZIB("RTN NAME"):$G(DTIME,300),!
 ; G:"^"[%ZIB("RTN NAME") EX ;IHS/SET/GTH XB*3*9 10/29/2002
 G:"^"[%ZIB("RTN NAME") EXIT ;IHS/SET/GTH XB*3*9 10/29/2002
 S:%ZIB("RTN NAME")["^" %ZIB("RTN NAME")=$P(%ZIB("RTN NAME"),"^",2) ;IHS/SET/GTH XB*3*9 10/29/2002
 S %ZIB("OP SYS")=$ZV ; Set operating system.
 I %ZIB("OP SYS")["Cache" G CACHE ;IHS/SET/GTH XB*3*9 10/29/2002
 S %ZIB("CURR UCI NBR")=$P($ZU($P($ZU(0),","),$P($ZU(0),",",2)),",") ; Save current UCI nbr.
 S %ZIB("CURR VOL NBR")=$P($ZU($P($ZU(0),","),$P($ZU(0),",",2)),",",2) ; Save current VOL nbr.
 ; S:%ZIB("RTN NAME")["^" %ZIB("RTN NAME")=$P(%ZIB("RTN NAME"),"^",2) ;IHS/SET/GTH XB*3*9 10/29/2002
 D  ; Loop until last UCI of last VOLUME SET.
 . S $ZT="ZT" ; Set error trap for DSM <NOSYS>.
 . F %ZIB("VOL NBR")=0:1 Q:$ZU(1,%ZIB("VOL NBR"))!($ZU(1,%ZIB("VOL NBR"))="")  D
 .. S $ZT="ZT" ; Set error trap for DSM <NOUCI>.
 .. F %ZIB("UCI NBR")=1:1 Q:$ZU(%ZIB("UCI NBR"),%ZIB("VOL NBR"))!($ZU(%ZIB("UCI NBR"),%ZIB("VOL NBR"))="")  D
 ... Q:$E(%ZIB("RTN NAME"))="%"&(%ZIB("UCI NBR")'=1)  ; MGR routine.
 ... I %ZIB("OP SYS")?1"MSM".E D
 .... V 2:$J:%ZIB("VOL NBR")*32+%ZIB("UCI NBR"):2 ; MSM switch to next UCI.
 ... E  V 148:$J:$V(148,$J)#256+(%ZIB("VOL NBR")*32+%ZIB("UCI NBR"))*256 ; DSM switch to next UCI.
 ... S X=%ZIB("RTN NAME")
 ... X ^%ZOSF("TEST")
 ... I  D
 .... X "ZL @%ZIB(""RTN NAME"") S %ZIB(""RTN FIRST LINE"")=$T(+1)"
 .... W !!,$ZU(0),?10,"Routine - ",%ZIB("RTN NAME")," - was last saved on ",$P($P(%ZIB("RTN FIRST LINE"),"[",2),"]")
 .... W !,%ZIB("RTN FIRST LINE") ; Display first line of routine.
 I %ZIB("OP SYS")?1"MSM".E V 2:$J:%ZIB("CURR VOL NBR")*32+%ZIB("CURR UCI NBR"):2 ; Return to current UCI MSM.
 E  V 148:$J:$V(148,$J)#256+(%ZIB("CURR VOL NBR")*32+%ZIB("CURR UCI NBR"))*256) ; Return to current UCI DSM.
EXIT ;IHS/SET/GTH XB*3*9 10/29/2002 Label EX changed to EXIT.
 KILL %ZIB
ENQ ;
 Q
 ;Begin New Code;IHS/SET/GTH XB*3*9 10/29/2002
CACHE ;
 S $ZT="BACK^%ETN"
 S %ZIB("CURR NSP")=$ZU(5)
 F I=1:1:$ZU(90,0) S ZIBLIST($ZU(90,2,0,I))=""
 S ZIBFUCI="" F  S ZIBFUCI=$O(ZIBLIST(ZIBFUCI)) Q:ZIBFUCI=""  D
 .I $ZU(5,ZIBFUCI)
 .S X=%ZIB("RTN NAME")
 .X "I X?1(1""%"",1A).7AN,$D(^$R(X))"
 .I  D
 ..X "ZL @%ZIB(""RTN NAME"") S %ZIB(""RTN FIRST LINE"")=$T(+1),%ZIB(""RTN SECOND LINE"")=$T(+2)"
 ..W !!,$ZU(5),?10,"Routine - ",%ZIB("RTN NAME")," - was last compiled on ",$$CDATE(%ZIB("RTN NAME"))
 ..W !,%ZIB("RTN FIRST LINE") ; Display first line of routine.
 ..W !,%ZIB("RTN SECOND LINE"),!  ; Display second line
 I $ZU(5,%ZIB("CURR NSP"))     ; Go back to original Namespace
 D EN^XBVK("ZIB")
 KILL I,X
 G EXIT
 ;
CDATE(%ZIBRTN) ; retrieve date of last edit on Cache only
 Q $$DATE^%R(%ZIBRTN_".INT",1)
 ;
 ;End New Code;IHS/SET/GTH XB*3*9 10/29/2002
ZT ; ERROR TRAP
 Q:$ZE["<NOSYS"!($ZE["<NOUCI")
ZTQ ;
 ZQ
 ;
