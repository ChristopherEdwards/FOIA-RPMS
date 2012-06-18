ABMECDSP ; IHS/ASDST/DMJ - ELECTRONIC CLAIMS DISPLAY (SUMMARY) ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ; Original;DMJ;03/18/96 5:05 PM
 ; IHS/ASDS/SDR - 01/16/02 - V2.4 Patch 10 - NOIS XAA-0800-200136
 ;     Modified so as not to combine different export modes into one file.
 ; IHS/SD/SDR - v2.5 p9 - IM17793 - Set ABMSITE before trying to use (<UNDEFINED>DISPDET+24^ABMECDSP)
 ; IHS/SD/SDR - v2.5 p10 - IM20178 - Fix for <SUBSCR>LOOP+6^ABMECDSP (no export mode on claim)
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added clearinghouse code
 ; *********************************************************************
START ;   
 D INIT                 ; Initialize variables
 D GDATA1               ; Find approved bills needing export
 Q:'$D(^TMP($J))        ; Quit if no electronic bills to export
 D DISP                 ; Display summary data
 D ASKDET               ; Ask if user wants to see detail
 Q:$D(DTOUT)!($D(DUOUT))
 I $G(ABMDET) D
 .D ASKSEQ             ; Ask for seq # to show detail
 .Q:ABMSEQ=""!($D(DTOUT))!($D(DUOUT))  ;abm*2.6*6 5010  ;abm*2.6*8
 .;Q:ABMNEXT=""!($D(DTOUT))!($D(DUOUT))  ;abm*2.6*6 5010  ;abm*2.6*8
 .D DETHEAD            ; Write detail report headers
 .D DISPDET            ; Display detail report
 .Q
 I +$G(ABMEQUIT) D CLEANUP Q
 D RETURN               ; Press return to continue
 D CLEANUP              ; Clean up variables
 Q
EMCREAT(ABMER,ABMSEQ) ; EP
 ; Called from 'EMC Create a Batch'
 ;
 ; Output: AMBER array  = Array of batch data by sequence number
 ;         ABMSEQ       = Sequence number of batch
 D INIT
 D GDATA1
 Q:'$D(^TMP($J))
 D DISP
 D ASKSEQ
 Q
INIT ;
 K ^TMP($J)
 S $P(ABME("-"),"-",81)=""
 S $P(ABME("="),"=",81)=""
 S ABMSEQ=0
 S ABMEQUIT=0
 Q
GDATA1 ;  
 ; Loop through bills that have been approved but not yet exported.
 ; "AC","A" cross-reference of ^ABMDBILL
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),"AC","A",DA)) Q:'DA  D LOOP
 I '$D(^TMP($J)) W !!,"There are no electronic bills awaiting transmission." D RETURN Q:+ABMEQUIT
 Q
LOOP ;
 ; If the bill is to be exported electronically, collect data and 
 ; and build temporary summary "S" and detail "D" globals
 S ABMBILL0=$G(^ABMDBILL(DUZ(2),DA,0))
 Q:$P(ABMBILL0,U,4)="X"  ;Q if status is cancelled
 S ABMEXP=$P(ABMBILL0,U,6)  ;Export mode
 Q:ABMEXP=""
 Q:$P($G(^ABMDEXP(ABMEXP,1)),U,5)'="E"  ;Quit if not electronic
 S ABME("LDFN")=$P(ABMBILL0,U,3)  ;Location IEN
 S ABMLOC=$P($G(^AUTTLOC(+ABME("LDFN"),0)),U,2)_"@"_ABME("LDFN")
 S:ABMLOC="" ABMLOC="UNKNOWN"  ;Location
 S ABMVTYPE=$P(ABMBILL0,U,7)  ;Visit type
 S ABMINS("IEN")=$P(ABMBILL0,U,8)  ;Active insurer IEN
 S ABMBAMT=$P($G(^ABMDBILL(DUZ(2),DA,2)),U)  ;Bill amount
 S $P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U)=$P($G(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP)),U)+ABMBAMT
 S $P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U,2)=$P($G(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP)),U,2)+1
 S ^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,DA)=ABMBAMT
 Q
DISP ;
 ; Display summary data
 S ABMSUMPG=1
 K ABMORE
 W !
 D SUMHEAD                    ; Write summary page column headers
 ;start old code abm*2.6*6 5010
 ;S ABMSEQ=0                   ; Sequence number
 ;S ABMINS("IEN")=0            ; Activer insurer IEN
 ;F  S ABMINS("IEN")=$O(^TMP($J,"S",ABMINS("IEN"))) Q:'ABMINS("IEN")  D  Q:+ABMEQUIT
 ;.S ABMINS=$E($P($G(^AUTNINS(ABMINS("IEN"),0)),U),1,30)  ; Insurer
 ;.S ABMVTYPE=0               ; Bill type
 ;.F  S ABMVTYPE=$O(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE)) Q:'ABMVTYPE  D  Q:+ABMEQUIT
 ;..S ABMEXP=0               ; Mode of export
 ;..F  S ABMEXP=$O(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP)) Q:'ABMEXP  D  Q:+ABMEQUIT
 ;...S ABMTAMT=$P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U)   ; Total amount
 ;...S ABMCNT=$P(^TMP($J,"S",ABMINS("IEN"),ABMVTYPE,ABMEXP),U,2)  ; Total count
 ;...S ABMEXPD=$P($G(^ABMDEXP(+ABMEXP,0)),U)   ; Export mode description
 ;...I $G(ABMORE) D SUMPGHD    ; if more than one page do page hdr
 ;...S ABMSEQ=ABMSEQ+1         ; increment sequence number
 ;...W !,$J(ABMSEQ,3),?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 ;...; ABMER(#)=Insurer^Visit Type^Export mode^total count^total charge
 ;...S ABMER(ABMSEQ)=ABMINS("IEN")_U_ABMVTYPE_U_+ABMEXP_U_ABMCNT_U_ABMTAMT  ; data array by sequence number
 ;...I $Y+5>IOSL D  Q:+ABMEQUIT
 ;....D RETURN
 ;....Q:+ABMEQUIT
 ;....S ABMORE=1
 ;end old code start new code abm*2.6*6 5010
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
 .....I $G(ABMORE) D SUMPGHD  ;if more than one page do page hdr
 .....;W !
 .....;W ?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 .....; ABMER(#)=Insurer^Visit Type^Export mode^total count^total charge
 .....S ABMER(ABMSEQ)=ABM("CHIEN")_U_ABMVTYPE_U_+ABMEXP_U_ABMCNT_U_ABMTAMT  ; data array by sequence number
 .....I $Y+5>IOSL D  Q:+ABMEQUIT
 ......D RETURN
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
 ...I $G(ABMORE) D SUMPGHD  ;if more than one page do page hdr
 ...S ABMNEXT=ABMNEXT+1  ;increment sequence number
 ...W !,$J(ABMNEXT,3),?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 ...; ABMER(#)=Insurer^Visit Type^Export mode^total count^total charge
 ...S ABMER(ABMNEXT)=ABMINS("IEN")_U_ABMVTYPE_U_+ABMEXP_U_ABMCNT_U_ABMTAMT  ; data array by sequence number
 ...I $Y+5>IOSL D  Q:+ABMEQUIT
 ....D RETURN
 ....Q:+ABMEQUIT
 ....S ABMORE=1
 ;end new code abm*2.6*6 5010
 Q
ASKDET ;  
 ; Ask user if they wish to see detail
 W !
 S DIR(0)="Y"
 S DIR("A")="Show detail "
 S DIR("B")="NO"
 D ^DIR
 K DIR
 I Y=1 S ABMDET=1
 Q
ASKSEQ ;
 ; Ask user the sequence number for which they want to see detail
 W !
 ;start old code abm*2.6*6 5010
 ;S DIR(0)="NO^^K:(X<1!(X>ABMSEQ)) X"
 ;S DIR("A")="What sequence number (1 - "_ABMSEQ_")"
 ;S DIR("?")="Enter a number between 1 and "_ABMSEQ
 ;end old code start new code 5010
 S DIR(0)="NO^^K:(X<1!(X>ABMNEXT)) X"
 S DIR("A")="What sequence number (1 - "_ABMNEXT_")"
 S DIR("?")="Enter a number between 1 and "_ABMNEXT
 D ^DIR
 K DIR
 Q:$D(DTOUT)!($D(DUOUT))
 S ABMSEQ=Y
 Q:'ABMSEQ
 Q:'$D(^TMP($J,"S-CH",ABMSEQ))
 S ABM("CHIEN")=$P(ABMER(ABMSEQ),U)
 W !!,$J(ABMSEQ,3),?5,"+ "_$P($G(^ABMRECVR(ABM("CHIEN"),0)),U)
 W ?38,$J(ABMCHT(ABMSEQ,"VTYP"),3),?44,$P($G(^ABMDEXP(ABMCHT(ABMSEQ,"EXP"),0)),U)
 W ?60,$J(ABMCHT(ABMSEQ,"TOT"),4),?69,$J($FN(ABMCHT(ABMSEQ,"AMT"),",",2),10)
 W !
 S ABMINS("IEN")=0
 F  S ABMINS("IEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"))) Q:'ABMINS("IEN")  D  Q:+ABMEQUIT
 .S ABMINS=$E($P($G(^AUTNINS(ABMINS("IEN"),0)),U),1,30)  ;Insurer
 .S ABMVTYPE=0  ;Bill type
 .F  S ABMVTYPE=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE)) Q:'ABMVTYPE  D  Q:+ABMEQUIT
 ..S ABMEXP=0  ;Mode of export
 ..F  S ABMEXP=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE,ABMEXP)) Q:'ABMEXP  D  Q:+ABMEQUIT
 ...S ABMTAMT=$P(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE,ABMEXP),U)  ;Total amount
 ...S ABMCNT=$P(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"),ABMVTYPE,ABMEXP),U,2)  ;Total count
 ...S ABMEXPD=$P($G(^ABMDEXP(+ABMEXP,0)),U)  ;Export mode description
 ...I $G(ABMORE) D SUMPGHD  ;if more than one page do page hdr
 ...W !
 ...W ?6,ABMINS,?38,$J(ABMVTYPE,3),?44,ABMEXPD,?60,$J(ABMCNT,4),?69,$J($FN(ABMTAMT,",",2),10)
 W !
 S DIR(0)="Y"
 S DIR("A")="Proceed"
 S DIR("B")="YES"
 D ^DIR
 K DIR
 ;I Y'=1 K ABMSEQ Q  ;abm*2.6*8
 I Y'=1 S ABMSEQ="" Q  ;abm*2.6*8
 ;end new code 5010
 Q
DISPDET ;
 I $D(^TMP($J,"S-CH",ABMSEQ)) D DISPMULT Q  ;abm*2.6*6 5010
 S ABMEXP=$P(ABMER(ABMSEQ),U,3)  ;Export Mode
 S ABMINS("IEN")=$P(ABMER(ABMSEQ),U)  ;Active insurer IEN
 S ABMVTYPE=$P(ABMER(ABMSEQ),U,2)  ;Visit type
 S ABMLOC=""
 S ABMSITE=0
 F  S ABMLOC=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC)) Q:ABMLOC=""  D  Q:+$G(ABMEQUIT)
 .Q:$D(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE))<2
 .S ABMIEN=0
 .W !!,$P(ABMLOC,"@"),?40,"VISIT TYPE: ",$P(^ABMDVTYP(ABMVTYPE,0),U),!
 .F  S ABMIEN=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,ABMIEN)) Q:'+ABMIEN  D  Q:+$G(ABMEQUIT)
 ..S ABMBAMT=^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,ABMIEN)  ;Bill amount
 ..S ABMTOT=$G(ABMTOT)+ABMBAMT  ;Total amount for detail rpt
 ..S ABMSITE=$G(ABMSITE)+ABMBAMT  ;Tot amt per site on detail rpt
 ..F I=1,3,5 S ABME(I)=$P(^ABMDBILL(DUZ(2),ABMIEN,0),U,I)
 ..S ABMHRN=$P($G(^AUPNPAT(+ABME(5),41,+ABME(3),0)),U,2)  ;HRN
 ..S ABMPAT=$P($G(^DPT(+ABME(5),0)),U)  ;Patient name
 ..S ABMSRV=$P($G(^ABMDBILL(DUZ(2),ABMIEN,7)),U)
 ..S Y=ABMSRV
 ..D DD^%DT
 ..S ABMSRV=Y  ;Service date from
 ..W !?3,ABME(1),?13,ABMHRN,?21,ABMPAT,?51,ABMSRV,?68,$J($FN(ABMBAMT,",",2),10)
 ..I $Y+5>IOSL D RETURN Q:+ABMEQUIT  D DETHEAD
 .Q:+ABMEQUIT
 .W !?68,"----------"
 .W !?68,$J($FN(ABMSITE,",",2),10)
 .S ABMSITE=0
 Q:+ABMEQUIT
 W !!?20,"TOTAL",?68,$J($FN(ABMTOT,",",2),10)
 Q
 ;start new abm*2.6*6 5010
DISPMULT ;
 S ABMEXP=$P(ABMER(ABMSEQ),U,3)  ;Export Mode
 S ABMVTYPE=$P(ABMER(ABMSEQ),U,2)  ;Visit type
 S ABMLOC=""
 S ABMSITE=0
 S ABM("CHIEN")=0
 F  S ABM("CHIEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"))) Q:'ABM("CHIEN")  D
 .S ABMINS("IEN")=0
 .F  S ABMINS("IEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABM("CHIEN"),ABMINS("IEN"))) Q:'ABMINS("IEN")  D
 ..S ABMLOC=""
 ..F  S ABMLOC=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC)) Q:ABMLOC=""  D  Q:+$G(ABMEQUIT)
 ...Q:$D(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE))<2
 ...S ABMIEN=0
 ...W !!,$P(ABMLOC,"@"),?15,$P($G(^AUTNINS(ABMINS("IEN"),0)),U),?40,"VISIT TYPE: ",$P(^ABMDVTYP(ABMVTYPE,0),U),!
 ...F  S ABMIEN=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,ABMIEN)) Q:'+ABMIEN  D  Q:+$G(ABMEQUIT)
 ....S ABMBAMT=^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,ABMIEN)  ;Bill amount
 ....S ABMTOT=$G(ABMTOT)+ABMBAMT  ;Total amount for detail rpt
 ....S ABMSITE=$G(ABMSITE)+ABMBAMT  ;Tot amt per site on detail rpt
 ....F I=1,3,5 S ABME(I)=$P(^ABMDBILL(DUZ(2),ABMIEN,0),U,I)
 ....S ABMHRN=$P($G(^AUPNPAT(+ABME(5),41,+ABME(3),0)),U,2)  ;HRN
 ....S ABMPAT=$P($G(^DPT(+ABME(5),0)),U)  ;Patient name
 ....S ABMSRV=$P($G(^ABMDBILL(DUZ(2),ABMIEN,7)),U)
 ....S Y=ABMSRV
 ....D DD^%DT
 ....S ABMSRV=Y  ;Service date from
 ....W !?3,ABME(1),?13,ABMHRN,?21,ABMPAT,?51,ABMSRV,?68,$J($FN(ABMBAMT,",",2),10)
 ....I $Y+5>IOSL D RETURN Q:+ABMEQUIT  D DETHEAD
 ...Q:+ABMEQUIT
 ...W !?68,"----------"
 ...W !?68,$J($FN(ABMSITE,",",2),10)
 ...S ABMSITE=0
 Q:+ABMEQUIT
 W !!?20,"TOTAL",?68,$J($FN(ABMTOT,",",2),10)
 Q
 ;end new
SUMHEAD ; 
 ; Column headings for summary report
 ;start new abm*2.6*6 5010
 I $D(ABMCHLST)'="" D  Q
 .W !,"SEQ",?6,"INSURER/CLEARINGHOUSE",?33,"BILL TYPE",?44,"EXPORT MODE",?57,"# OF BILLS",?71,"BILL AMT",!,ABME("-"),!
 ;end new 5010
 W !,"SEQ",?6,"INSURER",?33,"BILL TYPE",?44,"EXPORT MODE",?57,"# OF BILLS",?71,"BILL AMT",!,ABME("-"),!
 Q
RETURN ;
 ; Press return to cont
 W !
 S ABMEQUIT=0
 S DIR(0)="E"
 D ^DIR
 K DIR
 I 'Y S ABMEQUIT=1
 Q
SUMPGHD ;  
 ; Page hdr for add'l pages of summary rpt
 K ABMORE
 S ABMSUMPG=ABMSUMPG+1
 W $$EN^ABMVDF("IOF"),!?21,"SUMMARY OF BILLS READY FOR SUBMISSION",?70,"Page: ",ABMSUMPG,!!
 D SUMHEAD
 Q
DETHEAD ;
 ;Rpt title & column hdgs for detail rpt
 S ABMDETPG=$G(ABMDETPG)+1
 W $$EN^ABMVDF("IOF"),!?27,"BILLS READY FOR SUBMISSION",?70,"Page: ",ABMDETPG
 W !?10,"FORMAT: ",$P(^ABMDEXP($P(ABMER(ABMSEQ),U,3),0),U,7),!
 W !,ABME("=")
 W !,"BILL #",?13,"HRN",?21,"PATIENT",?48,"SERVICE DATE FROM",?72,"AMOUNT"
 W !,ABME("-")
 Q
CLEANUP ;
 K ^TMP($J)
 K ABMBAMT,ABMBILL0,ABMVTYPE,ABMCNT,ABMDET,ABMDETPG,ABME,ABMEQUIT,ABMER
 K ABMEXP,ABMEXPD,ABMHRN,ABMIEN,ABMINS,ABMLOC,ABMORE,ABMPAT,ABMSEQ
 K ABMSITE,ABMSRV,ABMSUMPG,ABMTAMT,ABMTOT
 Q
