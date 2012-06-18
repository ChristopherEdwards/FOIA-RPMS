ADGEVNT ; IHS/ADC/PDW/ENM - IHS/ADT EVENT DRIVER ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 N DGPMCA S DGPMCA=$S(+$P(DGPMA,U,14):$P(DGPMA,U,14),1:+$P(DGPMP,U,14))
 D @DGPMT Q
 ;
1 ; -- admissions
 I DGPMA]"" D NBCHK ;check if nb admit date matches dob
 I DGPMP="" D APCDALV^ADGCALLS,BULL,AS Q                     ;new
 I DGPMA="" D APCDVDLT^ADGCALLS Q                            ;deleted
 I +DGPMP'=+DGPMA D APCDCVDT^ADGCALLS                        ;date/time 
 I +$P(DGPMA,U,17) D A3                                      ;discharged
 D BULL,AS Q
 ;
3 ; -- discharges
 I +$G(^DPT(DFN,.35)) N X,Y S X="NOW" D ^%DT S ^AGPATCH(Y,DUZ(2),DFN)=""
 I DGPMP="" D APCDALVR^ADGCALLS,BULL,IC Q                    ;new
 I DGPMA="" S DIK="^AUPNVINP(",DA=$$VH D:DA ^DIK K DIK,DA Q  ;deleted
 I +DGPMA'=+DGPMP S APCDALVR("APCDDSCH")=+DGPMA
 I $P(DGPMA,U,4)'=$P(DGPMP,U,4) S APCDALVR("APCDTDT")=$P(DGPMA,U,4)
 I $P(DGPMA,U,5)'=$P(DGPMP,U,5) D
 . S:$P($$TF,"`",2) APCDALVR("APCDTTT")=$$TF
 I $D(APCDALVR) D APCDALVR^ADGCALLS
 D BULL
 Q
 ;
2 ; -- transfers
 D BULL Q
 ;
6 ; -- specialty
 Q:'$P(^DGPM(DGPMCA,0),U,17)
 I DGPMA]"" D NBCHK ;check if nb admit date matches dob
 I $P(^AUPNVINP($$VH,0),U,5)'=$$DSRV^ADGCALLS D
 . S APCDALVR("APCDTDCS")="`"_$$DSRV^ADGCALLS D APCDALVR^ADGCALLS
 Q
 ;
4 ; -- check-in lodger
5 ; -- check-out lodger
 Q
 ;
A3 ; -- admission movement with discharge pointer
 I '$$VH N DGPMA,DGPMP S DGPMA=$$N3,DGPMP="" D APCDALVR^ADGCALLS Q
 S:$P(DGPMA,U,4)'=$P(DGPMP,U,4) APCDALVR("APCDTAT")="`"_$P(DGPMA,U,4)
 I $$A6 D
 . S APCDALVR("APCDTADS")="`"_$P(^TMP("DGPM",$J,6,$$TS,"A"),U,9)
 . S APCDALVR("APCDTDCS")="`"_$$DSRV^ADGCALLS
 Q:'$D(APCDALVR)
 N DGPMA,DGPMP S DGPMA=$$N3,DGPMP=DGPMA D APCDALVR^ADGCALLS
 Q
 ;
IC ; -- incomplete chart
 Q:'$P($G(^DG(43,1,9999999.02)),U,4)  ;ic on dsch okay?
 I '$D(^ADGIC(DFN,0))#2 D
 . L +^ADGIC(0):3 I '$T Q
 . S X="`"_DFN,DIC="^ADGIC(",DLAYGO=9009013,DIC(0)="L"
 . D ^DIC L -^ADGIC(0)
 I '$D(^ADGIC(DFN,0))#2 Q
 S:'$D(^ADGIC(DFN,"D",0)) ^ADGIC(DFN,"D",0)="^9009013.01D^^"
 S X=+DGPMA,DA(1)=DFN,DA=$P(^ADGIC(DFN,"D",0),U,3)+1
 S DIC="^ADGIC("_DFN_",""D"",",DLAYGO=9009013,DIC(0)="L"
 L +^ADGIC(DFN,"D"):3 I '$T Q
 D ^DIC
 N C,N,T,I S C=$P(DGPMA,U,14),N=$G(^DGPM(+C,0)),I=9999999.9999999-DGPMA
 S T=+$O(^(+$O(^DGPM("ATS",DFN,+C,I)),0))
 S DR="1///^S X=+N;2///^S X=$P(N,U,6);3///^S X=""`""_T",DIE=DIC
 D ^DIE L -^ADGIC(DFN,"D") K DIC,DIE,DR Q
 ;
AS ; -- a sheet and locator
 D EN^ADGCRB0(DFN,DGPMDA)
 D EN^ADGLOC0(DFN,DGPMDA) Q
 ; 
VI() ; -- visit ien
 Q +$O(^AUPNVSIT("AA",DFN,+$$ID,0))
 ;
VH() ; -- v hospitalization ien
 Q +$O(^AUPNVINP("AD",+$$VI,0))
 ;
ID() ; -- inverse date
 Q (9999999-$P(+^DGPM(DGPMCA,0),"."))_"."_$P(+^DGPM(DGPMCA,0),".",2)
 ;
N3() ; -- discharge node
 Q $G(^DGPM(+$P(^DGPM(+DGPMCA,0),U,17),0))
 ;
TF() ; -- transfer facility
 N X S X=$P(DGPMA,U,5) Q $S(X["DIC(4":"VA/IHS.`",1:"VENDOR.`")_+X
 ;
TS() ; -- specialty ien
 Q $O(^DGPM("APHY",+DGPMDA,0))
 ;
A6() ; -- admitting service changed (1=yes,0=no)
 Q $S($P($G(^TMP("DGPM",$J,6,+$$TS,"A")),U,9)'=$P($G(^("P")),U,9):1,1:0)
 ;
NBCHK ; -- checks newborn admit date against date of birth 
 NEW X,DOB
 S X=$O(^DIC(45.7,"CIHS","07",0)) I X="" Q  ;no nb code
 S Y=$S(DGPMT=1:$$TS,1:DGPMDA) Q:Y=""
 Q:$P($G(^DGPM(+Y,0)),U,9)'=X  ;not newborn
 S DOB=$P($G(^DPT(+$P(DGPMA,U,3),0)),U,3) Q:DOB=""
 I DOB'=(+DGPMA\1) D
 . W !!,*7,"NEWBORN ADMIT DATE DOES NOT MATCH DATE OF BIRTH"
 . W !,"PLEASE FIX INCORRECT DATE!"
 Q
 ;
BULL ; -- check if bulletins turned on and call subrtns to send them
 I DGPMT=1 D  Q
 . ;  -- check if transfer in
 . I $$ON(9999999.12) D
 .. NEW ADTYP S ADTYP=$$VAL^XBDIQ1(405.1,$P(DGPMA,U,4),9999999.1)
 .. I (ADTYP=2)!(ADTYP=3) D TI^ADGBULL1
 . ;
 . ;  -- check if readmission
 . I $$ON(9999999.15) D  K DGRE
 .. NEW DGDT S DGDT=+DGPMA D ^ADGREADM Q:'$D(DGRE)
 .. I DGRE["A" D READM^ADGBULL1
 .. I DGRE["D" D ADMDS^ADGBULL1
 ;
 I DGPMT=2 D  Q
 . ;  -- check if icu transfer
 . I $$ON(9999999.11) D
 .. I $$VAL^XBDIQ1(42,+$P(DGPMA,U,6),9999999.01)="YES" D ICU^ADGBULL1
 ;
 I DGPMT=3 D  Q
 . NEW X S X=$$VAL^XBDIQ1(405.1,+$P(DGPMA,U,4),9999999.1) Q:X=""
 . I (X<2)!(X>7) Q
 . I X=2,$$ON(9999999.13) D TO^ADGBULL1 Q
 . I X=3,$$ON(9999999.17) D AMA^ADGBULL1 Q
 . I $$ON(9999999.14) D DEATH^ADGBULL1
 Q
 ;
ON(N) ; -- returns 1 if bulletin turned on
 Q $$VALI^XBDIQ1(43,1,N)
