ABSPECR2 ; IHS/FCS/DRS - JWS 10:24 AM 19 Dec 1995 ;   [ 09/12/2002  10:00 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;NCPDP Record Print-Out
 ; Why this and not ABSPECR1?  Don't know.
 ; Just carrying it along for now.
 ;----------------------------------------------------------------------
EN1 ;
 ;Open 10:(MODE="W":FILE="A:NCPDP-R.TXT")
 ;Use 10
 ;S NEXTIEN=0
 ;F  D  Q:'+NEXTIEN
 ;.S NEXTIEN=$ORDER(^ABSPF(9002313.92,NEXTIEN))
 ;.Q:'+NEXTIEN
 ;.D R2(NEXTIEN)
 S NEXTIEN=8
 D R2(NEXTIEN)
 ;Close 10
 Q
 ;----------------------------------------------------------------------
EN2(NEXTIEN) ;
 ;Open 10:(MODE="W":FILE="A:NCPDP-R.TXT")
 ;Use 10
 D R2(NEXTIEN)
 ;Close 10
 Q
 ;---------------------------------------------------------------------
R2(IEN) ;EP -
 N FDATA,FIEN,GCODE,GN,MDATA,MIEN,NODE,ORDER,RDATA,XFLAG
 N POSITION,LENGTH,GSPOS S POSITION=1
 N IENS S IENS=IEN_","
 I '$G(IOM) N IOM S IOM=80
 D R2HEADER(IEN)
 F NODE=10,20,30,40 D
 .W !
 .I NODE=10 W "Claim Header (Required) Record:",!!
 .I NODE=20 W "Claim Header (Optional) Record:",!!
 .I NODE=30 D
 . . I '$$GET1^DIQ(9002313.92,IENS,1.07,"I") D
 . . . D GS W !
 . . . S GSPOS=POSITION
 . . W "Claim Information (Required) Record:",!!
 .I NODE=40 W "Claim Information (Optional) Record:",!!
 .S ORDER=0
 .F  D  Q:'+ORDER
 ..S ORDER=$ORDER(^ABSPF(9002313.92,IEN,NODE,"B",ORDER))
 ..Q:'+ORDER
 ..S MIEN=$ORDER(^ABSPF(9002313.92,IEN,NODE,"B",ORDER,""))
 ..Q:'+MIEN
 ..S MDATA=$G(^ABSPF(9002313.92,IEN,NODE,MIEN,0))
 ..I $P(MDATA,U,3)="" S $P(MDATA,U,3)="S" ; defaults to Standard mode
 ..S FIEN=$P(MDATA,U,2)
 ..Q:'+FIEN
 ..S FDATA=$G(^ABSPF(9002313.91,FIEN,0))
 ..S LENGTH=$P(FDATA,U,5)
 ..I NODE=20!(NODE=40) S LENGTH=LENGTH+3
 ..S:$P(MDATA,U,3)="X" XFLAG(NODE,MIEN)=FIEN
 ..W $J(ORDER,3),"  "
 ..W $J($P(FDATA,U,1),3),"  "
 ..W $J(POSITION,3)
 ..I LENGTH>1 D
 ...W "-",$J(POSITION+LENGTH-1,3)
 ..E  D
 ...W " ","   "
 ..W "  "
 ..S POSITION=POSITION+LENGTH
 ..W $P(MDATA,U,3),"  "
 ..W $P(FDATA,U,3),!
 ;W !,"Total length of claim record: ",POSITION-1," bytes",!
 ; more claims in the same packet, maybe
 I $G(GSPOS) N CLAIMLEN S CLAIMLEN=POSITION-GSPOS ; length of one claim
 F N=2:1:$$GET1^DIQ(9002313.92,IENS,1.03) D CLAIM(N)
 ;W #
 D:$D(XFLAG)
 .;D R2HEADER(IEN)
 .F NODE=10,20,30,40 D
 ..Q:'$D(XFLAG(NODE))
 ..W !
 ..S MIEN=""
 ..F  D  Q:'+MIEN
 ...S MIEN=$ORDER(XFLAG(NODE,MIEN))
 ...Q:'+MIEN
 ...S FIEN=$G(XFLAG(NODE,MIEN))
 ...Q:FIEN=""
 ...S RDATA=$G(^ABSPF(9002313.91,FIEN,0))
 ...Q:RDATA=""
 ...W $J($P(RDATA,U,1),3),?10,$P(RDATA,U,3),!
 ...S GN=0
 ...F  D  Q:'+GN
 ....S GN=$ORDER(^ABSPF(9002313.92,IEN,NODE,MIEN,1,GN))
 ....Q:'+GN
 ....S GCODE=$G(^ABSPF(9002313.92,IEN,NODE,MIEN,1,GN,0))
 ....W ?10,"X",GN,":  ",GCODE,!
 .W #
 Q
GS ; where a group separator occurs
 W "          ",$J(POSITION,3),"         "
 W "Group Separator ($C(29))",!
 S POSITION=POSITION+1
 Q
CLAIM(N) ; where 2nd, 3rd, 4th claims go
 W !
 D GS ; a group separator comes first
 W "          ",$J(POSITION,3)
 W "-",$J(POSITION+CLAIMLEN-1,3),"     "
 W "Claim #",N,!
 S POSITION=POSITION+CLAIMLEN
 Q
 ;----------------------------------------------------------------------
R2HEADER(IEN) ;
 W $$GET1^DIQ(9002313.92,IENS,.01)
 W " (`",IEN,")",!
 W $TR($J("",IOM)," ","-"),!
 I '$$GET1^DIQ(9002313.92,IENS,1.07,"I") D  ; if not a reversal format
 . N FIELD S FIELD=1
 . F  S FIELD=$O(^DD(9002313.92,FIELD)) Q:'FIELD  D
 . . I FIELD'<10,FIELD'>40 Q
 . . I FIELD=1.07 Q  ; "Is A Reversal Format"
 . . W $$GET1^DID(9002313.92,FIELD,,"LABEL"),": "
 . . W $$GET1^DIQ(9002313.92,IENS,FIELD)
 . . W !
 Q
