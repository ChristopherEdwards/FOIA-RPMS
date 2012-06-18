BLRRLEVT ;cmi/anch/maw - BLR Reference Lab Event ; 13 Apr 2009  9:56 AM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997;Build 9
 ;
 ;
 ;the content of this routine was moved from BLREVTQ and is now called from BLREVTQ
 ;cmi/maw 5/26/2010 added LA7 subroutine for LEDI III
 ;
 Q
 ;
LEDI ;-- LEDI III insurance stuff
 N BLRA,BLRC,BLRB
 K BLRRLC
 S BLRLEDI=1
 ;S (BLRDXS,BLRINS)=0
 S BLRTS=$S(+$G(LRTS):+LRTS,$G(LRTSTS):+LRTSTS,1:$G(LRTSORU))
 I BLRPHASE="O" D  ;cmi/maw 5/30/2007 added for institution entry of file 44 so that it gets correct accession area from file 60 otherwise it gets duz(2)
 . Q:'$G(LROLLOC)
 . Q:'$P($G(^SC(LROLLOC,0)),U,4)
 . S BLRALTDZ=$P($G(^SC(LROLLOC,0)),U,4)
 . Q:'+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))
 . S LRDUZ(2)=BLRALTDZ
 . Q:'$$SENDOUT(BLRALTDZ,BLRTS)
 . S BLRO=$$ORD^BLRRLEDI(LRORD,DFN)
 . Q:'$G(BLRO)
 . ;TODO lets get the ask at order questions working, need to add filing of answers and retrieval under accession
 . I $G(BLRTS) D LEDIAAA
 . Q:$G(BLRDXS)
 . I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)="T" D DX^BLRRLEDI(LRORD)
 . K BLRO,BLRRLC
 Q:BLRPHASE'="A"  ;quit if not an accession
 Q:'$$SENDOUT(BLRALTDZ,BLRTS)
 I '$G(BLRO) S BLRO=$$ORD^BLRRLEDI(LRORD,DFN)
 S BLRA=$$ACC^BLRRLEDI(LRUID,LRORD,DFN,LRCDT)
 Q:'BLRA
 S BLRC=$$CLIENT^BLRRLEDI(LRORD,LRUID)
 I $P($G(^BLRRLO(BLRO,4,0)),U,4) D SETAO(BLRO),LEDIAAA
 S BLRB=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)
 I '$G(BLRINS) D BILL^BLRRLEDI(BLRB,LRORD,LRUID,LRCDT)
 K BLRO,BLRRLC
 ;K BLRDXS,BLRINS
 Q
SETAO(RO) ;-- setup the ask at order array from whats in the BLRRLO global
 N ADA,DATA,TST,QUES,ANS,RSC
 K BLRRLC
 S ADA=0 F  S ADA=$O(^BLRRLO(RO,4,ADA)) Q:'ADA  D
 . S DATA=$G(^BLRRLO(RO,4,ADA,0))
 . S TST=$P(DATA,U)
 . S QUES=$P(DATA,U,3)
 . S ANS=$P(DATA,U,4)
 . S RSC=$P(DATA,U,5)
 . S BLRRLC(TST,ADA)=RSC_U_QUES_U_ANS
 Q
 ;
LEDIAAA ;-- ledi ask at order question
 I '$O(BLRRLC(0)),$P($G(XQY0),U)'="LRPHMAN" S BLRRLSUC=$$COM^BLRRLCOM(BLRTS,1)  ;cmi/anch/maw modified due to routine collect no LRTS 9/8/2004
 I $O(BLRRLC(0)) D
 . S DIR(0)="Y",DIR("A")="Are the responses to the Ask At Accession questions correct "
 . S DIR("B")="Y"
 . D ^DIR
 . I '$G(Y) D  G LEDIAAA
 .. D DISAAQ(.BLRCNT,BLRTS,.BLRRLC)
 D FLAO(.BLRRLC,BLRTS,BLRO,$G(LRUID))
 Q
 ;
FLAO(RLC,T,RL,ACC) ;-- file the ask at order questions
 D CLNAO(RL)
 N FIENS,FERR,FDA
 N RDA,RIEN,QUES,ANS,RSC
 S RDA=0 F  S RDA=$O(RLC(RDA)) Q:'RDA  D
 . S RIEN=0 F  S RIEN=$O(RLC(RDA,RIEN)) Q:'RIEN  D
 .. S QUES=$P($G(RLC(RDA,RIEN)),U,2)
 .. S ANS=$P($G(RLC(RDA,RIEN)),U,3)
 .. S RSC=$P($G(RLC(RDA,RIEN)),U)
 .. S FIENS="+2,"_RL_","
 .. S FDA(9009026.34,FIENS,.01)=T
 .. S FDA(9009026.34,FIENS,.02)=ACC
 .. S FDA(9009026.34,FIENS,.03)=QUES
 .. S FDA(9009026.34,FIENS,.04)=ANS
 .. S FDA(9009026.34,FIENS,.05)=RSC
 .. D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 .. K FIENS,FERR,FDA
 Q
 ;
CLNAO(L) ;-- clean ot the ask at order questions
 S DA=0 F  S DA=$O(^BLRRLO(L,4,DA)) Q:'DA  D
 . S DA(1)=L
 . S DIK="^BLRRLO("_DA(1)_",4,"
 . D ^DIK
 K DA,DIK
 Q
 ;
SENDOUT(AC,LRT) ;-- check if a valid sendout test
 N RL,ACCA,AREA,MATCH
 S MATCH=0
 S RL=+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))
 I '$G(RL) Q 0
 N ADA
 S ADA=0 F  S ADA=$O(^LAB(60,LRT,8,ADA)) Q:'ADA!($G(MATCH))  D
 . S ACCA=$P($G(^LAB(60,LRT,8,ADA,0)),U,2)
 . Q:'ACCA
 . I $O(^BLRSITE("ACC",ACCA,AC,0)) S MATCH=1 Q
 I '$G(MATCH) Q 0
 Q 1
 ;
ACC ;EP - cmi/flag/maw added the following for ref lab accessions
 ;cmi/anch/maw REF LAB
 ;Q:'$$SENDOUT(LRACC,LRTS)
 I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,22) D LEDI Q
 K BLRRL,BLRRLC  ;kill off existing BLRRL array
 N BLRLDIO
 I BLRPHASE="O" D  ;cmi/maw 5/30/2007 added for institution entry of file 44 so that it gets correct accession area from file 60 otherwise it gets duz(2)
 . Q:'$G(LROLLOC)
 . Q:'$P($G(^SC(LROLLOC,0)),U,4)
 . S BLRALTDZ=$P($G(^SC(LROLLOC,0)),U,4)
 . Q:'+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))
 . S LRDUZ(2)=BLRALTDZ
 Q:BLRPHASE'="A"  ;quit if not an accession
 S BLRRL("ALTDUZ2")=$G(BLRALTDZ)  ;cmi/maw 5/29/2007 setup alternate duz2 if they select the prompt in blrsite to look at ordering location
 I $G(BLRALTDZ),$P($G(^BLRSITE(BLRALTDZ,"RL")),U,10)="D" K BLRALTDZ,BLRRL("ALTDUZ2")  ;don't need variables if they use a true multidivisional site
 I $G(BLRALTDZ),$P($G(^BLRSITE(BLRALTDZ,"RL")),U,10)="" K BLRALTDZ,BLRRL("ALTDUZ2")  ;don't need variables if they use a true multidivisional site
 S BLRRL("RL")=+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))  ;ref lab site maw modified 5/29/2007
 Q:'BLRRL("RL")
 I $G(LRAA) S BLRRL("ACCCHECK")=LRAA  ;cmi/maw 2/9/2009
 I $G(LRACC)]"" S BLRRL("ACCCHECK")=$O(^LRO(68,"B",$P(LRACC," "),0))  ;cmi/maw 2/9/2009 
 Q:'$G(BLRRL("ACCCHECK"))  ;cmi/maw 2/9/2009
 Q:'$D(^BLRSITE("ACC",BLRRL("ACCCHECK"),$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),BLRRL("RL")))  ;2/9/09 quit if not a reference lab accession
 S BLRRL("LRTS")=$S(+$G(LRTS):+LRTS,1:$G(LRTSORU))
 Q:$G(BLRRL("LRTS"))=""  ;1/23/2006 don't proceed without a test
 I '$G(BLRRLCNT) S BLRRLCNT=0
 ;cmi/anch/maw 2/24/2006 added look for LRPHMAN before asking for comments
 ;cmi/anch/maw 2/28/2006 added AAA tag for allowing edit of ask at accession questions
AAA I '$O(BLRRLC(0)),$P($G(XQY0),U)'="LRPHMAN" S BLRRLSUC=$$COM^BLRRLCOM(BLRRL("LRTS"),0)  ;cmi/anch/maw modified due to routine collect no LRTS 9/8/2004
 I $O(BLRRLC(0)) D
 . S DIR(0)="Y",DIR("A")="Are the responses to the Ask At Accession questions correct "
 . S DIR("B")="Y"
 . D ^DIR
 . I '$G(Y) D  G AAA
 .. D DISAAQ(.BLRCNT,BLRRL("LRTS"),.BLRRLC)
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
 S BLRRL("TCODEE")=$$CODE(BLRRL("RL"),BLRRL("TST"))  ;lookup test code
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
 I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)'="C" D BILL^BLRRLHL
 ;cmi/anch/maw 3/3/2006 end of mods
 I '$G(BLRRLCLA) D CLIENT^BLRRLHL
 I '$G(BLRRL("CLIENT")) S BLRRL("CLIENT")=$G(BLRRLCLT)
 I '$G(BLRRL("CLIENT")) S BLRRL("CLIENT")=$O(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RLCA","B",""))
 I $G(BLRRL("CLIENT"))="" S BLRRL("CLIENT")=$P($G(^BLRRL(BLRRL("RL"),0)),U,13)
 I $G(BLRRL("BILL TYPE"))="" S BLRRL("BILL TYPE")=$G(BLRRLBTP)
 D TMPSET(.BLRRL)
 I $P($G(XQY0),U)="LRPHMAN" D  ;cmi/anch/maw added for ward collection list 2/23/2006
 . D PRT^BLRSHPM
 S X="BLR REFLAB ACCESSION A TEST",DIC=101 D EN^XQOR  ;call accession protocol
 K BLRRL,BLRRLC(BLRTSTDA),LRTEST,PAT
 Q
 ;
TMPSET(BLRSHP) ;-- setup the array for the shipping manifest
 N BLRDA,BLRDATA
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:BLRDA?.N
 . ;cmi/anch/maw 7/24/2007 right here you could store by order number if passed in at the top
 . S BLRDATA=$G(BLRSHP(BLRDA))
 . I '$D(^TMP("BLRRL",$J,BLRDA)) S ^TMP("BLRRL",$J,"COMMON",BLRDA)=BLRDATA
 N BLRDA,BLRDATA,BLRIEN
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:BLRDA'?.N
 . S BLRIEN=0 F  S BLRIEN=$O(BLRSHP(BLRDA,BLRIEN)) Q:BLRIEN=""  D
 .. Q:BLRIEN="COMMENT"
 .. S BLRDATA=$G(BLRSHP(BLRDA,BLRIEN))
 .. I '$D(^TMP("BLRRL",$J,BLRDA,BLRIEN)) S ^TMP("BLRRL",$J,BLRDA,BLRIEN)=BLRDATA
 N BLRDA,BLRDATA,BLRIEN,BLROEN
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:BLRDA'?.N
 . S BLRIEN=0 F  S BLRIEN=$O(BLRSHP(BLRDA,BLRIEN)) Q:BLRIEN=""  D
 .. Q:BLRIEN="COMMENT"
 .. S BLROEN=0 F  S BLROEN=$O(BLRSHP(BLRDA,BLRIEN,BLROEN)) Q:'BLROEN  D
 ... S BLRDATA=$G(BLRSHP(BLRDA,BLRIEN,BLROEN))
 ... I '$D(^TMP("BLRRL",$J,BLRDA,BLRIEN,BLROEN)) S ^TMP("BLRRL",$J,BLRDA,BLRIEN,BLROEN)=BLRDATA
 N BLRDA,BLRIEN,BLROEN,BLRDATA
 S BLRDA=0 F  S BLRDA=$O(BLRSHP(BLRDA)) Q:BLRDA=""  D
 . Q:'BLRDA
 . S BLRIEN=0 F  S BLRIEN=$O(BLRSHP(BLRDA,"COMMENT",BLRIEN)) Q:'BLRIEN  D
 .. S BLRDATA=$G(BLRSHP(BLRDA,"COMMENT",BLRIEN))
 .. I '$D(^TMP("BLRRL",$J,BLRDA,"COMMENT",BLRIEN)) S ^TMP("BLRRL",$J,BLRDA,"COMMENT",BLRIEN)=BLRDATA
 Q
 ;
CODE(RL,TST)      ;lookup the test code via prefix and test
 K BLRTCODE,BLRSHPC
 I '$D(^BLRRL(RL,1,0)) Q 0
 S BLRRDA=0 F  S BLRRDA=$O(^BLRRL("ALP",TST,RL,BLRRDA)) Q:'BLRRDA!($G(BLRTCODE)]"")  D
 . S BLRTCODE=$P($G(^BLRRL(RL,1,BLRRDA,0)),U,3)
 . S BLRSHPC=$P($G(^BLRRL(RL,1,BLRRDA,0)),U,5)
 . Q:$G(BLRTCODE)]""
 I $G(BLRTCODE)="" Q 0
 Q BLRTCODE_U_BLRSHPC
 ;cmi/anch/maw end REF LAB
 ;
DISAAQ(BLRCNT,TIEN,AAQ) ;-- display the ask at order questions
 N A,BLRCNT
 S BLRCNT=0
 S A=0 F  S A=$O(AAQ(TIEN,A)) Q:'A  D
 . S BLRCNT=BLRCNT+1
 . W !,A_") ",$P(AAQ(TIEN,A),U,2),?50,$P(AAQ(TIEN,A),U,3)
 W !
 N RES
 K DIR
 S DIR(0)="N^1:"_BLRCNT
 S DIR("A")="Edit Which Ask At Accession Question "
 D ^DIR
 Q:$D(DIRUT)
 S RES=+Y
 K DIR
 S DIR(0)="F",DIR("A")=$P(AAQ(TIEN,RES),U,2)
 S DIR("B")=$P(AAQ(TIEN,RES),U,3)
 D ^DIR
 Q:$D(DIRUT)
 S $P(BLRRLC(TIEN,RES),U,3)=Y
 Q
 ;
 ;----- END IHS MODIFICATIONS LR*5.2*1021
