BLRSLTL(BLRCMF,BLRPHASE,BLROPT1,BLRPARAM) ; IHS/DIR/MJL - SET IHS LAB TRANSACTION LOG ; [ 10/20/1999  8:45 AM ]
 ;;5.2;BLR;**1001,1003,1009**;SEP 20, 1999
 N X,Y
 D
 .I BLRPHASE="O" D  Q
 ..I BLROPT1="ADDCOL" D MODORD Q  ;IHS/DIR TUC/AAB 4/1/98
 ..I BLROPT1="MULTI" Q
 ..I BLROPT1="ACCWARD" Q
 ..I BLROPT1="BYPASS" Q  ;IHS/DIR/MJL 09/20/99
 ..I BLROPT1="FASTORD" D ACC Q
 ..D ORD Q
 .I BLRPHASE="A" D  Q
 ..I BLROPT1="ACCWARD",$D(LROD0) S BLRCMF="M",BLRODTM=$P(LROD0,U,5),BLRODT=LRODT,BLRSEQ=LRSN D ^BLRSLTL1 Q  ;IHS/OIRM TUC/AAB 2/17/98
 ..I BLROPT1="BYPASS"!(BLROPT1="ADDCOL")!(BLROPT1="ACCORD") Q
 ..S BLRODT=LRODT,BLRSEQ=LRSN D ^BLRSLTL1 Q
 .I BLRPHASE="R" D ^BLRSLTLR Q
 .I BLRPHASE="D" D ^BLRSLTLD Q
 D KILL
 Q
 ;
MODORD ;  ;IHS/DIR TUC/AAB 04/1/98
 S BLRODT=LRODT,BLRSEQ=LRSN
 S BLRODTM=$P(^LRO(69,LRODT,1,LRSN,0),U,5)
 D ^BLRSLTL1
 Q
ORD ;
 I BLRPHASE="O",BLROPT1="ADDORD" S BLRN1="" F  S BLRN1=$O(LROT(BLRN1)) Q:BLRN1=""  S BLRN2="" F  S BLRN2=$O(LROT(BLRN1,BLRN2)) Q:BLRN2=""  S BLRTSTS="" F  S BLRTSTS=$O(LROT(BLRN1,BLRN2,BLRTSTS)) Q:BLRTSTS=""  S BLRTSTS(BLRTSTS)=""
 S BLRODT=LRODT,BLRSEQ=LRSN D ^BLRSLTL1
 K BLRTSTS
 Q
 ;
ACC ;
 S BLRODT=LRODT,BLRSEQ=LRSN D ^BLRSLTL1
 Q
 ;
KILL ;
 K BLRACCN,BLRAREA,BLRATOM,BLRCMF,BLRCMP,BLRCOLS,BLRCPTF,BLRCPTL,BLRCPTP,BLRCREF,BLRCST,BLRDEL,BLRDFN,BLRDN,BLRDT,BLRDTC,BLRDUZ,BLRDUZ2,BLRDUZN,BLRFILE,BLRII,BLRL60,BLRLOC,BLRLOCN,BLRLPAR,BLRLRDFN,BLRLX,BLRMOD
 K BLRN1,BLRN2,BLRNAF,BLRODT,BLRODTM,BLROT,BLRPAR,BLRPREV,BLRPROV,BLRPROVN,BLRRES,BLRRH,BLRRL,BLRSEQ,BLRSPEC,BLRSPECN,BLRSTR,BLRSTR1,BLRSVX,BLRSVY,BLRTEST,BLRTEST1,BLRTESTI,BLRTST,BLRUNITS,BLRVAL,BLRX,BLRXII
 K BLRXSEQ,BLRXX,BLRY,BLRZ
 ;I BLRPHASE="R",(BLROPT1="BYPASS"!(BLROPT1="ACCORD")) K BLROPT,BLRPHASE Q
 I BLRPHASE="R",(BLROPT1="BYPASS") K BLROPT,BLRPHASE Q  ;IHS/DIR TUC/AAB 06/22/98
 ;I BLROPT1="BYPASS"!(BLROPT1="ACCORD")!(BLROPT1="DELACC") K BLRPHASE Q
 I BLROPT1="BYPASS"!(BLROPT1="ACCORD")!(BLROPT1="DELACC")!(BLROPT1="ACCWARD")!(BLROPT1="ADDCOL")!(BLROPT1="FASTORD")!(BLROPT1="RECCOL")!(BLROPT1="ITMCOL") K BLRPHASE Q  ;IHS/OIRM TUC/AAB 2/10/98
 ;K BLRPHASE,BLROPT ;IHS/DIR/MJL 09/20/99
 Q