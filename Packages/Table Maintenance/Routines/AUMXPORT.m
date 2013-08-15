AUMXPORT ;IHS/OIT/NKD - MARK PT'S FOR REG EXPORT 05/23/2012 ; 
 ;;12.0;TABLE MAINTENANCE;**3**;SEP 27,2011;Build 1
 ;
 ;10.1;TABLE MAINTENANCE;**1**;OCT 16, 2009
 ;IHS/SET/GTH AUM*3.1*4 12/02/2002 - Communities dif Area same name.
 Q
 ;
 ; ----------------------------------------------------------------
 ;
SETUP ;
 ;Begin New Code;IHS/SET/GTH AUM*3.1*4 12/02/2002
 I '$D(ZTQUEUED) D
 . ;W !,"Checking Patients for Export...",!,"NOTE:  Inactive Patients are no longer exported.",!,"       CURRENT COMMUNITY for Patients will be updated if",!,"       a Community's NAME changed."
 . W !,"Checking Patients for Export..."     ;AUM*9.1*4 IHS/OIT/FCJ CHG ABOVE LINE
 . D WAIT^DICD
 .Q
 ;End New Code;IHS/SET/GTH AUM*3.1*4 12/02/2002
 D NOW^%DTC
 S N=%
 S W="W:'$D(ZTQUEUED) ""."""
 ;I '$D(ZTQUEUED) W !,"Checking Patients for Export...",!,"NOTE:  Inactive Patients are no longer exported." D WAIT^DICD;IHS/SET/GTH AUM*3.1*4 12/02/2002
 Q
 ;
 ; ----------------------------------------------------------------
 ;
COMMMOD(FROM,TO) ;EP - SET ^AGPATCH for Community Code Changes.
 ;
 ;  SET ^AGPATCH(NOW,DUZ(2),DFN)="" for a changed community.
 ;  The above was confirmed and agreed upon with the owner of
 ;  ^AGPATCH (Registration).
 ;
 ;  Patients are not marked if the only change is to Name of Community.
 ;  Inactivated patients are not marked.
 ;
 ;  AUMRTN is the name of the routine containing the Community
 ;  Code changes, usually named in the form "AUM"_vv_pp_"A",
 ;  where vv is the last 2 digits of the version of AUM, and pp
 ;  is the patch number.
 ;
 NEW D,DFN,L,N,T,W
 ;
 ; D = Site DUZ(2).
 ; L = Name of the community being processed.
 ; FROM = "FROM" string.
 ; TO = "TO" string.
 ; N = NOW
 ; T = Counter
 ; W = Write dot if not q'd.
 ;
 D SETUP
 ;
 X W
 ;I $P(FROM,U,1,3)=$P(TO,U,1,3),$P(FROM,U,5,6)=$P(TO,U,5,6) Q;IHS/SET/GTH AUM*3.1*4 12/02/2002
 I $P(FROM,U,1,3)=$P(TO,U,1,3),$P(FROM,U,5,6)=$P(TO,U,5,6) D COMNAM($P(FROM,U,4),$TR($P(TO,U,1,3),"^")) Q 0 ;IHS/SET/GTH AUM*3.1*4 12/02/2002
 S L=$P(TO,U,4),DFN=0
 F  S DFN=$O(^AUPNPAT("AC",L,DFN)) Q:'DFN  D
 . X W
 . ;S D=$O(^AUPNPAT(DFN,41,0));IHS/SET/GTH AUM*3.1*4 12/02/2002
 . ;X W;IHS/SET/GTH AUM*3.1*4 12/02/2002
 . ;I D,'$$INAC(DFN,D) S ^AGPATCH(N,D,DFN)="";IHS/SET/GTH AUM*3.1*4 12/02/2002
 . I $$ACT(DFN),$$COM(DFN,$TR($P(TO,U,1,3),"^")) S ^AGPATCH(N,$P($$ACT(DFN),U,2),DFN)="" ;IHS/SET/GTH AUM*3.1*4 12/02/2002
 ; --- If the Name changed, use the old name, too, since the
 ; --- CURRENT COMMUNITY field in PATIENT is free text, and
 ; --- doubtful to be updated.
 I $P(FROM,U,4)'=$P(TO,U,4) S L=$P(FROM,U,4),DFN=0 D
 . F  S DFN=$O(^AUPNPAT("AC",L,DFN)) Q:'DFN  D
 .. X W
 .. ;S D=$O(^AUPNPAT(DFN,41,0));IHS/SET/GTH AUM*3.1*4 12/02/2002
 .. ;X W;IHS/SET/GTH AUM*3.1*4 12/02/2002
 .. ;I D,'$$INAC(DFN,D) S ^AGPATCH(N,D,DFN)="";IHS/SET/GTH AUM*3.1*4 12/02/2002
 .. I $$ACT(DFN),$$COM(DFN,$TR($P(TO,U,1,3),"^")) S ^AGPATCH(N,$P($$ACT(DFN),U,2),DFN)="" ;IHS/SET/GTH AUM*3.1*4 12/02/2002
 ..Q
 . D COMNAM($P(FROM,U,4),$TR($P(TO,U,1,3),"^")) ;IHS/SET/GTH AUM*3.1*4 12/02/2002
 G COUNT
 ;
 ; ----------------------------------------------------------------
 ;
LOCMOD(FROM,TO) ;EP - SET ^AGPATCH for Location Code Changes.
 ;  See Community Code documentation.
 ;
 NEW D,DFN,L,N,T,W
 ;
 D SETUP
 ;
 KILL ^TMP("AUMXPORT",$J)
 ;
 X W
 I $P(FROM,U,1,3)=$P(TO,U,1,3) Q 0
 S L=$P(TO,U,1,3),L=$TR(L,"^",""),D=$O(^AUTTLOC("C",L,0))
 I D S ^TMP("AUMXPORT",$J,D)=""
 ;
 S %="^AUPNPAT(""D"",0,0,0)"
 F  S %=$Q(@%) Q:'$L(%)  D
 .X:'((+$P(%,",",3))#1000) W
 .I $D(^TMP("AUMXPORT",$J,+$P(%,",",4))),'$$INAC(+$P(%,",",3),+$P(%,",",4)) S ^AGPATCH(N,+$P(%,",",4),+$P(%,",",3))=""
 ;
 KILL ^TMP("AUMXPORT",$J)
 ;
 G COUNT
 ;
 ; ----------------------------------------------------------------
 ;
 ;
CLINMOD(AUMRTN) D SETUP G COUNT ; Not used as of Sep 2002.
 ; ----------------------------------------------------------------
CNTYMOD(AUMRTN) D SETUP G COUNT ; Not used as of Sep 2002.
 ; ----------------------------------------------------------------
RESMOD(AUMRTN) D SETUP G COUNT ; Not used as of Sep 2002.
 ; ----------------------------------------------------------------
TRIBMOD(AUMRTN) D SETUP G COUNT ; Not used as of Sep 2002.
 ; ----------------------------------------------------------------
 ;
COUNT ; Return the number of patients marked for export because of change.
 ; All EPs come here.
 ; T is what gets returned, regardless of entry point.
 S (D,T)=0
 F  S D=$O(^AGPATCH(N,D)) Q:'D  D
 . X W
 . S DFN=0
 . F  S DFN=$O(^AGPATCH(N,D,DFN)) Q:'DFN  X W S T=T+1
 Q T
 ;
ALL() ; W $$ALL^AUMXPORT() to mark all active Pts for export.
 NEW D,DFN,L,N,T,W
 D SETUP
 S DFN=0,L=$P(^AUPNPAT(0),U,3)
 W:'$D(ZTQUEUED) !
 S DX=$X,DY=$Y
 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 . Q:'$D(^DPT(DFN))
 . S D=0
 . F  S D=$O(^AUPNPAT(DFN,41,D)) Q:'D  I '$$INAC(DFN,D) S ^AGPATCH(N,D,DFN)=""
 . I '(DFN#100),'$D(ZTQUEUED) X IOXY W "On IEN ",DFN," of ",L," in ^AUPNPAT(..."
 .Q
 ;
 W:'$D(ZTQUEUED) !!,"If you change your mind, you need to KILL ^AGPATCH(",N,").",!!
 S DX=$X,DY=$Y,W=$S('$D(ZTQUEUED):"X IOXY W ""Counting..."",T",1:"")
 G COUNT
 ;
INAC(DFN,D) ; Pt is inactive if inactive date, or status is Deleted or Inactive.
 ;
 I $P($G(^AUPNPAT(DFN,41,D,0)),U,3) Q 1 ; Inactive Date
 I '$L($P($G(^AUPNPAT(DFN,41,D,0)),U,5)) Q 0
 I "DI"[$P($G(^AUPNPAT(DFN,41,D,0)),U,5) Q 1 ; Deleted or Inactive
 Q 0
 ;
 ;Begin New Code;IHS/SET/GTH AUM*3.1*4 12/02/2002
COM(DFN,AUMCC) ; Is Current Res for DFN the same as the Community changed?
 ;
 NEW D,FROM,L,N,T,TO,W
 ;
 Q:$$COMMRES^AUPNPAT(DFN)=AUMCC 1
 Q 0
 ;
ACT(DFN) ; Pt is Active if at least one ORF HRN is not Inactive AND not Deleted.
 ;
 NEW A,D
 ;
 S (A,D)=0
 F  S D=$O(^AUPNPAT(DFN,41,D)) Q:'D  D  Q:A
 . Q:'$D(^AGFAC("AC",D,"Y"))  ; Not an ORF.
 . Q:$P($G(^AUPNPAT(DFN,41,D,0)),U,3)  ; Inactive Date
 . I $L($P($G(^AUPNPAT(DFN,41,D,0)),U,5)),"DI"[$P(^(0),U,5) Q  ; Deleted or Inactive
 . S A=1_U_D ; Got one.  Pt is Active at an ORF.
 .Q
 Q A
 ;
COMNAM(AUMCNAME,AUMSCC) ;Community NAME changed.  Update CURRENT COMMUNITY.
 ;
 ; AUMCNAME = OLD Community Name.
 ; AUMSCC = NEW Community Sta/County/Code, since it's been updated.
 ;
 ; Find all Pts with a CURRENT COMMUNITY name of the OLD value,
 ; and update the free text CURRENT COMMUNITY.
 ;
 NEW D,FROM,L,N,T,TO,W,DA,DIE,DR
 ;
 S DA=0,DIE=9000001
 F  S DA=$O(^AUPNPAT("AC",AUMCNAME,DA)) Q:'DA  D
 . W:'$D(ZTQUEUED) "."
 . Q:'$$COM(DA,AUMSCC)  ; Quit if not CurrComm for Pt.
 . S DR="1118///"_$$GET1^DIQ(9000001,DA,1117)
 . D ^DIE
 .Q
 Q
 ;End New Code;IHS/SET/GTH AUM*3.1*4 12/02/2002
