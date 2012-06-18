ABSPECR1 ; IHS/FCS/DRS - JWS 10:21 AM 6 Dec 1995 ;  [ 09/12/2002  9:59 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;NCPDP Record Print-Out
 ;   EN to print all formats
 ;   R2^ABSPECR1(ien) to print just one format
 ;----------------------------------------------------------------------
EN N POP,NEXTIEN
 D ^%ZIS Q:$G(POP)
 U IO
 S NEXTIEN=0
 F  D  Q:'+NEXTIEN
 .S NEXTIEN=$O(^ABSPF(9002313.92,NEXTIEN))
 .Q:'+NEXTIEN
 .D R2(NEXTIEN)
 D ^%ZISC
 Q
 ;---------------------------------------------------------------------
R2(IEN) ;
 D R2^ABSPECR2(IEN)
 Q
 ; the rest of this was pretty much duplicated in ABSPECR2
 ; we enhanced what was there, too.
 ; so what follows is obsolete and can be deleted
 N FD,FIEN,GCODE,GN,MD,MIEN,NODE,O,RD,XFLAG
 Q:IEN=""
 Q:$D(^ABSPF(9002313.92,IEN,0))=0
 D R2HEADER(IEN)
 F NODE=10,20,30,40 D
 .W !
 .I NODE=10 W "Claim Header (Required) Record:",!!
 .I NODE=20 W "Claim Header (Optional) Record:",!!
 .I NODE=30 W "Claim Information (Required) Record:",!!
 .I NODE=40 W "Claim Information (Optional) Record:",!!
 .S O=0
 .F  D  Q:'+O
 ..S O=$O(^ABSPF(9002313.92,IEN,NODE,"B",O))
 ..Q:'+O
 ..S MIEN=$O(^ABSPF(9002313.92,IEN,NODE,"B",O,""))
 ..Q:'+MIEN
 ..S MD=$G(^ABSPF(9002313.92,IEN,NODE,MIEN,0))
 ..S FIEN=$P(MD,U,2)
 ..Q:'+FIEN
 ..S FD=$G(^ABSPF(9002313.91,FIEN,0))
 ..S:$P(MD,U,3)="X" XFLAG(NODE,MIEN)=FIEN
 ..W $J(O,3),"   ",$J($P(FD,U,1),3),"   ",$P(MD,U,3),"   ",$P(FD,U,3),!
 H 1
 W @IOF
 D:$D(XFLAG)
 .D R2HEADER(IEN)
 .F NODE=10,20,30,40 D
 ..Q:'$D(XFLAG(NODE))
 ..W !
 ..S MIEN=""
 ..F  D  Q:'+MIEN
 ...S MIEN=$O(XFLAG(NODE,MIEN))
 ...Q:'+MIEN
 ...S FIEN=$G(XFLAG(NODE,MIEN))
 ...Q:FIEN=""
 ...S RD=$G(^ABSPF(9002313.91,FIEN,0))
 ...Q:RD=""
 ...W !,$J($P(RD,U,1),3),?10,$P(RD,U,3),!
 ...S GN=0
 ...F  D  Q:'+GN
 ....S GN=$O(^ABSPF(9002313.92,IEN,NODE,MIEN,1,GN))
 ....Q:'+GN
 ....S GCODE=$G(^ABSPF(9002313.92,IEN,NODE,MIEN,1,GN,0))
 ....W ?10,"X",GN,":  ",GCODE,!
 .H 1
 .W @IOF
 Q
 ;----------------------------------------------------------------------
R2HEADER(IEN) ;
 W "NCPDP Record Definition"
 W $$RJBF^ABSPECFM($P($G(^ABSPF(9002313.92,IEN,0)),U,1),IOM-23),!
 W $TR($J("",IOM)," ","-"),!
 Q
