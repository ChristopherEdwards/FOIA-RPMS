ABMECDS2 ; IHS/ASDST/DMJ - ELECTRONIC CLAIMS DISPLAY (SUMMARY) ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**19**;NOV 12, 2009;Build 300
 ;IHS/SD/SDR - 2.6*19 - HEAT138428 - Split routine from ABMECDSP.  Made changes for clearinghouse so it will create
 ;   one file for each visit location.
 ; *********************************************************************
 ;
DISP ;
 ; Display summary data
 S ABMSUMPG=1
 K ABMORE
 W !
 D SUMHEAD^ABMECDSP   ;Write summary page column headers
 ;start old abm*2.6*6 5010
 ;S ABMSEQ=0  ;Sequence number
 ;S ABMINS("IEN")=0   ;Activer insurer IEN
 ;F  S ABMINS("IEN")=$O(^TMP($J,"S",ABMINS("IEN"))) Q:'ABMINS("IEN")  D  Q:+ABMEQUIT
 ;.S ABMINS=$E($P($G(^AUTNINS(ABMINS("IEN"),0)),U),1,30)  ; Insurer
 ;.S ABMVTYPE=0   ;Bill type
 ;.F  S ABMVTYPE=$O(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE)) Q:'ABMVTYPE  D  Q:+ABMEQUIT
 ;..S ABMEXP=0   ;Mode of export
 ;..F  S ABMEXP=$O(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP)) Q:'ABMEXP  D  Q:+ABMEQUIT
 ;...S ABMTAMT=$P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U)   ;Total amount
 ;...S ABMCNT=$P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U,2)  ;Total count
 ;...S ABMEXPD=$P($G(^ABMDEXP(+ABMEXP,0)),U)  ;Export mode description
 ;...I $G(ABMORE) D SUMPGHD  ;if more than one page do page hdr
 ;...S ABMSEQ=ABMSEQ+1  ;increment sequence number
 ;...W !,$J(ABMSEQ,3),?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 ;...; ABMER(#)=Insurer^Visit Type^Export mode^total count^total charge
 ;...S ABMER(ABMSEQ)=ABMINS("IEN")_U_ABMVTYPE_U_+ABMEXP_U_ABMCNT_U_ABMTAMT  ; data array by sequence number
 ;...I $Y+5>IOSL D  Q:+ABMEQUIT
 ;....D RETURN
 ;....Q:+ABMEQUIT
 ;....S ABMORE=1
 ;end old start new abm*2.6*6 5010
 D GETCHS^ABMCUTL
 S ABMSEQ=0,ABMNEXT=0
 K ABMCHT
 K ^TMP($J,"S-CH")
 I $D(ABMCHLST) D  ;clearinghouse exists; add another sort level
 .S ABMP("CHIEN")=0,ABMSVTYP=0,ABMSEXP=0
 .F  S ABMP("CHIEN")=$O(ABMCHLST(ABMP("CHIEN"))) Q:'ABMP("CHIEN")  D
 ..S ABMP("CHINS")=0
 ..F  S ABMP("CHINS")=$O(ABMCHLST(ABMP("CHIEN"),ABMP("CHINS"))) Q:'ABMP("CHINS")  D
 ...I $D(^TMP($J,"S",ABMP("CHINS"))) D
 ....S ABMVTYP=0
 ....F  S ABMVTYP=$O(^TMP($J,"S",ABMP("CHINS"),ABMVTYP)) Q:'ABMVTYP  D
 .....S ABMEXP=0
 .....F  S ABMEXP=$O(^TMP($J,"S",ABMP("CHINS"),ABMVTYP,ABMEXP)) Q:'ABMEXP  D
 ......I $D(ABMCHLST(ABMP("CHIEN"),ABMVTYP,ABMEXP)) S ABMSEQ=$G(ABMCHLST(ABMP("CHIEN"),ABMVTYP,ABMEXP))
 ......I '$D(ABMCHLST(ABMP("CHIEN"),ABMVTYP,ABMEXP)) S (ABMSEQ,ABMNEXT)=ABMNEXT+1,ABMCHLST(ABMP("CHIEN"),ABMVTYP,ABMEXP)=ABMSEQ
 ......M ^TMP($J,"S-CH",ABMSEQ,ABMP("CHIEN"),ABMP("CHINS"),ABMVTYP,ABMEXP)=^TMP($J,"S",ABMP("CHINS"),ABMVTYP,ABMEXP)
 ......S ABMCHT(ABMSEQ,"AMT")=+$G(ABMCHT(ABMSEQ,"AMT"))+$P(^TMP($J,"S-CH",ABMSEQ,ABMP("CHIEN"),ABMP("CHINS"),ABMVTYP,ABMEXP),U)
 ......S ABMCHT(ABMSEQ,"VTYP")=ABMVTYP
 ......S ABMCHT(ABMSEQ,"EXP")=ABMEXP
 ......S ABMCHT(ABMSEQ,"TOT")=+$G(ABMCHT(ABMSEQ,"TOT"))+$P(^TMP($J,"S",ABMP("CHINS"),ABMVTYP,ABMEXP),U,2)
 ......K ^TMP($J,"S",ABMP("CHINS"),ABMVTYP,ABMEXP)
 ......S ABMSINS=ABMP("CHINS"),ABMSVTYP=ABMVTYP,ABMSEXP=ABMEXP
 ;
 S ABMSEQ=0  ;Sequence number
 F  S ABMSEQ=$O(^TMP($J,"S-CH",ABMSEQ)) Q:'ABMSEQ  D  Q:+ABMEQUIT
 .S ABM("CHIEN")=0  ;clearinghouse IEN
 .F  S ABM("CHIEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"))) Q:'ABM("CHIEN")  D  Q:+ABMEQUIT
 ..W !,$J(ABMSEQ,3),?6,"+ "_$P($G(^ABMRECVR(ABM("CHIEN"),0)),U)
 ..W ?38,$J(ABMCHT(ABMSEQ,"VTYP"),3),?44,$P($G(^ABMDEXP(ABMCHT(ABMSEQ,"EXP"),0)),U)
 ..W ?60,$J(ABMCHT(ABMSEQ,"TOT"),4),?69,$J($FN(ABMCHT(ABMSEQ,"AMT"),",",2),10)
 ..S ABMINS("IEN")=0  ;Activer insurer IEN
 ..F  S ABMINS("IEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"))) Q:'ABMINS("IEN")  D  Q:+ABMEQUIT
 ...S ABMINS=$E($P($G(^AUTNINS(ABMINS("IEN"),0)),U),1,30)  ;Insurer
 ...S ABMVTYPE=0  ;Bill type
 ...F  S ABMVTYPE=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE)) Q:'ABMVTYPE  D  Q:+ABMEQUIT
 ....S ABMEXP=0  ;Mode of export
 ....F  S ABMEXP=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE,ABMEXP)) Q:'ABMEXP  D  Q:+ABMEQUIT
 .....S ABMTAMT=$P(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE,ABMEXP),U)  ;Total amount
 .....S ABMCNT=$P(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE,ABMEXP),U,2)  ;Total count
 .....S ABMEXPD=$P($G(^ABMDEXP(+ABMEXP,0)),U)  ;Export mode desc
 .....I $G(ABMORE) D SUMPGHD^ABMECDSP  ;if more than one page do page hdr
 .....;W !
 .....;W ?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 .....; ABMER(#)=Insurer^Visit Type^Export mode^total count^total charge
 .....S ABMER(ABMSEQ)=ABM("CHIEN")_U_ABMVTYPE_U_+ABMEXP_U_ABMCNT_U_ABMTAMT  ;data array by sequence number
 .....I $Y+5>IOSL D  Q:+ABMEQUIT
 ......D RETURN^ABMECDSP
 ......Q:+ABMEQUIT
 ......S ABMORE=1
 ;
 S ABMINS("IEN")=0  ;Activer insurer IEN
 F  S ABMINS("IEN")=$O(^TMP($J,"S",ABMINS("IEN"))) Q:'ABMINS("IEN")  D  Q:+ABMEQUIT
 .S ABMINS=$E($P($G(^AUTNINS(ABMINS("IEN"),0)),U),1,30)  ;Insurer
 .S ABMVTYPE=0  ;Bill type
 .F  S ABMVTYPE=$O(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE)) Q:'ABMVTYPE  D  Q:+ABMEQUIT
 ..S ABMEXP=0  ;Mode of export
 ..F  S ABMEXP=$O(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP)) Q:'ABMEXP  D  Q:+ABMEQUIT
 ...S ABMTAMT=$P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U)  ;Total amount
 ...S ABMCNT=$P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U,2)  ;Total count
 ...S ABMEXPD=$P($G(^ABMDEXP(+ABMEXP,0)),U)  ;Export mode description
 ...I $G(ABMORE) D SUMPGHD^ABMECDSP  ;if more than one page do page hdr
 ...S ABMNEXT=ABMNEXT+1  ;increment sequence number
 ...W !,$J(ABMNEXT,3),?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 ...; ABMER(#)=Insurer^Visit Type^Export mode^total count^total charge
 ...S ABMER(ABMNEXT)=ABMINS("IEN")_U_ABMVTYPE_U_+ABMEXP_U_ABMCNT_U_ABMTAMT  ; data array by sequence number
 ...I $Y+5>IOSL D  Q:+ABMEQUIT
 ....D RETURN^ABMECDSP
 ....Q:+ABMEQUIT
 ....S ABMORE=1
 ;end new abm*2.6*6 5010
 Q
