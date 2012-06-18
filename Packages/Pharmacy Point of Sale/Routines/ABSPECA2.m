ABSPECA2 ; IHS/FCS/DRS - Assemble formatted claim ;  [ 09/12/2002  9:57 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Put together ascii formatted record via NCPDP Record definition
 ;
 ;Input Variables:  NODES     - (10^20 or 30^40)
 ;                  .IEN      - Internal Entry Number array
 ;                  .ABSP     - Formatted Data Array with claim and
 ;                              prescription data
 ;                  .REC      - Formatted Ascii record (result)
 ;----------------------------------------------------------------------
XLOOP(NODES,IEN,ABSP,REC) ;EP - from ABSPECA1
 ;Manage local variables
 N ORDER,RECMIEN,MDATA,FLDIEN,PMODE,FLAG,NODE,FDATA,FLDNUM,FLDDATA
 N INDEX,FLDID
 ;
 ;Loop through the NODES defined in NODES variable parsed by U
 F INDEX=1:1:$L(NODES,U) D
 .S NODE=$P(NODES,U,INDEX)
 .Q:NODE=""
 .Q:'$D(^ABSPF(9002313.92,IEN(9002313.92),NODE,0))
 .;
 .S ORDER=""
 .F  D  Q:'ORDER
 ..S ORDER=$O(^ABSPF(9002313.92,IEN(9002313.92),NODE,"B",ORDER))
 ..Q:'ORDER
 ..S RECMIEN=""
 ..S RECMIEN=$O(^ABSPF(9002313.92,IEN(9002313.92),NODE,"B",ORDER,RECMIEN))
 ..Q:RECMIEN=""
 ..S MDATA=$G(^ABSPF(9002313.92,IEN(9002313.92),NODE,RECMIEN,0))
 ..Q:MDATA=""
 ..S FLDIEN=$P(MDATA,U,2)
 ..Q:FLDIEN=""
 ..S FDATA=$G(^ABSPF(9002313.91,FLDIEN,0))
 ..Q:FDATA=""
 ..S FLDNUM=$P(FDATA,U,1)
 ..S FLDID=$P(FDATA,U,2)
 ..Q:FLDNUM=""
 ..S:NODE=10!(NODE=20) FLDDATA=$G(ABSP(9002313.02,IEN(9002313.02),FLDNUM,"I"))
 ..;I FLDNUM=402 S FLDDATA=$G(ABSP(9002313.0201,1,FLDNUM,"I")) ;for REVERSAL TYPE OF CLAIM. Added by GTI. 06-14-96
 ..S:NODE=30!(NODE=40) FLDDATA=$G(ABSP(9002313.0201,IEN(9002313.01),FLDNUM,"I"))
 ..S REC=REC_$S(FLDID="":"",1:$C(28))_FLDDATA
 Q
