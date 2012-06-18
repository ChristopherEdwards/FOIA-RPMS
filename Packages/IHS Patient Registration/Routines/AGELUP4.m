AGELUP4 ;IHS/SET/GTH - UPDATE ELIGIBILITY FROM FILE  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
D(AG) ;EP - process Medicaid
 ;See update matrix, in FILE subroutine.
 KILL AG1,AG2,AGSAME
 ;Check for -exact- match, -or- all Elig dates.
 I $D(^AUPNMCD("AB",AG("DFN"),AGMCDST)) D  Q:$G(AGSAME)
 . S AG("MNBR")=""
 . F  S AG("MNBR")=$O(^AUPNMCD("AB",AG("DFN"),AGMCDST,AG("MNBR"))) Q:'$L(AG("MNBR"))  D  Q:$G(AGSAME)
 .. S AG("IEN")=0
 .. F  S AG("IEN")=$O(^AUPNMCD("AB",AG("DFN"),AGMCDST,AG("MNBR"),AG("IEN"))) Q:'AG("IEN")  D MCDY I AGSAME S AGACT="S" Q
 ..Q
 .Q
 ;Find most recent entry that matches demographic data (no dates).
 ;If found AG("IEN") will be it.
 I $D(^AUPNMCD("AB",AG("DFN"),AGMCDST)) D
 . S AG("MNBR")=""
 . F  S AG("MNBR")=$O(^AUPNMCD("AB",AG("DFN"),AGMCDST,AG("MNBR")),-1) Q:'$L(AG("MNBR"))  D  Q:$G(AGSAME)
 .. S AG("IEN")=""
 .. F  S AG("IEN")=$O(^AUPNMCD("AB",AG("DFN"),AGMCDST,AG("MNBR"),AG("IEN")),-1) Q:'AG("IEN")  D  Q:$G(AGSAME)
 ... ;MediCaid name.
 ... Q:'(AG("FNM")=$P($G(^AUPNMCD(AG("IEN"),21)),U,1))
 ... ;MediCaid DOB.
 ... Q:'(AG("FDOB")=$P($G(^AUPNMCD(AG("IEN"),21)),U,2))
 ... ;MediCaid Number.
 ... I '(AG("FNBR")=$P(^AUPNMCD(AG("IEN"),0),U,3)),'((+AG("FNBR"))=(+$P(^AUPNMCD(AG("IEN"),0),U,3))) Q
 ... S AGSAME=1
 ...Q
 ..Q
 .Q
 ;If demographic data does not match, but Pt has MCD entry,
 ;get highest IEN.
 I '$G(AG("IEN")),$D(^AUPNMCD("AB",AG("DFN"),AGMCDST)) NEW I D  I I S AG("IEN")=I
 . NEW N,T
 . S N="",I=0
 . F  S N=$O(^AUPNMCD("AB",AG("DFN"),AGMCDST,N)) Q:'$L(N)  S T=$O(^(N,0)) I T>I S I=T
 .Q
 I $G(AG("IEN")) D MCDY ;Make sure Dif flags are set.
 I AGAUTO'="A" D  Q
 . D HEAD^AGELUPUT("MEDICAID")
 . I '$D(^AUPNMCD("AB",AG("DFN"),AGMCDST)) D MCDN
 . D MDISP^AGELUP2(5),PEND^AGELUPUT
 .Q
 U IO(0)
 W "."
 W:'(AGRCNT#100) $J(AGRCNT,8)
 Q
MCDY ;if medicaid coverage
 S AGSAME=0
 ;MediCaid name.
 S (AGMNM,AG1(1))=$P($G(^AUPNMCD(AG("IEN"),21)),U)
 ;MediCaid DOB.
 S AGMDOB=$P($G(^AUPNMCD(AG("IEN"),21)),U,2)
 S AG1(2)=AGMDOB
 ;MediCaid Number.
 S (AGMNBR,AG1(3))=$P(^AUPNMCD(AG("IEN"),0),U,3)
 S AG1(4)=""
 ;AG1("DT",EligDt,CovType)=EligDt^ELigEndDt^CovType
 S DA=0
 F  S DA=$O(^AUPNMCD(AG("IEN"),11,DA)) Q:'DA  S %=^(DA,0) S:$P(%,U,3)="" $P(%,U,3)=" " S AG1("DT",$P(%,U,1),$P(%,U,3))=%
 KILL AGFL
 D DFL
 S:'$D(AGFL) AGSAME=1
 Q
MCDN ;EP - No MCD coverage in rpms.
 S AG1(1)="NO ELIGIBILITY ON FILE"
 F I=2:1:4 S AG1(I)=""
 D DFL
 Q
DFL ;EP - Set descrepency flags.
 KILL AGFL
 ;M/M Name.
 S AG2(1)=$G(AG("FNM"))
 S:AG2(1)'=$G(AGMNM) AGFL(1)=1
 ;DOB.
 S AG2(2)=$G(AG("FDOB"))
 S:AG2(2)'=$G(AGMDOB) AGFL(2)=1
 ;Number. Check for leading 0's.
 S AG2(3)=$G(AG("FNBR"))
 I '(AG2(3)=$G(AGMNBR)),'((+AG2(3))=(+$G(AGMNBR))) S AGFL(3)=1
 S AG2(4)="" ;Prevent UNDEF.
 ;Compare file eligibilities with existing eligibilities.
 ;AG1("DT",EligDt,CovType)=EligDt^ELigEndDt^CovType
 ;Make the comparison based on the update matrix in FILE(), below.
 ;AG("DT",,) contains the State data.
 NEW I,J
 S I=0
 F  S I=$O(AG("DT",I)) Q:'I  D
 . S J=0
 . F  S J=$O(AG("DT",I,J)) Q:J=""  D
 .. I '$G(AG1("DT",I,J)) S AGFL(5)=1 Q
 .. I AG1("DT",I,J)=AG("DT",I,J) Q
 .. I $P(AG("DT",I,J),U,2)="" Q  ;State EndDate is blank.
 .. I $P(AG1("DT",I,J),U,2)>$P(AG("DT",I,J),U,2) Q
 .. S AGFL(5)=1
 ..Q
 .Q
 ;AG1("DT",,) contains RPMS data.
 S I=0
 F  S I=$O(AG1("DT",I)) Q:'I  D
 . S J=0
 . F  S J=$O(AG1("DT",I,J)) Q:J=""  D
 .. Q:'$D(AG("DT",I,U))  ;Exists in RPMS but not in STATE.
 .. I $P(AG("DT",I,J),U,2)="" Q  ;State EndDate is blank.
 .. I $P(AG1("DT",I,J),U,2)>$P(AG("DT",I,J),U,2) Q
 .. S AGFL(5)=1
 ..Q
 .Q
 Q
FILE(AG) ;EP - File Medicaid
 NEW AGADD,AGUPDATE
 I '$G(AG("IEN")) D  Q:+Y<0  S AGADD=1 I 1
 . NEW DIC,DLAYGO,DD,DO
 . I '("MF"[AG("FSEX")) S AG("FSEX")=""
 . S DIC="^AUPNMCD(",DIC(0)="F",DLAYGO=9000004,X=AG("DFN")
 . S DIC("DR")=".02////"_AGINSPT_";.03///"_AG("FNBR")_";.04////"_AGMCDST_$S($L(AG("FSEX")):";.07///"_AG("FSEX"),1:"")_";.08////"_DT_";2101///"_AG("FNM")_";2102///"_AG("FDOB")
 . D FILE^DICN
 . I +Y>0 S AG("IEN")=+Y D PTACT^AGELUP2(1,AG("DFN"))
 .Q
 E  D  S AGADD=0
 . NEW DA,DIE,DR
 . S DIE="^AUPNMCD(",DA=AG("IEN"),DR=""
 . I $P(^AUPNMCD(DA,0),U,2)'=AGINSPT S DR=".02////"_AGINSPT
 . I AG("FNBR")'="",AG("FNBR")'=$P(^AUPNMCD(DA,0),U,3) S DR=DR_$S($L(DR):";",1:"")_".03///"_AG("FNBR")
 . I AG("FSEX")'="",AG("FSEX")'=$P(^AUPNMCD(DA,0),U,7) S DR=DR_$S($L(DR):";",1:"")_".07///"_AG("FSEX")
 . I AG("FNM")'="",AG("FNM")'=$P($G(^AUPNMCD(DA,21)),U) S DR=DR_$S($L(DR):";",1:"")_"2101///"_AG("FNM")
 . I AG("FDOB")'="",AG("FDOB")'=$P($G(^AUPNMCD(DA,21)),U,2) S DR=DR_$S($L(DR):";",1:"")_"2102////"_AG("FDOB")
 . I $L(DR) NEW DITC S DITC="",DR=DR_";.08////"_DT D ^DIE,PTACT^AGELUP2(2,AG("DFN")):'$D(Y) KILL DITC
 .Q
 ;Here's the matrix what to do with EndDate when StartDate/CovType
 ;agree, but EndDate does not:
 ;
 ;     RPMS             State           Action
 ;     -------------    -------------   ------
 ;(1)  Value            Blank           None
 ;(2)  Blank            Value           Update
 ;(3)  Earlier          Later           Update
 ;(4)  Later            Earlier         None
 ;
 ;Case (3) is when the RPMS EndDate is earlier than the State EndDate.
 ;EndDate will be updated to the later State EndDate.  If the actual DOS
 ;falls between the EndDates, we'd miss the claim.  This is somewhat
 ;inconsistent with (1).
 ;
 ;Case (4) is when the RPMS EndDate is later than the State EndDate.
 ;This is the conservative approach to process the claim, if the actual
 ;DOS is between the EndDates, with the assumption (hope) that the
 ;State's data is....lagging, or wrong, or something.
 ;
 S AGBD=0
 F  S AGBD=$O(AG("DT",AGBD)) Q:'AGBD  D  I AGADD S AGUPDATE=0
 . S AGCT=0
 . F  S AGCT=$O(AG("DT",AGBD,AGCT)) Q:AGCT=""  D
 .. I '$G(AG1("DT",AGBD,AGCT)) D ADD(AGBD,$P(AG("DT",AGBD,AGCT),U,2),AGCT) Q
 .. ;Update EndDate if State has value, RPMS is blank.
 .. I $P(AG("DT",AGBD,AGCT),U,2),'$P(AG1("DT",AGBD,AGCT),U,2) D EDIT(AG("DT",AGBD,AGCT)) Q
 .. ;Update EndDate if State is LATER than RPMS.
 .. I $P(AG("DT",AGBD,AGCT),U,2),$P(AG1("DT",AGBD,AGCT),U,2),$P(AG("DT",AGBD,AGCT),U,2)>$P(AG1("DT",AGBD,AGCT),U,2) D EDIT(AG("DT",AGBD,AGCT))
 ..Q
 .Q
 KILL AGBD,AGCT
 I $G(AGUPDATE) D PTACT^AGELUP2(2,AG("DFN"))
 D UPDATE(AG("DFN"),AG("IEN"))
 Q
UPDATE(DFN,AGIEN)      ;
 NEW AG
 S AG("MCD")=AGIEN
 D UPDATE^AGED5
 Q
ADD(X,AG2,AG3) ;
 NEW DA,DIC,DR
 S DA(1)=AG("IEN"),DIC="^AUPNMCD("_DA(1)_",11,",DIC(0)="F",DIC("P")=$P(^DD(9000004,1101,0),U,2)
 KILL DD,DO
 S DIC("DR")=$S(AG2:".02///"_AG2_";",1:"")_".03///"_AG3
 D FILE^DICN
 I +Y>0 S AGUPDATE=1
 Q
EDIT(AGDATES)  ;
 NEW DA,DIE,DR
 S DA=0
 F  S DA=$O(^AUPNMCD(AG("IEN"),11,DA)) Q:'DA  I $P(AGDATES,U,1)=$P(^(DA,0),U,1),$P(AGDATES,U,3)=$P(^(0),U,3) Q
 Q:'DA  ;Something wrong happended, somewhere.
 S DA(1)=AG("IEN"),DIE="^AUPNMCD("_DA(1)_",11,",DR=".02///"_$P(AGDATES,U,2)
 D ^DIE
 S AGUPDATE=1
 Q
