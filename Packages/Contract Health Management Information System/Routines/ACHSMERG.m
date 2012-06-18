ACHSMERG ; IHS/ITSC/TPF/PMF - CHS PATIENT MERGE INTERFACE ; 
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**20**;JUN 11, 2001
 ;
 ; This entire routine is in support
 ; of the patient merge development and testing.
 ;
 ; XDRMRG("FR") contains DFN of FROM pt (one being merged away)
 ; XDRMRG("TO") contains DFN of TO pt (the one being kept)
 ;
 ;ACHS*3.1*20 IHS.OIT.FCJ 7-28-11 ADDED NXT LINE FOR CALL FROM MERGE ROUTINES
EN(XDRMRG) ;EP
 ;
 Q:'$D(XDRMRG("FR"))
 Q:'$D(XDRMRG("TO"))
 ;
 ; S XDRMRG("FR")=1062,XDRMRG("TO")=1064 ; *** FOR TESTING, ONLY
 ; S XDRMRG("FR")=1064,XDRMRG("TO")=1062 ; *** FOR TESTING, ONLY
 ;
 N L,D,T
 ;
 ; L = Location
 ; D = Document IEN
 ; T = Transaction IEN
 ;
 ; ^ACHSF(DA(1),"PB",+X,DA,1)
 ; ^ACHSF("AC",$E(X,1,30),DA(2),DA(1),DA)
 ; ^ACHSF(DA(2),"EOBP",+X,DA(1),DA,9999999-%)
 ;     The "PB" x-ref is more reliable.  The "AC" is only set at
 ;     final pay.
 ;     One entire document is merged, at once, rather than use the "PB"
 ;     for the Document record, then the "AC" for the transaction
 ;     records, to minimize the possibility of errors.
 ;
 S L=0
 ;
 F  S L=$O(^ACHSF(L)) Q:'L  S D=0 F  S D=$O(^ACHSF(L,"PB",XDRMRG("FR"),D)) Q:'D  D
 .K ^ACHSF(L,"PB",XDRMRG("FR"),D)
 .Q:'$D(^ACHSF(L,"D",D,0))
 .S $P(^ACHSF(L,"D",D,0),U,22)=XDRMRG("TO")
 .S ^ACHSF(L,"PB",XDRMRG("TO"),D,1)=""
 .S T=0
 .F  S T=$O(^ACHSF(L,"D",D,"T",T)) Q:'T  D
 ..K ^ACHSF("AC",XDRMRG("FR"),L,D,T)
 ..K ^ACHSF(L,"EOBP",XDRMRG("FR"),D,T)
 ..S $P(^ACHSF(L,"D",D,"T",T,0),U,3)=XDRMRG("TO")
 ..S ^ACHSF("AC",XDRMRG("TO"),L,D,T)=""
 ..S %=$P(^ACHSF(L,"D",D,"T",T,0),U,13)
 ..I % S ^ACHSF(L,"EOBP",XDRMRG("TO"),D,T,9999999-%)=""
 ..Q
 .Q
 ;
 ;
 ;
 ; L = Patient Name
 ; D = Denial IEN
 ;
 ; ^ACHSDEN("C",$P(^DPT(X,0),U,1),DA)
 ;
 S L=$P(^DPT(XDRMRG("FR"),0),U),D=0
 ;
 F  S D=$O(^ACHSDEN("C",L,D)) Q:'D  I $P(^ACHSDEN(D,0),U,4)="Y" D
 .K ^ACHSDEN("C",L,D)
 .S $P(^ACHSDEN(D,0),U,5)=XDRMRG("TO")
 .S ^ACHSDEN("C",$P(^DPT(XDRMRG("TO"),0),U),D)=""
 .Q
 ;
 Q
 ;
 ;
FR ;EP - From PACKAGE file, to determine if FR pt has data for pt merge.
 Q:'$D(XDRMRG("FR"))
 N L
 ;
 ; L = Location or Pt Name
 ;
 S L=0
 ;
 F  S L=$O(^ACHSF(L)) Q:'L  I $O(^ACHSF(L,"PB",XDRMRG("FR"),0)) S XDRZ=1 Q
 ;
 S L=$P(^DPT(XDRMRG("FR"),0),U),D=0
 ;
 F  S D=$O(^ACHSDEN("C",L,D)) Q:'D  I $P(^ACHSDEN(D,0),U,4)="Y" S XDRZ=1 Q
 ;
 Q
 ;
