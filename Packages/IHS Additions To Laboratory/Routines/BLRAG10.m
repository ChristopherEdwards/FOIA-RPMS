BLRAG10 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCs ;
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;
 ; See the BLRAG00 routine for a listing of LABORATORY ACCESSION GUI RPCs
 ;
DEVICE(BLRXY) ;EP List of printers
 ;BLR PRINTERS AVAILABLE
 ; OUTPUT:
 ;       DEVICE_IEN ^ DEVICE_NAME
 ;
 N BLRII,FROM,DIR
 S BLRII=0
 S BLRXY=$$TMPGLB^BLRAGUT()
 S @BLRXY@(BLRII)="I00030PRINTER_IEN^T00040PRINTER_NAME"
 N CNT,IEN,X,Y,X0,XLOC,XSEC,XTYPE,XSTYPE,XTIME,XOSD,MW,PL,DEV
 S FROM="",DIR=1
 F  S FROM=$O(^%ZIS(1,"B",FROM),DIR),IEN=0 Q:FROM=""  D
 .F  S IEN=$O(^%ZIS(1,"B",FROM,IEN)) Q:'IEN  D
 ..S DEV="",X0=$G(^%ZIS(1,IEN,0)),XLOC=$P($G(^(1)),U),XOSD=+$G(^(90)),MW=$G(^(91)),XSEC=$G(^(95)),XSTYPE=+$G(^("SUBTYPE")),XTIME=$P($G(^("TIME")),U),XTYPE=$P($G(^("TYPE")),U)
 ..Q:$E($G(^%ZIS(2,XSTYPE,0)))'="P"                ; Printers only
 ..Q:"^TRM^HG^CHAN^OTH^"'[(U_XTYPE_U)
 ..Q:$P(X0,U,2)="0"!($P(X0,U,12)=2)                ; Queuing allowed
 ..I XOSD,XOSD'>DT Q                               ; Out of Service
 ..I $L(XTIME) D  Q:'$L(XTIME)                     ; Prohibited Times
 ...S Y=$P($H,",",2),Y=Y\60#60+(Y\3600*100),X=$P(XTIME,"-",2)
 ...S:X'<XTIME&(Y'>X&(Y'<XTIME))!(X<XTIME&(Y'<XTIME!(Y'>X))) XTIME=""
 ..I $L(XSEC),$G(DUZ(0))'="@",$TR(XSEC,$G(DUZ(0)))=XSEC Q
 ..S PL=$P(MW,U,3),MW=$P(MW,U),X=$G(^%ZIS(2,XSTYPE,1))
 ..S:'MW MW=$P(X,U)
 ..S:'PL PL=$P(X,U,3)
 ..S X=$P(X0,U)
 ..Q:$E(X,1,4)["NULL"
 ..S:X'=FROM X=FROM_"  <"_X_">"
 ..S BLRII=BLRII+1,@BLRXY@(BLRII)=IEN_U_$P(X0,U)
 Q
 ;
RETDTA(RESULT) ; EP - Return Days To Accession XPAR Parameter
 ; RPC: BLR XPAR DAYS TO ACCESSION
 ;INPUT:
 ;      None.
 ;
 ;RETURNS:
 ;      Value of the BLR DAYS TO ACCESSION parameter, if it exists
 ;      0 if the parameter does not exist
 ;
 NEW BLRDOM,BLRENT,BLRI,BLRPAR
 ;
 S BLRDOM=$$GET1^DIQ(8989.3,"1,",.01,"I")
 S BLRENT=BLRDOM_";"_"DIC(4.2,"
 S BLRPAR=+$O(^XTV(8989.51,"B","BLR DAYS TO ACCESSION",0))
 S RESULT=+$$GET^XPAR(BLRENT,BLRPAR,1,"Q")
 Q
