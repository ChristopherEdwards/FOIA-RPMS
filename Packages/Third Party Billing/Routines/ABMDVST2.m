ABMDVST2 ; IHS/ASDST/DMJ - PCC CLAIM STUFF - PART 3 (PROVIDER) ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/26/96 12:12 PM
 ;This routine loops thru the
 ;the V Provider file 3 times.  First it looks for a valid MD.  Then
 ;it looks for the attendings and operatings.
 ;Then it looks for additional providers for a total of up to 4
 ;including looking at ordering providers in V LAB etc.
 ;The var ABMP("MD") is used in ABMDVST4 to estimate CPT code for a
 ;doctor's visit.
 ;IHS/DSD/LSL - 03/24/98 -  Undefined error on a global.
 ;Global AUPNPRV should be AUPNVPRV
 ;
 ;IHS/SD/SDR - v2.5 p9 - IM16620
 ;   Removed code to make provider rendering
 ;
 Q:ABMIDONE
 N VPRVMD,DOC,DIC,DA,ABMN,ABMPC,ABMPCOD,VPROVC
 ;
PRV ;
 ;The following code is a loop that
 ;goes thru the V provider file until it finds an
 ;"MD" then it quits the loop
 ; If it finds an MD it sets ABMP("MD")
 S ABMP("MD")=""
 S ABMN=0
 S ABM=0
 F  S ABM=$O(^AUPNVPRV("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:ABMP("MD")
 .D PROVMD(ABM)
 .I $G(VPROVC) S ABMP("MD")=VPROVC Q
 ;End of                  1st loop
 ;The 2nd loop looks for attending and operating.  If they are found
 ;they are filed.
PRV2 K DIC,DD,DO
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",41,",DIC(0)="LE"
 S ABMOP=0
 S ABMAT=0
 ;First it loops thru the provider file
 S ABM=0
 F  S ABM=$O(^AUPNVPRV("AD",ABMVDFN,ABM)) Q:'ABM  D
 .Q:'$D(^AUPNVPRV(ABM,0))
 .S Y=^AUPNVPRV(ABM,0)
 .S ABMAT=$S($P(Y,U,5)="A":ABM,$P(Y,U,4)="P":ABM,1:ABMAT)
 .S ABMOP=$S($P(Y,U,5)="O":ABM,1:ABMOP)
 I 'ABMAT,ABMOP S ABMAT=ABMOP
 D:ABMAT
 .D PROVMD(ABMAT)
 .I '$G(VPROVC),ABMP("MD") S ABMAT=ABMP("MD")
 ;If the attending not found check the billing pointer visit
 I 'ABMAT D
 .N GOODP,P,V
 .S V=$P(^AUPNVSIT(ABMVDFN,0),U,28)
 .I V D
 ..S P=""
 ..F  S P=$O(^AUPNVPRV("AD",V,P)) Q:'P  D  Q:$G(GOODP)
 ...S Y=^AUPNVPRV(P,0)
 ...S ABMAT=$S($P(Y,U,5)="A":P,$P(Y,U,4)="P":P,1:ABMAT)
 ...S ABMOP=$S($P(Y,U,5)="O":P,1:ABMOP)
 ...S GOODP=$$GOODPRV(ABMAT)
 ...Q:'GOODP
 ...S GOODP='$$UBILPRV($$DOCLASS(+Y))
 ..Q:$G(GOODP)
 ..I $$GOODPRV(ABMOP),'$$UBILPRV($$DOCLASS(+^AUPNVPRV(ABMOP,0))) D
 ...S ABMAT=ABMOP
 ...S GOODP=1
 .Q:$G(GOODP)
 .;If attending still not found check ordering provider
 .D ORDPROV
 .Q:'$D(ABMORD)
 .S P=""
 .F  S P=$O(ABMORD(P)) Q:'P  D  Q:$G(GOODP)
 ..Q:'ABMORD(P)
 ..Q:$$UBILPRV(ABMORD(P))
 ..S GOODP=1
 ..;Format is diff because ABMAT obtained from provider file is ien
 ..S ABMAT="^"_P_"^"_ABMORD(P)
 N ABMNOFIL
 I ABMAT D
 .S X=ABMAT,ABMPCAT="A"
 .D PRVST
 E  I $L(ABMAT)>1 D
 .S X=$P(ABMAT,U,2)
 .Q:'X
 .S ABMPCAT="A"
 .I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABMPCAT)) D  Q
 ..S ABMNOFIL=1
 .D FILE
 I ABMOP D
 .S X=ABMOP,ABMPCAT="O"
 .D PRVST
 E  I ABMP("VTYP")=111!($G(ABMP("BTYP"))=111),+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,0)),ABMAT D
 .S X=ABMAT,ABMPCAT="O"
 .D PRVST
 S:$G(ABMNOFIL) (ABMAT,ABMOP)=""
 ; End of                    2nd loop  
 ;In the 3rd loop we first count the # of providers already filed
 ;because the max is 4.
 S ABM=0,ABMN=0
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,ABM)) Q:'ABM  S ABMN=ABMN+1
 ;3rd loop
 ;We look for otheR providers not attnd or op that are billable.
 K ABMPCAT
 S ABM=0
 F  S ABM=$O(^AUPNVPRV("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:ABMN>3
 .S ABMAT=$G(ABMAT),ABMOP=$G(ABMOP)
 .Q:ABMAT=ABM
 .Q:ABMOP=ABM
 .Q:'$$GOODPRV(ABM)
 .Q:$$UBILPRV(ABMPC)
 .S X=+^AUPNVPRV(ABM,0)
 .S ABMPCAT="T"
 .D FILE
 G Q:ABMN>3
 I '$D(ABMORD) D ORDPROV
 G Q:'$D(ABMORD)
 S P=""
 F  S P=$O(ABMORD(P)) Q:'P  D  Q:ABMN>3
 .S X=P
 .Q:X=$P(ABMAT,U,2)
 .S ABMPCAT="T"
 .D FILE
Q K ABMORD,ABMAT,ABMOP,ABMR
 Q
 ;
PRVCHK(X) ;Subrtn to find attending and operating
 Q:'$D(^AUPNVPRV(X,0))
 ;If provider Attending or Primary set ABMAT to ien otherwise 0
 I 'ABMAT S ABMAT=$S($P(^AUPNVPRV(X,0),U,5)="A":X,$P(^(0),U,4)="P":X,1:0)
 ;If provider Operating set ABMOP to ien otherwise 0
 I 'ABMOP S ABMOP=$S($P(^AUPNVPRV(X,0),U,5)="O":X,1:0)
 Q
 ;
PRVST ;FILE PROVIDER
 ;Check to see if Operating/Attending already in claim file
 ;This code will only allow one attending and one operating to be filed
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABMPCAT)) D  Q
 .S ABMNOFIL=1
PRVST2 S X=$P(^AUPNVPRV(X,0),U)
 ;At this point X has been converted from VPRV ien to file 16 or 200 ien
 ;Checking to see if file 9000010.06 points to file 6
 ;If so convert X to file 200 ien
 ;I ^DD(9000010.06,.01,0)["DIC(6" D
FILE Q:$$UBILPRV($$DOCLASS(X))
 I ABM("DOCFILE")=6 D
 .I $G(^DIC(16,X,"A3")) S X=^("A3") Q
 .S ABMR("PNAME")=$P(^DIC(16,X,0),U)
 .S X=$O(^VA(200,"B",ABMR("PNAME"),0))
 Q:'X
 Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"B",X))
 S DIC("P")=$P(^DD(9002274.3,41,0),U,2)
 S DIC("DR")=".02////"_ABMPCAT
 K DD,DO D FILE^DICN
 S ABMN=ABMN+1
 Q
 ;
ORDPROV ;EP - Requires ABMVDFN (Visit ien) to be defined.
 ;Returns all ordering providers in ABMORD(docien)=Prov class ien
 N VFILE,L
 F VFILE="^AUPNVLAB","^AUPNVMIC","^AUPNVPTH","^AUPNVBB","^AUPNVCYT","^AUPNVMED","^AUPNVRAD" D
 .S L=0
 .F  S L=$O(@VFILE@("AD",ABMVDFN,L)) Q:'L  D
 ..Q:'$D(@VFILE@(L,12))
 ..S DOC=$P(@VFILE@(L,12),U,2)
 ..Q:'DOC
 ..S X=$$DOCLASS(DOC)
 ..S ABMORD(DOC)=X
 Q
 ;
PROVMD(X)          ; 
 ;X contains ien of the V provider file
 ;Returns the V Provider file ien of the provider if a billable
 ;physician in var VPROVC
 Q:'$P($G(^AUPNVPRV(X,0)),U)
 S VPROVC=$$DOCLASS(+^AUPNVPRV(X,0))
 ;At this point VPROVC contains provider class file ien
 Q:'VPROVC
PROVMD2 ;
 I $$UBILPRV(VPROVC) S VPROVC="" Q
 I '$D(^DIC(7,VPROVC,9999999)) S VPROVC="" Q
 S Y=$P(^DIC(7,VPROVC,9999999),U)
 ;Y contains provider class code
 S VPROVC=$S(Y="00"!(Y>69&(Y<87))!(Y=18)!(Y=25)!(Y=33)!(Y=44)!(Y=45)!(Y=49)!(Y=64)!(Y=68):X,1:"")
 ;Finally VPROVC contains the ien of the provider file if the
 ;provider class code is one of the accepted codes.
 ;Codes
 ;00  =  Physician
 ;18  =  Physician (Contract)
 ;25  =  Podiatrist (Contract)
 ;33  =  Podiatrist
 ;41  =  OB/Gyn (Contract)
 ;44  =  Physician (Tribal)
 ;45  =  Osteopath
 ;49  =  Contract Psychiatrist
 ;64  =  Nephrologist
 ;68  =  Emergency Room Physician
 ;70 to 86  =  Various medical specialties
 Q
 ;
DOCLASS(DOC)       ;EP - Get provider class from either file 6 or 200
 ;DOC is the ien of either file 6 or 200 depending on which file is
 ;pointed to by file 9000010.06
 ;This function returns the ien of file 7 the provider class
 N X1
 I $D(ABM("DOCFILE")) D  Q X1
 .S X1=ABM("DOCFILE")
 .S X1=$S(X1=6:$P($G(^DIC(6,DOC,0)),U,4),1:$P($G(^VA(200,DOC,"PS")),U,5))
 I ^DD(9000010.06,.01,0)["DIC(6" D  Q $P($G(^DIC(6,DOC,0)),U,4)
 .S ABM("DOCFILE")=6
 I ^DD(9000010.06,.01,0)["VA(200" D  Q $P($G(^VA(200,DOC,"PS")),U,5)
 .S ABM("DOCFILE")=200
 Q ""
 ;
GOODPRV(ABM)       ;Attempts to reject provider that are never valid
 ;ABM is the ien of V Provider file
 ;Returns true if accepted provider.
 Q:'$P($G(^AUPNVPRV(ABM,0)),U) 0
 S (Y,ABMPC)=$$DOCLASS(+^AUPNVPRV(ABM,0))
 Q:'Y 0
 Q:'$D(^DIC(7,Y,9999999)) 0
 S (Y,ABMPCOD)=+^DIC(7,Y,9999999)
 Q:Y<40 $S(Y<15:1,Y=15:0,Y<20:1,Y=20:0,Y=21:1,Y<24:0,Y<27:1,Y=27:0,1:1)
 Q $S(Y=40:0,Y<56:1,Y<60:0,Y=60:1,Y=61:0,Y<65:1,Y=65:0,Y<88:1,Y=88:0,1:1)
 ;List of invalid provider class codes
 ;15
 ;20
 ;22-23
 ;27
 ;40
 ;57-59
 ;61
 ;65
 ;88
 ;
UBILPRV(PCLSS)     ;Check for unbillable provider classes
 ;PCLSS is the ien of the provider class file #7.
 ;Returns true if files indicate this is an unbillable provider
 N INS,PRI,MCOUT,D2B,COV
 Q:'PCLSS 1
 I $D(^ABMDPARM(DUZ(2),1,17,PCLSS)) Q 1
 ;Look in the insurer subfile of the claim file
 ; look at first priority insurer
 ;The first pri insurer may not be the same as the 1st one in the ABML
 ;array.  Hence the rtn may be able to stuff new providers into the
 ;claim for a previously created claim.
 S D2=0
 S D1=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",1,""))
 S INS=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)
 I INS="" S INS=$S(ABMACTVI]"":ABMACTVI,1:ABMP("INS"))
 ;Vis type 111 is inpatient
 I ABMP("VTYP")'=111 D
 .;Compares prim insurer in claim file with ins in ABML array
 .S PRI=0
 .F  S PRI=$O(ABML(PRI)) Q:'PRI  D  Q:$D(MCOUT)
 ..Q:'$D(ABML(PRI,INS))
 ..S MCOUT=$S($P(ABML(PRI,INS),U,3)?1(1"M",1"R"):1,1:0)
 ..Q:'MCOUT
 ..;If there is coverage type B store ien in D2B
 ..S COV=0,D2B=""
 ..F  S COV=$O(ABML(PRI,INS,"COV",COV)) Q:'COV  D
 ...Q:ABML(PRI,INS,"COV",COV)'="B"
 ...S D2B=COV
 ;Get the coverage type
 N QFLG
 S QFLG=0
 I 'D1,INS]"" S D1=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",INS,""))
 I 'D1 Q QFLG
 F  S D2=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,D1,11,D2)) Q:'D2  D
 .;If Medicare or RR outpat only look at coverage type B
 .I $G(MCOUT),D2'=D2B Q
 .;Check if an unbillable provider discipline in coverage file
 .I $D(^AUTTPIC(D2,15,PCLSS)) S QFLG=1
 .E  S QFLG=0
 Q QFLG
