BLRRLEVT ;cmi/anch/maw - BLR Reference Lab Event ; 27-Jul-2015 06:30 ; MAW
 ;;5.2;IHS LABORATORY;**1027,1030,1031,1033,1034,1035,1036**;NOV 01, 1997;Build 10
 ;
 Q
 ;
LEDI ;-- LEDI III insurance stuff
 N BLRA,BLRC,BLRB
 K BLRRLC
 S BLRLEDI=1
 S BLRTS=$S(+$G(LRTS):+LRTS,$G(LRTSTS):+LRTSTS,1:+$G(LRTSORU))
 ; ----- BEGIN IHS/CMI/MAW - LR*5.2*1031
 ;ihs/cmi/maw 11/15/2011 added the following for ehr ordering
 Q:'$G(LROLLOC)
 Q:'$P($G(^SC(LROLLOC,0)),U,4)
 S BLRALTDZ=$S($P($G(^SC(LROLLOC,0)),U,4):$P($G(^SC(LROLLOC,0)),U,4),1:DUZ(2))
 Q:'+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))
 S LRDUZ(2)=BLRALTDZ
 ; ----- END IHS/CMI/MAW - LR*5.2*1031
 ;I BLRPHASE="O" D  ;cmi/maw 5/30/2007 added for institution entry of file 44 so that it gets correct accession area from file 60 otherwise it gets duz(2)
 ;. Q:'$$SENDOUT(BLRALTDZ,BLRTS)
 ;. I '$G(BLRO) S BLRO=$$ORD^BLRRLEDI(LRORD,DFN)
 ;. Q:'$G(BLRO)
 ;. I $G(BLRTS) D LEDIAAA
 ;. Q:$G(BLRDXS)
 ;. ; ihs/cmi/maw patch 1034 we no longer want to ask DX at order time
 ;. I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)="T" D DX^BLRRLEDI(LRORD)
 ;. K BLRO,BLRRLC
 Q:BLRPHASE'="A"  ;quit if not an accession
 S BLRRL("RL")=+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))  ;ref lab site maw modified 5/29/2007
 Q:'BLRRL("RL")
 Q:'$$NOMAP(BLRRL("RL"),+$G(BLRTS),$G(LROLLOC))  ;ihs/cmi/maw 07/15/2015 p1035 maintenance dont proceed if not a mapped test
 ;Q:'$$SENDOUT($G(BLRALTDZ),$G(BLRTS))  ; IHS/MSC/MKK - LR*5.2*1031 -- Possible null variable(s)
 S BLRO=$O(^BLRRLO("B",LRORD,0))
 I $G(BLROPT)="ADDCOL",'+$G(LRQUIET) D
 . ;ihs/cmi/maw 12/30/2014 p1034 for lab collect reference lab
 . ;we need to reset the order number here
 . N BLRNORD,BLRNORDI
 . S BLRNORDI=$O(^BLRRLO("ACC",LRUID,0))
 . I BLRNORDI S BLRNORD=$P($G(^BLRRLO(BLRNORDI,0)),U)
 . I '$G(BLRNORD) S BLRNORD=LRORD
 . S BLRORDLC(BLRNORD)=""
 . D PRTLC^BLRRLEVN(BLRNORD,LRUID,DFN,LRLLOC,LRODT,LRPRAC,LRTSTS)
 . S BLRLCLNT(BLRNORD)=1
 . S LRORD=BLRNORD
 I '$G(BLRO) S BLRO=$$ORD^BLRRLEDI(LRORD,DFN)
 S BLRA=$$ACC^BLRRLEDI(LRUID,LRORD,DFN,LRCDT)
 Q:'BLRA
 I $G(BLRTS) D LEDIAAA  ;ihs/cmi/maw p1034
 I '$G(BLRASFLG) S BLRC=$$CLIENT^BLRRLEDI(LRORD,LRUID)
 S BLRASFLG=1
 ;I $P($G(^BLRRLO(BLRO,4,0)),U,4) D SETAO(BLRO),LEDIAAA
 K BLRRLC
 ;I $O(^BLRRLO(BLRO,4,"B",BLRTS,0)) D SETAO(BLRO,BLRTS),LEDIAAA
 S BLRB=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)
 I '+$G(BLRAGUI),$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)="T" D
 . K BLRDXS,BLRDFLG
 . D DX^BLRRLEDI(LRORD)
 I '+$G(BLRAGUI),'$G(BLRINS) D BILL^BLRRLEDI(BLRB,LRORD,LRUID,LRCDT)
 I $G(BLRAGUI) I "CTP"[$G(BLRBT) S BLRRL("BILL TYPE")=BLRBT,BLRINS=1 S BT=$$BTP^BLRRLEDI(LRORD,BLRBT)
 K BLRO,BLRRLC
 Q
 ;
SETAO(RO,TS) ;-- setup the ask at order array from whats in the BLRRLO global
 N ADA,DATA,TST,QUES,ANS,RSC
 K BLRRLC
 S ADA=0 F  S ADA=$O(^BLRRLO(RO,4,"B",TS,ADA)) Q:'ADA  D
 . S DATA=$G(^BLRRLO(RO,4,ADA,0))
 . S TST=$P(DATA,U),QUES=$P(DATA,U,3),ANS=$P(DATA,U,4),RSC=$P(DATA,U,5)
 . S BLRRLC(TST,ADA)=RSC_U_QUES_U_ANS
 Q
 ;
LEDIAAA ;-- ledi ask at order question
 I '$O(BLRRLC(0)),$P($G(XQY0),U)'="LRPHMAN" S BLRRLSUC=$$COM^BLRRLCOM(BLRTS,1)  ;cmi/anch/maw modified due to routine collect no LRTS 9/8/2004
 ; I $O(BLRRLC(0)) D
 I $O(BLRRLC(0)),'+$G(LRQUIET) D  ; IHS/MSC/MKK - LR*5.2*1035
 . S DIR(0)="Y",DIR("A")="Are the responses to the Ask At Accession questions correct ",DIR("B")="Y"
 . D ^DIR
 . I '$G(Y) D  G LEDIAAA
 .. D DISAAQ(.BLRCNT,BLRTS,.BLRRLC)
 D FLAO(.BLRRLC,BLRTS,BLRO,$G(LRUID),1)
 Q
 ;
FLAO(RLC,T,RL,ACC,LEDI) ;-- file the ask at order questions
 I $G(LEDI) D CLNAO(RL,T)
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
CLNAO(L,T) ;-- clean ot the ask at order questions
 S DA=0 F  S DA=$O(^BLRRLO(L,4,"B",T,DA)) Q:'DA  D
 . S DA(1)=L
 . S DIK="^BLRRLO("_DA(1)_",4,"
 . D ^DIK
 K DA,DIK
 Q
 ;
SENDOUT(AC,LRT) ;-- check if a valid sendout test
 Q:$G(AC)=""!($G(LRT)="") 0  ; IHS/MSC/MKK - LR*5.2*1031
 ;
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
 Q:$G(BLROPT)="ADDACC"  ;p1034 dont hit event driver if adding a test
 S BLRRL("ALTDUZ2")=$G(BLRALTDZ)  ;cmi/maw 5/29/2007 setup alternate duz2 if they select the prompt in blrsite to look at ordering location
 I $G(BLRALTDZ),$P($G(^BLRSITE(BLRALTDZ,"RL")),U,10)="D" K BLRALTDZ,BLRRL("ALTDUZ2")  ;don't need variables if they use a true multidivisional site
 I $G(BLRALTDZ),$P($G(^BLRSITE(BLRALTDZ,"RL")),U,10)="" K BLRALTDZ,BLRRL("ALTDUZ2")  ;don't need variables if they use a true multidivisional site
 S BLRRL("RL")=+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))  ;ref lab site maw modified 5/29/2007
 Q:'BLRRL("RL")
 Q:'$$NOMAP(BLRRL("RL"),+$G(LRTS),$G(LROLLOC))  ;ihs/cmi/maw 07/15/2015 p1035 maintenance dont proceed if not a mapped test
 S BLRRL("RLE")=$P($G(^BLRRL(BLRRL("RL"),0)),U)  ;get external name
 S BLRRL("PAT")=$G(DFN)  ;patient
 I $G(LRAA) S BLRRL("ACCCHECK")=LRAA  ;cmi/maw 2/9/2009
 I $G(LRACC)]"" S BLRRL("ACCCHECK")=$O(^LRO(68,"B",$P(LRACC," "),0))  ;cmi/maw 2/9/2009 
 Q:'$G(BLRRL("ACCCHECK"))  ;cmi/maw 2/9/2009
 Q:'$D(^BLRSITE("ACC",BLRRL("ACCCHECK"),$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),BLRRL("RL")))  ;2/9/09 quit if not a reference lab accession
 S BLRRL("LRTS")=$S(+$G(LRTS):+LRTS,1:$G(LRTSORU))
 Q:$G(BLRRL("LRTS"))=""  ;1/23/2006 don't proceed without a test
 S BLRTS=$S(+$G(LRTS):+LRTS,1:$G(LRTSORU))
 I '$G(LRORD) S LRORD=$G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.1))  ;p1034
 S BLRO=$O(^BLRRLO("B",LRORD,0))  ;p1034
 I '$G(BLRO) S BLRO=$$ORD^BLRRLEDI(LRORD,DFN)  ;added non ledi p1034
 I '$O(^BLRRLO("ACC",LRUID,0)) S BLRA=$$ACC^BLRRLEDI(LRUID,LRORD,DFN,LRCDT)  ;added non ledi p1034
 I '$G(BLRRLCNT) S BLRRLCNT=0
AAA I '$O(BLRRLC(0)),$P($G(XQY0),U)'="LRPHMAN" S BLRRLSUC=$$COM^BLRRLCOM(BLRRL("LRTS"),0)  ;cmi/anch/maw modified due to routine collect no LRTS 9/8/2004
 I ('$G(LRQUIET))&$O(BLRRLC(0)) D
 . S DIR(0)="Y",DIR("A")="Are the responses to the Ask At Accession questions correct ",DIR("B")="Y"
 . D ^DIR
 . I '$G(Y) D  G AAA
 .. D CLNAO(BLRO,BLRTS),DISAAQ(.BLRCNT,BLRRL("LRTS"),.BLRRLC)
 D FLAO(.BLRRLC,BLRTS,BLRO,$G(LRUID),1)
 Q:$G(BLRTS)=""  ;1/23/2006 don't proceed without a test
 S BLRTSTDA=+$G(BLRTS)
 ;
 ; LR*5.2*1034 - Numerous lines of commented out code deleted -- see BLRRLEVD routine.
 ;
 I +$G(LRQUIET) D
 .I $G(BLRBT)="T" S BLRRL("BILL TYPE")="T" D BILL^BLRAG05C    ; IHS/MSC/SAT - LR*5.2*1031
 .S BLRRL("BILL TYPE")=$S($G(BLRBT)="C":"C",$G(BLRBT)="P":"P",1:"")
 I $G(BLROPT)="ADDCOL",'+$G(LRQUIET) D
 . ;ihs/cmi/maw 12/30/2014 p1034 for lab collect reference lab
 . ;we need to reset the order number here
 . N BLRNORD,BLRNORDI
 . S BLRNORDI=$O(^BLRRLO("ACC",LRUID,0))
 . I BLRNORDI S BLRNORD=$P($G(^BLRRLO(BLRNORDI,0)),U)
 . I '$G(BLRNORD) S BLRNORD=LRORD
 . S BLRORDLC(BLRNORD)=""
 . D PRTLC^BLRRLEVN(BLRNORD,LRUID,DFN,LRLLOC,LRODT,LRPRAC,LRTSTS)
 . I '$G(BLRLCLNT(BLRNORD)) D CLIENT^BLRRLHL,CLIENTG^BLRRLEDI(BLRNORD,LRUID)
 . S BLRLCLNT(BLRNORD)=1
 I '$G(BLRRLCLA),'+$G(LRQUIET) D CLIENT^BLRRLHL,CLIENTG^BLRRLEDI(LRORD,LRUID)
 ;I '+$G(LRQUIET),$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)'="C" D BILL^BLRRLHL   ; IHS/MSC/SAT - LR*5.2*1031
 I '+$G(LRQUIET),$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)="T" D  ;ihs/cmi/maw - LR*5.2*1034
 . K BLRDXS,BLRDFLG
 . Q:$G(BLRASFLG)
 . D CLIENTG^BLRRLEDI(LRORD,LRUID)
 . D DX^BLRRLEDI(LRORD)
 . S BLRB=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)
 . I '+$G(BLRAGUI),'$G(BLRINS) D BILL^BLRRLEDI(BLRB,LRORD,LRUID,LRCDT)
 . ;D BILL^BLRRLHL
 . S BLRASFLG=1
 ;reset the DX tmp global here
 I '+$G(LRQUIET),$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)="T" D
 . D ADDDX^BLRRLHL2(LRORD)
 . Q:$E($G(BLRRL("BILL TYPE")),1,1)'="T"
 . ;D INS^BLRRLHL(DFN,1)
 ;I '$G(BLRRL("CLIENT")) S BLRRL("CLIENT")=$G(BLRRLCLT)
 ;I '$G(BLRRL("CLIENT")) S BLRRL("CLIENT")=$O(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RLCA","B",""))
 ;I $G(BLRRL("CLIENT"))="" S BLRRL("CLIENT")=$P($G(^BLRRL(BLRRL("RL"),0)),U,13)
 ;I $G(BLRRL("BILL TYPE"))="" S BLRRL("BILL TYPE")=$G(BLRRLBTP)
 ;I $G(BLROPT)'="ADDCOL" D TMPSET(.BLRRL)
 I +$G(BLRAGUI)!(BLROPT="ADDCOL") D  ;cmi/anch/maw added for ward collection list 2/23/2006
 . ;cmi/maw p1033 added order number, dob, sex back because its missing from the message post 1031 patch
 . K DOB,SEX  ;lets reset DOB and sex here as it seems to not work correctly on Collection list
 . N ORDNUM
 . S ORDNUM=$G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.1))
 . S BLRRL("ORD")=ORDNUM
 . S:$G(BLRTSTDA) BLRRL(BLRTSTDA,"ORD")=$G(ORDNUM)
 . N PAI,PA
 . S PAI=$P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),0)),U)
 . Q:'$G(PAI)
 . Q:$P(^LR(PAI,0),U,2)'=2
 . S PA=$P(^LR(PAI,0),U,3)
 . Q:'$G(PA)
 . S DOB=$P($G(^DPT(PA,0)),U,3)
 . S SEX=$P($G(^DPT(PA,0)),U,2)
 . ;D PRT^BLRSHPM
 . I +$G(BLRAGUI) D SHIPMAN^BLRRLEVN(ORDNUM,0)  ;p1036
 ;S X="BLR REFLAB ACCESSION A TEST",DIC=101 D EN^XQOR  ;call accession protocol
 ;K BLRRL,LRTEST,PAT
 ;I $G(BLRTSTDA)]"" K BLRRLC(BLRTSTDA)
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
NOMAP(RL,TST,LOC) ;-- check if the test is mapped
 ;ihs/cmi/maw 07/16/2015 p1035
 N ORDLINST,MAPPED,IEN
 S ORDLINST=+$$GET1^DIQ(44,LOC,3,"I")              ; Ord Loc's Institution
 I +$$GET1^DIQ(9009029,ORDLINST,3022,"I"),$D(^LAHM(62.9,"D",ORDLINST)) D  Q +$G(MAPPED)
 . S MAPPED=$$CHECKMAP(ORDLINST,TST)
 Q $S(+$O(^BLRRL("ALP",TST,RL,0)):1,1:0)
 Q
 ;
CHECKMAP(INST,TS) ;-- there can be multiple entries mapped
 N MATCH,MDA
 S MATCH=0
 S MDA=0 F  S MDA=$O(^LAHM(62.9,"D",INST,MDA)) Q:'MDA  D
 . I $O(^LAHM(62.9,MDA,60,"B",TS,0)) S MATCH=1
 Q +$G(MATCH)
 ;
