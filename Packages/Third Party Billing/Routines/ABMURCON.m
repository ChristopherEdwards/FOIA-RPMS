ABMURCON ; IHS/SD/SDR - 3PB/UFMS Reconcile Sessions Option   
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ; IHS/SD/SDR - v2.5 p13 - IM25924 - <UNDEF>EP+32^ABMUCAPI fix
 ; IHS/SD/SDR - v2.5 p13 - NO IM - Modified to add EP for recon. page display
 ; IHS/SD/SDR - v2.5 p13 - IM26756 - Fix for Cancel Claim total doubling
 ; IHS/SD/SDR - abm*2.6*1 - HEAT5977 - <SUBSCR>CASHTOTP+5^ABMUUTL
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6686 - only allow one person to export at a time
EP ;EP
 ;start new code abm*2.6*1 HEAT6866
 L +ABMURCON:5
 I '$T W !!!,"Someone is already exporting..." H 2 Q
 ;end new code HEAT6866
 D HEADER^ABMURCN1("CLOSED")
 S ABMFLG="CLOSED"
 D FINDACLS^ABMUCUTL
 I '$D(ABMO) W !?5,"There are no CLOSED sessions."
 D VIEWLIST^ABMURCN1
 W !
 I $D(ABMO) D SELSESS
 I $D(ABMY("SESS",ABMSCNT)),(ABMSCNT>1) D  ;they said all; put all in sel. array
 .F ABMI=1:1:(ABMSCNT-1) S ABMY("SESS",ABMI)=""
 .K ABMY("SESS",ABMSCNT)
 S ABMI=0
 F  S ABMI=$O(ABMOS(ABMI)) Q:+ABMI=0  D
 .I '$D(ABMY("SESS",ABMI)) D
 ..S ABMSDT=$P(ABMOS(ABMI),U)
 ..S ABMUSER=$P(ABMOS(ABMI),U,2)
 ..K ABMO(ABMSDT,ABMUSER,ABMSDT)
 ..K ABMOS(ABMI)
 M ABMC=ABMO
 K ABMY,ABMO,DUOUT,DIROUT
 W !!!
SEL D HEADER^ABMURCN1("OPEN")
 S ABMTRIBL=$P($G(^ABMDPARM(DUZ(2),1,4)),U,14)
 K ABMFLG
 D FINDAOPN^ABMUCUTL
 I '$D(ABMO) W !?5,"There are no OPEN sessions.",! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:$D(DUOUT)!($D(DIROUT))
 D VIEWLIST^ABMURCN1
 K DIR,X,Y
 W !!
 I $D(ABMO) D SELSESS
 Q:'$D(ABMY("SESS"))&('$D(ABMC))  ;no sess selected & no closed sess
 D VIEWSEL^ABMURCN1  ;view selected sess
 S DIR(0)="Y",DIR("A")="Do you wish to proceed (""^"" to exit)" S DIR("B")="YES" D ^DIR K DIR
 Q:$D(DUOUT)!($D(DIROUT))
 I +Y=0 G SEL  ;go back to sel scrn
 D CLOSE^ABMURCN1  ;cls selected open sess
 D PTINCK  ;chk if any pseudo TINs exist for btch
 I ABMTRIBL=1 D
 .I $G(ABMPTINF)=1 W !!,"IMPORTANT!!  IMPORTANT!!  Pseudo TINs will be sent in this export!"
 .I $G(ABMMTINF)=1 D
 ..W !,"IMPORTANT!!  IMPORTANT!!  TINs are missing in this export!",!!
 ..W "DUE TO MISSING TAX IDs, EXPORT FILE WILL NOT BE CREATED. Insurers missing TINs"
 ..W !,"will be listed.  Please record the name(s) of the Insurer for correction."
 W !! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 I ABMTRIBL=1,($G(ABMMTINF)=1) D  Q  ;wrt missing TIN ins & stop
 .;wrt insurers w/out TINs
 .W !!,"Insurers missing Tax IDs in this export selection:"
 .S ABMINS=0
 .F  S ABMINS=$O(ABMMT(ABMINS)) Q:+ABMINS=0  D
 ..W !?5,$P($G(^AUTNINS(ABMINS,0)),U)," in session ID ",$G(ABMMT(ABMINS))
 ..W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;start new code
 D ABBREVCK^ABMUUTL  ;chk if any abbrevs missing
 I ABMTRIBL=1 D
 .I $G(ABMVDFNF)=1 W !!,"IMPORTANT!!  IMPORTANT!!  Visit Locations missing abbreviations!"
 .I $G(ABMVDFNF)=1 D
 ..W !,"DUE TO MISSING ABBREVIATIONS, EXPORT FILE WILL NOT BE CREATED. Visit Locations"
 ..W !,"missing abbreviations will be listed."
 ..W !!,"Please record the Location name(s) and number(s) for correction in the Location file."
 W !! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 I ABMTRIBL=1,($G(ABMVDFNF)=1) D  Q  ;wrt missing abbrevs & stop
 .;wrt locs w/out abbrevs
 .W !!,"Locations missing abbrevs in this export selection:"
 .S ABMVDFN=0
 .F  S ABMVDFN=$O(ABMMABB(ABMVDFN)) Q:+ABMVDFN=0  D
 ..W !?5,"("_ABMVDFN_") ",$P($G(^DIC(4,ABMVDFN,0)),U)," in session ID ",$G(ABMMABB(ABMVDFN))
 ..W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;end new code
 I ABMTRIBL=1,($G(ABMPTINF)=1) D  ;write pseudo TIN insurers
 .;wrt insurers w/pseudo TINs
 .W !!,"Insurers with pseudo Tax IDs in this export selection:"
 .S ABMINS=0
 .F  S ABMINS=$O(ABMPT(ABMINS)) Q:+ABMINS=0  D
 ..W !?5,$P($G(^AUTNINS(ABMINS,0)),U)," with pseudo tax id """_$G(ABMPT(ABMINS))_""""
 ..W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 D XSUMDISP  ;export summ disp
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1 D SENDBTCH  ;ask export question; do if yes
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)'=1 D NOSEND  ;reconcile; don't export
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
SELSESS ;SEL SESSIONS
 D SELSESS^ABMURCN1
 Q
PTINCK ;EP - pseudo TINs chk
 D PTINCK^ABMUUTL
 Q
XSUMDISP ;EP - Summary export display
 S ABMTRIBL=$P($G(^ABMDPARM(DUZ(2),1,4)),U,14)
 W $$EN^ABMVDF("IOF")
 I ABMTRIBL=1 S ABM("HD",0)="Export Summary Print"
 E  S ABM("HD",0)="Reconciliation Summary Report"
 S ABM("PG")=1
 D WHD^ABMDRHD G XIT:'$D(IO)!$G(POP)!$D(DTOUT)!$D(DUOUT)
 K ABMRQFLG
 W !,"Please ensure the following information is correct:",!
XSUM2 ;EP; called from ABMUVBCR
 W ?26,"Approved",?38,"|"
 I ABMTRIBL=1 D
 .W ?40,"Excluded"
 .W ?54,"Cancelled",?66,"Cxl'd",?75,"Ben"
 I ABMTRIBL'=1 D
 .W ?40,"Cancelled",?56,"Cxl'd"
 .;
 W !?1,$$EN^ABMVDF("ULN"),"Session/User",$$EN^ABMVDF("ULF")
 W ?27,$$EN^ABMVDF("ULN"),"Bills",$$EN^ABMVDF("ULF")
 W ?38,"|"
 I ABMTRIBL=1 D
 .W ?41,$$EN^ABMVDF("ULN"),"Bills",$$EN^ABMVDF("ULF")
 .W ?56,$$EN^ABMVDF("ULN"),"Bills",$$EN^ABMVDF("ULF")
 .W ?66,$$EN^ABMVDF("ULN"),"Claims",$$EN^ABMVDF("ULF")
 .W ?74,$$EN^ABMVDF("ULN"),"Bills",$$EN^ABMVDF("ULF")
 I ABMTRIBL'=1 D
 .W ?40,$$EN^ABMVDF("ULN"),"Bills",$$EN^ABMVDF("ULF")
 .W ?56,$$EN^ABMVDF("ULN"),"Claims",$$EN^ABMVDF("ULF")
 W !
 S ABMSESS=0
 K ABMSBTOT,ABMSATOT
 K ABMTCCLM
 K ABMTCBIL,ABMTCBAM
 K ABMEBILL,ABMTBEN
 F  S ABMSESS=$O(ABMC(ABMSESS)) Q:+ABMSESS=0  D
 .S ABMDUZ=""
 .F  S ABMDUZ=$O(ABMC(ABMSESS,ABMDUZ)) Q:ABMDUZ=""  D
 ..S ABMFD=0
 ..F  S ABMFD=$O(ABMC(ABMSESS,ABMDUZ,ABMFD)) Q:+ABMFD=0  D
 ...W ?38,"|",!
 ...I ABMDUZ D
 ....W $E(ABMFD_"/"_$P($P($G(^VA(200,ABMDUZ,0)),U),",")_","_$E($P($P($G(^VA(200,ABMDUZ,0)),U),",",2),1),1,23)
 ....D CASHTOT^ABMUCASH(ABMDUZ)
 ....W ?25,+$G(ABMABILL),?27,$J($FN(+$G(ABMABAMT),",",2),10)
 ....W ?38,"|"
 ....I ABMTRIBL=1 D
 .....W ?40,+$G(ABMEBILL),?42,$J($FN(+$G(ABMEBAMT),",",2),9)
 .....W ?53,+$G(ABMCBILL),?55,$J($FN(+$G(ABMCBAMT),",",2),9)
 .....W ?68,+$G(ABMCCLMS)
 .....W ?76,+$P($G(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMFD,0)),U,11),!
 ....I ABMTRIBL'=1 D
 .....W ?40,+$G(ABMCBILL),?43,$J($FN(+$G(ABMCBAMT),",",2),9)
 .....W ?55,+$G(ABMCCLMS),!
 ....S ABMTBEN=+$G(ABMTBEN)+$P($G(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMFD,0)),U,11)
 ...I 'ABMDUZ D  ;POS CLMS
 ....W ABMFD_"/POS CLAIMS"
 ....D CASHTOTP^ABMUCASH
 ....W ?25,+$G(ABMABILL),?27,$J($FN(+$G(ABMABAMT),",",2),10)
 ....W ?38,"|"
 ....W ?40,+$G(ABMEBILL),?42,$J($FN(+$G(ABMEBAMT),",",2),9),!
 W ABMLINE,!,"TOTALS:"
 W ?25,+$G(ABMSBTOT),?27,$J($FN(+$G(ABMSATOT),",",2),10)
 W ?38,"|"
 I ABMTRIBL=1 D
 .W ?40,+$G(ABMTEBIL),?42,$J($FN(+$G(ABMTEBAM),",",2),9)
 .W ?53,+$G(ABMTCBIL),?55,$J($FN(+$G(ABMTCBAM),",",2),9)
 .W ?68,+$G(ABMTCCLM)
 .W ?76,+$G(ABMTBEN)
 I ABMTRIBL'=1 D
 .W ?40,+$G(ABMTCBIL),?43,$J($FN(+$G(ABMTCBAM),",",2),9)
 .W ?55,+$G(ABMTCCLM)
 W !!
 W !
 I $G(ABMFILE)'="" W !!,"EXPORTED IN FILE ",ABMFILE D
 .W:(+$G(XBFLG)=0) !!,"File was sent successfully"
 .W:'(+$G(XBFLG)=0) !!,"File was **NOT** sent successfully"
 .W:$G(XBFLG(1))'="" ?40,"- ",$G(XBFLG(1))
 Q
SENDBTCH ;EP - ask export ques; export=yes
 S ABMDT=0
 S ABMAFLG=0
 F  S ABMDT=$O(ABMC(ABMDT)) Q:+ABMDT=0  D  Q:ABMAFLG=1
 .S ABMUSER=0
 .F  S ABMUSER=$O(ABMC(ABMDT,ABMUSER)) Q:+ABMUSER=0  D  Q:ABMAFLG=1
 ..S ABMDT2=0
 ..F  S ABMDT2=$O(ABMC(ABMDT,ABMUSER,ABMDT2)) Q:+ABMDT2=0  D
 ...I +$P($G(ABMC(ABMDT,ABMUSER,ABMDT2)),U,3)=1 S ABMAFLG=1
 ...I +$P($G(ABMC(ABMDT,ABMUSER,ABMDT2)),U,3)=0 D  ;no act-mark as reconciled
 ....K DIC,DIE,DA,DR,X,Y
 ....S DA(2)=DUZ(2)
 ....S DA(1)=$S(ABMUSER:ABMUSER,1:1)
 ....S:ABMUSER DIE="^ABMUCASH("_DA(2)_",10,"_DA(1)_",20,"
 ....S:'ABMUSER DIE="^ABMUCASH("_DA(2)_",20,"_DA(1)_",20,"
 ....S DA=ABMDT
 ....S DR=".04///T;.08///NOW"  ;transmitted status w/dt
 ....D ^DIE
 I +$G(ABMSBTOT)=0,(+$G(ABMAFLG)=0) D  Q  ;there aren't any bills, don't create exp file
 .W !!,"There aren't any bills to export in this selection."
 .W !,"NO export file will be created"
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Do you want to SEND export now? <yes/no>"
 D ^DIR K DIR
 S ABMXANS=+Y
 I ABMXANS=0 D  Q
 .W !,"EXITING Reconcile sessions option...NOTE: NOTHING IS BEING EXPORTED AT THIS TIME"
 .D PRINTSUM
 I ABMXANS=1 D
 .D EXPORT
 .D PRINTSUM
 Q
PRINTSUM ;EP - print sum?
 D PRINTSUM^ABMURCN1
 Q
EXPORT ;EP-loop thru sess; export data
 ;Inv format:
 ; 1.Always D
 ; 2.<parASUFAC><satASUFAC>3P BILL IEN
 ; 3.Dt/Tm Approved (MM/DD/YYYY) from 3P Bill
 ; 4.TAX ID (.11) from Insurer file
 ; 5.<parASUFAC><satASUFAC>3P BILL#
 ; 6.Bill Amount (.21) from 3P Bill
 ; 7.CAN-calculated in IE
 ; 8.132 for HHS T-code
 ; 9.61704 for object class
 ;Trailer record format:
 ; 1.Always T for trailer
 ; 2.Number records
 ; 3.Total file amt
 D FILENAME()
EXTRACT ;
 K ^ABMUFMS($J)
 S ABMTOT=0
 S ABMRECT="D"
 S ABMTCODE=132
 S ABMOCL=61704
 S ABMCNT=0
 S ABMMIEN=0
 S ABMSESS=0
 D CREATBTH  ;create exp btch
 ;sess bills
 F  S ABMSESS=$O(ABMC(ABMSESS)) Q:+ABMSESS=0  D
 .S ABMDUZ=""
 .F  S ABMDUZ=$O(ABMC(ABMSESS,ABMDUZ)) Q:ABMDUZ=""  D
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(ABMC(ABMSESS,ABMDUZ,ABMSDT)) Q:+ABMSDT=0  D
 ...I ABMDUZ D
 ....S ABMSESID=ABMSDT
 ....S ABMBA=0
 ....F  S ABMBA=$O(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,11,ABMBA)) Q:+ABMBA=0  D
 .....S ABMBAOUT=$P($G(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,11,ABMBA,0)),U)
 .....I ABMBAOUT="I"!(ABMBAOUT="T") Q  ;don't export ben, Third Party Liab.
 .....S ABMBIEN=0
 .....F  S ABMBIEN=$O(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,11,ABMBA,2,ABMBIEN)) Q:+ABMBIEN=0  D
 ......S ABMPREC=$G(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,11,ABMBA,2,ABMBIEN,0))
 ......D RECORD
 ...I 'ABMDUZ D  ;POS CLMS
 ....S ABMUSER=0
 ....F  S ABMUSER=$O(^ABMUCASH(ABMLOC,20,ABMUSER)) Q:+ABMUSER=0  D
 .....S ABMBA=0
 .....F  S ABMBA=$O(^ABMUCASH(ABMLOC,20,ABMUSER,20,ABMSDT,11,ABMBA)) Q:+ABMBA=0  D
 ......S ABMBAOUT=$P($G(^ABMUCASH(ABMLOC,20,ABMUSER,20,ABMSDT,11,ABMBA,0)),U)
 ......S ABMBIEN=0
 ......F  S ABMBIEN=$O(^ABMUCASH(ABMLOC,20,ABMUSER,20,ABMSDT,11,ABMBA,2,ABMBIEN)) Q:+ABMBIEN=0  D
 .......S ABMPREC=$G(^ABMUCASH(ABMLOC,20,ABMUSER,20,ABMSDT,11,ABMBA,2,ABMBIEN,0))
 .......D RECORD
 ...;reque'd bills
 ...S ABMRQB=0
 ...F  S ABMRQB=$O(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,12,ABMRQB)) Q:+ABMRQB=0  D
 ....S ABMPREC=$G(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,12,ABMRQB,0))
 ....S ABMBAOUT=$P($G(^AUTNINS($P($G(^ABMDBILL(ABMLOC,$P(ABMPREC,U,3),0)),U,8),2)),U)
 ....D RECORD
 ...;reque'd batches
 ...S ABMRQB=0
 ...F  S ABMRQB=$O(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,13,ABMRQB)) Q:+ABMRQB=0  D
 ....S ABMPBTCH=$P($G(^ABMUCASH(ABMLOC,10,ABMDUZ,20,ABMSDT,13,ABMRQB,0)),U)  ;batch IEN
 ....F ABMLOOP=1,2 D
 .....S ABMBUSER=0
 .....F  S ABMBUSER=$O(^ABMUTXMT(ABMPBTCH,ABMLOOP,ABMBUSER)) Q:+ABMBUSER=0  D
 ......S ABMBSDT=0
 ......F  S ABMBSDT=$O(^ABMUTXMT(ABMPBTCH,ABMLOOP,ABMBUSER,2,ABMBSDT)) Q:+ABMBSDT=0  D
 .......S ABMBBA=0
 .......F  S ABMBBA=$O(^ABMUTXMT(ABMPBTCH,ABMLOOP,ABMBUSER,2,ABMBSDT,11,ABMBBA)) Q:+ABMBBA=0  D
 ........S ABMBAOUT=$P($G(^ABMUTXMT(ABMPBTCH,ABMLOOP,ABMBUSER,2,ABMBSDT,11,ABMBBA,0)),U)
 ........S ABMBBIEN=0
 ........F  S ABMBBIEN=$O(^ABMUTXMT(ABMPBTCH,ABMLOOP,ABMBUSER,2,ABMBSDT,11,ABMBBA,2,ABMBBIEN)) Q:+ABMBBIEN=0  D
 .........S ABMPREC=$G(^ABMUTXMT(ABMPBTCH,ABMLOOP,ABMBUSER,2,ABMBSDT,11,ABMBBA,2,ABMBBIEN,0))
 .........D RECORD
 ....D REEXPB^ABMURCN1  ;3 mult entry of 3P UFMS Export file
 ...;mark sess as Xmitted
 ...K DIC,DIE,DA,DR,X,Y
 ...S DA(2)=ABMLOC
 ...S DA(1)=$S(ABMDUZ:ABMDUZ,1:1)
 ...S:ABMDUZ DIE="^ABMUCASH("_DA(2)_",10,"_DA(1)_",20,"
 ...S:'ABMDUZ DIE="^ABMUCASH("_DA(2)_",20,"_DA(1)_",20,"
 ...S DA=ABMSDT
 ...S DR=".04///T;.08///NOW"  ;Xmitted status w/dt
 ...D ^DIE
 Q:'$D(^ABMUFMS($J))
 D TRAILER
 D SENDFILE("ABMUFMS(",ABMFILE)
 Q
TRAILER ;EP
 S ABMREC="T"_$$FMT^ABMERUTL(ABMCNT,"10R")_$TR($$FMT^ABMERUTL($J(ABMTOT,".",2),"20NR"),".")
 S ^ABMUFMS($J,(ABMCNT+1))=ABMREC
 Q
FILENAME() ;
 S ABMLOC=$$FINDLOC^ABMUCUTL
 S ABMFILE=$$GETFILNM($$ASUFAC^ABMUCUTL(ABMLOC,DT))
 W !,"File will be created using the following name: ",!?5,ABMFILE
 I ABMFILE'="" Q 1
 Q 0
GETFILNM(ASUFACS) ;EP - CREATE FILE NAME
 N FNROOT,FNEXT,FN,YR,DATE,TIME
 K DATETIME
 S FNROOT="IHS_TPB_RPMS_INV_"
 S FNEXT="_"_$P($$VERSION^XPDUTL("ABM"),".")_"."  ;version piece 1 (before ".")
 S FNEXT=FNEXT_$$FMT^ABMERUTL($P($$VERSION^XPDUTL("ABM"),".",2),"2NR")_"."  ;version piece 2 fmt'ed (after ".")
 S FNEXT=FNEXT_$S(+$$LAST^ABMENVCK("IHS 3P BILLING SYSTEM",$$VERSION^XPDUTL("ABM"))>0:+$$LAST^ABMENVCK("IHS 3P BILLING SYSTEM",$$VERSION^XPDUTL("ABM")),1:"00")_"k.DAT"  ;patch#, default to 00
 S FN=FNROOT
 D NOW^%DTC
 S YR=1700+$E(%,1,3)
 S DATE=YR_$E(%,4,7)
 S Y=% X ^DD("DD")
 S TIME=$TR($P(Y,"@",2),":")
 S DATETIME=DATE_"_"_TIME
 S FN=FNROOT_ASUFACS_"_"_DATETIME
 S FN=FN_FNEXT
 Q FN
SENDFILE(XBGL,XBFN) ;
 S:$G(XBFN)="" XBFN="UFMS.TST"
 S:$G(XBGL)="" XBGL="ABMTUFMS("
 S XBQSHO=""
 S XBF=$J    ;Beg 1st lev numeric subscr
 S XBE=$J    ;End 1st lev numeric subscr
 S XBFLT=1  ;indicates flat file
 S XBMED="F"     ;Flag indicates file as media
 S XBCON=1    ;Q if non-cononic
 S XBS1="ABM UFMS F"   ;ZISH SEND PARA entry
 I $D(ZTQUEUED) S XBS1="ABM UFMS B"
 S XBQ="N"
 S XBUF=$P($G(^ABMDPARM(ABMLOC,1,4)),U,13)
 I XBUF="" D  Q
 .W !!,"Before UFMS files can be created a non-public directory must be created"
 .W !,"on the Host File System. This directory must be entered in to TPB Site Parameter"
 .W !,"field UFMS DIRECTORY using the 'SITM    Site Parameter Maintenance' option"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 S XBFLG=0
 I XBUF="" D  Q
 .S XBFLG=-1
 .S XBFLG(1)="Missing UFMS storage directory. Please check TPB UFMS Parameters"
 D ^XBGSAVE
 Q
RECORD ;EP - get pieces; put together rec
 D RECORD^ABMURCN2
 Q
CREATBTH ;EP - create UFMS export entry
 D CREATBTH^ABMURCN1
 Q
BATCH ;EP - put bill in batch file
 D BATCH^ABMURCN1
 Q
BILL ;EP - put entry in bill mult for transmit dt & save UFMS inv#
 ;transmit dt
 D BILL^ABMURCN1
 Q
NOSEND ;EP - don't send but mark reconciled
 D NOSEND^ABMURCN1
 Q
RCONSESS ;mark session as transmitted
 D RCONSESS^ABMURCN1
 Q
XIT ;EP
 K ABMBAL,ABMC,ABMO,ABMOS
 K ABMSESID,ABMSESS,ABMDUZ,ABMDUZ2,ABMPASUF,ABMSASUF,ABMPREC
 K ABMBAOUT,ABMSDT,ABMLINE
 Q
