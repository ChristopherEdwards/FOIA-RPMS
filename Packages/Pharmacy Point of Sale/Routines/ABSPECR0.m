ABSPECR0 ; IHS/FCS/DRS - JWS 02:16 PM 28 Sep 1995 ;   [ 09/12/2002  9:59 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ; Development utility:
 ;NCPDP FIELD Definitions Print-Out
 ;----------------------------------------------------------------------
EN ;
 N FIELD,GCODE,GETN,NEXTIEN,NEXTCODE,RDATA
 D ^%ZIS
 U IO
 W "NCPDP FIELD Definitions:",!
 W $TR($J("",IOM)," ","-"),!
 S NEXTIEN=0,NEXTCODE=""
 F  D  Q:NEXTCODE=""
 .S NEXTCODE=$O(^ABSPF(9002313.91,"B",NEXTCODE)) Q:NEXTCODE=""
 .S NEXTIEN=$O(^ABSPF(9002313.91,"B",NEXTCODE,0))
 .Q:'+NEXTIEN
 .S RDATA=$G(^ABSPF(9002313.91,NEXTIEN,0))
 .Q:RDATA=""
 .S FIELD=$P(RDATA,U,1)
 .W !,$J(FIELD,3)
 .I $P(RDATA,U,2)]"" W "-",$P(RDATA,U,2)
 .W ?15,$P(RDATA,U,3)
 .W "   Length: ",$P(RDATA,U,5)
 .W !
 .;
 .; "Get" code
 .;
 .W ?6,"Get:"
 .S GETN=0
 .F  D  Q:'+GETN
 ..S GETN=$O(^ABSPF(9002313.91,NEXTIEN,10,GETN))
 ..Q:'+GETN
 ..S GCODE=$G(^ABSPF(9002313.91,NEXTIEN,10,GETN,0))
 ..D PRINT
 .;
 .; "Format" code
 .;
 .W ?3,"Format:"
 .S GETN=0
 .F  D  Q:'+GETN
 ..S GETN=$O(^ABSPF(9002313.91,NEXTIEN,20,GETN))
 ..Q:'+GETN
 ..S GCODE=$G(^ABSPF(9002313.91,NEXTIEN,20,GETN,0))
 ..D PRINT
 .;
 .; "Set" code
 .;
 .W ?6,"Set:"
 .S GETN=0
 .F  D  Q:'+GETN
 ..S GETN=$O(^ABSPF(9002313.91,NEXTIEN,30,GETN))
 ..Q:'+GETN
 ..S GCODE=$G(^ABSPF(9002313.91,NEXTIEN,30,GETN,0))
 ..;W ?10,"S",GETN,":  ",GCODE,!
 ..D PRINT
 W !!,"Index",!!
 N X S X=""
 F  S X=$O(^ABSPF(9002313.91,"C",X)) Q:X=""  D
 . N Y S Y=$O(^ABSPF(9002313.91,"C",X,0))
 . S Y=$P(^ABSPF(9002313.91,Y,0),U)
 . W X," ",Y,!
 D ^%ZISC
 ;U $P
 Q
PRINT ;
 I '$G(IOM)<40 N IOM S IOM=80
 N C S C=IOM-11-2
 W ?11,$E(GCODE,1,C),!
 I $L(GCODE)>C N I F I=1:1:$L(GCODE)\C D
 . W ?7,"..."
 . W ?11,$E(GCODE,C*I+1,C*I+C)
 . W !
 Q
