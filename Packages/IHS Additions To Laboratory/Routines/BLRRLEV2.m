BLRRLEV2 ;IHS/OIT/MKK - BLR Reference Lab Event, part 2 ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;IHS LABORATORY;**1033**;NOV 01, 1997
 ;
 ; Code had to be moved here from BLRRLEVT because BLRRLEVT became too large.
 ;
EEP ; EP - Ersatz EP
 D EEP^BLRGMENU
 ;
 Q
 ;
 ;cmi/anch/maw 2/24/2006 added look for LRPHMAN before asking for comments
 ;cmi/anch/maw 2/28/2006 added AAA tag for allowing edit of ask at accession questions
AAA ; EP
 I '$O(BLRRLC(0)),$P($G(XQY0),U)'="LRPHMAN" S BLRRLSUC=$$COM^BLRRLCOM(BLRRL("LRTS"),0)  ;cmi/anch/maw modified due to routine collect no LRTS 9/8/2004
 I ('$G(LRQUIET))&$O(BLRRLC(0)) D
 . S DIR(0)="Y",DIR("A")="Are the responses to the Ask At Accession questions correct "
 . S DIR("B")="Y"
 . D ^DIR
 . I '$G(Y) D  G AAA
 .. D DISAAQ^BLRRLEVT(.BLRCNT,BLRRL("LRTS"),.BLRRLC)
 ;cmi/anch/maw 2/28/2005 end of mods
 ;I '$O(BLRRLC(0)) S BLRRLSUC=$$COM^BLRRLCOM(+LRTS)  maw orig 9/8/2004
 Q:$G(BLRRL("LRTS"))=""  ;1/23/2006 don't proceed without a test
 S BLRRL("LOCI")=$G(LROLLOC)  ;cmi/maw 5/29/2007 added for internal location pointer to file 44
 S BLRRL("LOC")=$G(LRLLOC)
 S BLRRL("LOC")=$S($G(LROLLOC):$P($G(^SC(LROLLOC,0)),U),1:"")  ;4/3/2008 added for pointer to hosp location file
 ;S BLRRL("BI")=$P($G(^BLRRL(BLRRL("RL"),0)),U,10)  ;bi or unidirectional 2/25/2008 orig line
 S BLRRL("BI")=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL",0)),U,18)  ;NEW cmi/maw 2/25/2008 bi or unidirectional
 S BLRRL("RLE")=$P($G(^BLRRL(BLRRL("RL"),0)),U)  ;get external name
 ;I $G(BLRRL("BI")) Q:$P($G(^BLRRL(BLRRL("RL"),0)),U,6)=""  ;no orders 5/31/06
 ;I $G(BLRRL("BI")) Q:$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"),0)),U,6)=""  ;no orders 5/31/06
 S BLRRL("PAT")=$G(DFN)  ;patient
 S BLRRL("ACC")=$G(LRACC)  ;accession number
 S BLRRL("UID")=$G(LRUID)  ;unique id
 S BLRRL("CDT")=$G(LRCDT)  ;collection date
 S BLRRL("ACCA")=$P(BLRRL("ACC")," ")  ;get accession abbreviation
 I $G(BLRRL("ACCA"))="" W !,"No valid accession area prefix" Q
 S BLR("ACCAREA")=$O(^LRO(68,"B",BLRRL("ACCA"),0))  ;get ien of accession area
 I BLR("ACCAREA")=""  W !,"Accession Area is not a sendout area"  ;don't proceed if not an SO area
 ;todo see why this is failing
 I '$D(^BLRSITE("ACC",BLR("ACCAREA"),DUZ(2),BLRRL("RL"))) D  Q  ;2/25/2008 moved to BLR MASTER CONTROL FILE quit when not a sendout area
 . W !,"Accession area is not setup in the BLR MASTER CONTROL file"
 S BLRRL("ORDPRV")=$G(LRPRAC)  ;ordering provider
 ;the following must be setup in an array for GIS software
 ;do something here to check for mult tests under ac #
 ;or each acc # unique
 S (BLRTSTDA,BLRRL("TSTDA"))=+$G(LRTS)
 K BLRRL(BLRTSTDA)  ;kill off array from previous accession
 K BLRRL("ORDPUPIN"),BLRRL("ORDPNM")  ;maw 5/10/06
 S (BLRRL("UPINNPI"),BLRRL(BLRTSTDA,"UPINNPI"))="U"  ;upin or NPI
 I BLRRL("ORDPRV")]"" D  ;setup provider array
 . S BLRRL("ORDPUPIN")=$$VAL^XBDIQ1(200,BLRRL("ORDPRV"),9999999.08)  ;maw 5/10/06
 . S BLRRL("ORDPNPI")=$$VAL^XBDIQ1(200,BLRRL("ORDPRV"),41.99)  ;cmi/maw 2/26/2008 NPI
 . S BLRRL("ORDPNM")=$$VAL^XBDIQ1(200,BLRRL("ORDPRV"),.01)
 . S BLRRL("ORDPNM")=$P(BLRRL("ORDPNM"),",")_"^"_$P($P(BLRRL("ORDPNM"),",",2)," ")
 . S BLRRL(BLRTSTDA,"ORDP")=BLRRL("ORDPUPIN")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 . S $P(BLRRL(BLRTSTDA,"ORDP"),U,8)="U"  ;cmi/maw 3/12/09 labcorp
 . S BLRRL("ORDP")=BLRRL("ORDPUPIN")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 . S $P(BLRRL("ORDP"),U,8)="U"  ;cmi/maw 3/12/09 labcorp
 . ;cmi/maw 2/27/2008 added NPI based on parameter set in BLR MASTER CONTROL file
 . I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,19)="N" D
 .. S (BLRRL("UPINNPI"),BLRRL(BLRTSTDA,"UPINNPI"))="N"
 .. S BLRRL(BLRTSTDA,"ORDP")=BLRRL("ORDPNPI")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 .. S $P(BLRRL(BLRTSTDA,"ORDP"),U,8)="N"  ;cmi/maw 3/12/09 labcorp
 .. S BLRRL("ORDP")=BLRRL("ORDPNPI")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 .. S $P(BLRRL("ORDP"),U,8)="N"  ;cmi/maw 3/12/09 labcorp
 S BLRTSTI=+$G(LRTS)  ;get test ien
 I '$D(^LAB(60,BLRTSTI,8,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)) D  Q  ;quit if no accession area
 . W !,"Institution "_$P($G(^DIC(4,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U)_" is not setup in the Accession Area multiple of file 60"
 S BLRAREA=$P($G(^LAB(60,BLRTSTI,8,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U,2)  ;get acc area
 I BLRAREA="" W !,"Accession Area field is not setup in file 60 for "_$P($G(^DIC(4,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U) Q  ;quit if accession area field is null
 ;todo see why the below code does not work
 I BLRAREA'=BLR("ACCAREA") W !,"Accession Area in file 60 is not a sendout accession area" Q  ;quit if test acc area is not SO area
 S BLRRL(BLRTSTDA,"CDT")=$G(LRCDT)  ;collection date
 S BLRRL("TNAME")=$P($G(^LAB(60,BLRTSTI,0)),U)  ;get test name
 S BLRRL("ABBR")=$P($G(^LRO(68,BLRAREA,0)),U,11)  ;get area abbr
 S BLRRL("TST")=BLRTSTI  ;get test ien
 S BLRRL("TCODEE")=$$CODE^BLRRLEVT(BLRRL("RL"),BLRRL("TST"))  ;lookup test code
 S BLRRL("TCODE")=$P(BLRRL("TCODEE"),U)  ;test code
 S BLRRL("SHIPCOND")=$P(BLRRL("TCODEE"),U,2)  ;shipping condition
 I $G(BLRRL("TCODE"))=0 K BLRRL(BLRTSTDA) Q  ;quit if no test code
 S BLRRL(BLRTSTDA,"ACC")=$G(LRACC)  ;setup acc array for OBR
 S BLRRL(BLRTSTDA,"UID")=$G(LRUID)
 S BLRRL("TCNM")=BLRRL("TCODE")_U_BLRRL("TNAME")  ;test arry
 S BLRRL(BLRTSTDA,"TCNM")=BLRRL("TCODE")_U_BLRRL("TNAME")  ;test arry
 I $G(BLRRL("RLE"))="LABCORP" D
 . S BLRRL("TCNM")=BLRRL("TCNM")_"^L"
 . S BLRRL(BLRTSTDA,"TCNM")=BLRRL(BLRTSTDA,"TCNM")_"^L"
 S BLRRL("URGHL")=$S($G(LRURG):$P($G(^LAB(62.05,LRURG,0)),U,4),1:"")
 S BLRRL("URG")=$G(LRURG)
 S BLRRL("ODT")=$G(LRODT)
 S BLRRL(BLRTSTDA,"SAMP")=$G(LRSAMP)
 S BLRRL("SAMP")=$G(LRSAMP)
 S BLRRL(BLRTSTDA,"SRC")=$G(LRSPEC)
 S BLRRL("SRC")=$G(LRSPEC)
 I $G(LRSPEC) S (BLRRL(BLRTSTDA,"SRC"),BLRRL("SRC"))=$P($G(^LAB(61,LRSPEC,0)),U)
 S BLRRL("ORD")=$G(LRORD)
 S BLRRL(BLRTSTDA,"ORD")=$G(LRORD)
 S BLRCM=0 F  S BLRCM=$O(BLRRLC(BLRTSTDA,BLRCM)) Q:'BLRCM  D
 . S BLRRL(BLRTSTDA,"COMMENT",BLRCM)=$G(BLRRLC(BLRTSTDA,BLRCM))
 . S BLRRL("COMMENT",BLRCM)=$G(BLRRLC(BLRTSTDA,BLRCM))
 ;cmi/anch/maw 3/3/2006 lets try this for account number
 ;cmi/maw 2/25/2008 code added to get multiple account numbers
 ;S BLRRL("BILL TYPE")="Client"
 ;I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)'="C" D BILL^BLRRLHL
 I +$G(LRQUIET) D
 .I $G(BLRBT)="T" S BLRRL("BILL TYPE")="T" D BILL^BLRAG05C    ; IHS/MSC/SAT - LR*5.2*1031
 .S BLRRL("BILL TYPE")=$S($G(BLRBT)="C":"C",$G(BLRBT)="P":"P",1:"")
 I '+$G(LRQUIET) I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)'="C" D BILL^BLRRLHL   ; IHS/MSC/SAT - LR*5.2*1031
 ;
 ;cmi/anch/maw 3/3/2006 end of mods
 I '$G(BLRRLCLA) D CLIENT^BLRRLHL
 I '$G(BLRRL("CLIENT")) S BLRRL("CLIENT")=$G(BLRRLCLT)
 I '$G(BLRRL("CLIENT")) S BLRRL("CLIENT")=$O(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RLCA","B",""))
 I $G(BLRRL("CLIENT"))="" S BLRRL("CLIENT")=$P($G(^BLRRL(BLRRL("RL"),0)),U,13)
 I $G(BLRRL("BILL TYPE"))="" S BLRRL("BILL TYPE")=$G(BLRRLBTP)
 D TMPSET(.BLRRL)
 I +$G(BLRAGUI)!($P($G(XQY0),U)="LRPHMAN") D  ;cmi/anch/maw added for ward collection list 2/23/2006
 . D PRT^BLRSHPM
 S X="BLR REFLAB ACCESSION A TEST",DIC=101 D EN^XQOR  ;call accession protocol
 K BLRRL,BLRRLC(BLRTSTDA),LRTEST,PAT
 Q
 ;
TMPSET(BLRSHP) ;-- setup the array for the shipping manifest
 N BLRDA,BLRDATA,BLRIEN,BLROEN
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:BLRDA?.N
 . ;cmi/anch/maw 7/24/2007 right here you could store by order number if passed in at the top
 . S BLRDATA=$G(BLRSHP(BLRDA))
 . I '$D(^TMP("BLRRL",$J,BLRDA)) S ^TMP("BLRRL",$J,"COMMON",BLRDA)=BLRDATA
 ;
 K BLRDA,BLRDATA,BLRIEN
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:BLRDA'?.N
 . S BLRIEN=0 F  S BLRIEN=$O(BLRSHP(BLRDA,BLRIEN)) Q:BLRIEN=""  D
 .. Q:BLRIEN="COMMENT"
 .. S BLRDATA=$G(BLRSHP(BLRDA,BLRIEN))
 .. I '$D(^TMP("BLRRL",$J,BLRDA,BLRIEN)) S ^TMP("BLRRL",$J,BLRDA,BLRIEN)=BLRDATA
 ;
 K BLRDA,BLRDATA,BLRIEN,BLROEN
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:BLRDA'?.N
 . S BLRIEN=0 F  S BLRIEN=$O(BLRSHP(BLRDA,BLRIEN)) Q:BLRIEN=""  D
 .. Q:BLRIEN="COMMENT"
 .. S BLROEN=0 F  S BLROEN=$O(BLRSHP(BLRDA,BLRIEN,BLROEN)) Q:'BLROEN  D
 ... S BLRDATA=$G(BLRSHP(BLRDA,BLRIEN,BLROEN))
 ... I '$D(^TMP("BLRRL",$J,BLRDA,BLRIEN,BLROEN)) S ^TMP("BLRRL",$J,BLRDA,BLRIEN,BLROEN)=BLRDATA
 ;
 K BLRDA,BLRIEN,BLROEN,BLRDATA
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:'BLRDA
 . S BLRIEN=0 F  S BLRIEN=$O(BLRSHP(BLRDA,"COMMENT",BLRIEN)) Q:'BLRIEN  D
 .. S BLRDATA=$G(BLRSHP(BLRDA,"COMMENT",BLRIEN))
 .. I '$D(^TMP("BLRRL",$J,BLRDA,"COMMENT",BLRIEN)) S ^TMP("BLRRL",$J,BLRDA,"COMMENT",BLRIEN)=BLRDATA
 ;
 Q
