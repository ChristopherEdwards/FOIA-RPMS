ABSPOSCG ; IHS/SD/RLT - Set up ABSP() - CONT;      [ 05/22/2006  9:00 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**17,20,21,22,42**;MAY 22, 2006
 ;---
 ;IHS/SD/RLT - 05/22/06 - Patch 17
 ;    Created new routine ABSPOSCC getting too large.
 ;    Added new code to access RR D elig data.
 ;---
 ;IHS/SD/RLT - 03/26/07 - Patch 20
 ;    Added the following tags called from ABSPOSCC:
 ;       GETMDPOL
 ;       GETMDIEN
 ;---
 ;IHS/SD/RLT - 05/10/07 - Patch 21
 ;   Added new tags MDFLG and RRDFLG.
 ;---
 ;IHS/SD/RLT - 05/22/07 - Patch 21
 ;   Added new tag PHARNPI.
 ;---
 ;IHS/SD/RLT - 07/25/07 - Patch 22
 ;   Fixed typo in tag RRDOB.
 Q
 ;
GETRRDPL() ;EP    ^ABSPOSCC
 N POL,RRDPOL
 S POL=$P($G(^AUPNRRE(PINSDA,0)),U,4)      ;orig
 S RRDPOL=""
 S:RRDFLG&(RRDIEN) RRDPOL=$P($G(^AUPNRRE(PINSDA,11,RRDIEN,0)),U,6)
 S:RRDPOL'="" POL=RRDPOL
 Q POL
 ;
RRNAME() ;EP    ^ABSPOSCC
 N NAME,RRDNAME
 S NAME=$P($G(^AUPNRRE(PINSDA,21)),U)       ;orig
 S RRDNAME=""
 S:RRDFLG&(RRDIEN) RRDNAME=$P($G(^AUPNRRE(PINSDA,11,RRDIEN,0)),U,5)  ;RR D
 S:RRDNAME'="" NAME=RRDNAME
 Q NAME
 ;
RRDOB() ;EP    ^ABSPOSCC
 N DOB,RRDDOB
 S DOB=$P($G(^AUPNRRE(PINSDA,21)),U,2)      ;orig
 S RRDDOB=""
 ;S:RREFLG&(RRDIEN) RRDDOB=$P($G(^AUPNRRE(PINSDA,11,RRDIEN,0)),U,9)  ;RR D
 S:RRDFLG&(RRDIEN) RRDDOB=$P($G(^AUPNRRE(PINSDA,11,RRDIEN,0)),U,9)  ;RR D
 S:RRDDOB'="" DOB=RRDDOB
 Q DOB
 ;
RRDFLG() ;EP     ^ABSPOSCC
 N FMTIEN,RRDFLG
 ;IHS/OIT/CASSEVER/RAN 03/24/2011 patch 42 Get rid of references to formats for new method of claims processing
 I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . S RRDFLG=$$GET1^DIQ(9002313.4,INSIEN_",",100.18,"I")
 ELSE  D
 . S FMTIEN=$P($G(^ABSPEI(INSIEN,100)),U)
 . S RRDFLG=$P($G(^ABSPF(9002313.92,FMTIEN,1)),U,11)
 Q RRDFLG
 ;
GETRRD() ;EP    ^ABSPOSCC
 ;Get IEN for Railroad D elig record lookup.
 ;Railroad D eligibiiltiy lookup.
 ;N RRDFND,D1
 ;S RRDFND=""
 ;S D1="A"
 ;F  S D1=$O(^AUPNRRE(PINSDA,11,D1),-1) Q:'D1!(RRDFND)  D
 ;. Q:$P($G(^AUPNRRE(PINSDA,11,D1,0)),U,3)'="D"         ;coverage type
 ;. S RRDFND=1
 ;. S RRDIEN=D1
 ;Q:'RRDFND ""
 ;Q RRDIEN
 Q ""
 ;
GETMDPOL() ;EP    ^ABSPOSCC
 ;Updated policy number lookup for Medicare D elig.
 N POL,MDPOL
 S POL=$P($G(^AUPNMCR(PINSDA,0)),U,3)       ;original
 S MDPOL=""
 ;S:MDIEN'="" MDPOL=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,6)
 S:MDFLG&(MDIEN) MDPOL=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,6)
 S:MDPOL'="" POL=MDPOL                      ;MPD
 Q POL
 ;
MDFLG() ;EP     ^ABSPOSCC
 N FMTIEN,MDFLG
 ;IHS/OIT/CASSEVER/RAN 03/24/2011 patch 42 Get rid of references to formats for new method of claims processing START
 I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . S MDFLG=$$GET1^DIQ(9002313.4,INSIEN_",",100.18,"I")
 ELSE  D
 . S FMTIEN=$P($G(^ABSPEI(INSIEN,100)),U)
 . S MDFLG=$P($G(^ABSPF(9002313.92,FMTIEN,1)),U,11)
 Q MDFLG
 ;
GETMDIEN() ;EP    ^ABSPOSCC
 ;Get IEN for Medicare D elig record lookup.
 ;New Medicare D eligibiiltiy lookup.
 ;N MDFND,D1
 ;S MDFND=""
 ;S D1="A"
 ;F  S D1=$O(^AUPNMCR(PINSDA,11,D1),-1) Q:'D1!(MDFND)  D
 ;. Q:$P($G(^AUPNMCR(PINSDA,11,D1,0)),U,3)'="D"         ;coverage type
 ;. S MDFND=1
 ;. S MDIEN=D1
 ;Q:'MDFND ""
 ;Q MDIEN
 Q ""
 ;
PHARNPI(X,Y) ;EP
 ;FILE #9002313.56 - ABSP PHARMACIES FILE
 ;MULTIPLE 13800 - OUTPATIENT SITE
 ;COMPUTED Field .02 - PHARMACY NPI #
 Q:$G(X)="" ""
 Q:$G(Y)="" ""
 N OPSITE,INST,NPI
 S OPSITE=$P($G(^ABSP(9002313.56,X,"OPSITE",Y,0)),U)
 Q:OPSITE="" ""
 S INST=$P($G(^PS(59,OPSITE,"INI")),U,2)
 Q:INST="" ""
 S NPI=$P($$NPI^XUSNPI("Organization_ID",INST),U)
 Q NPI
