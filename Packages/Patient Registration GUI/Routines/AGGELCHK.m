AGGELCHK ;VNGT/HS/ALA - Eligibility Checks ; 24 May 2010  6:44 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
EN(AGB,AGTP,AGQT,AGQI,AGEL) ; EP - AGG ELIGIBILITY VALID
 ; Input parameters
 ;   AGB  = AGGPTCLB = Classification/Beneficiary
 ;   AGTP = AGGPTTRI = Tribe of Membership
 ;   AGQT = AGGPTTRQ = Tribe Quantum
 ;   AGQI = AGGPTBLQ = Indian Blood Quantum
 ;   AGEL = AGGPTELG = Eligibility Status
 ;
 ;NEW UID,II
 ;S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;S DATA=$NA(^TMP("AGGELCHK",UID))
 ;K @DATA
 ;S II=0
 ;NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGELCHK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;S HDR="I00010RESULT^T00030MSG"
 ;S @DATA@(II)=HDR_$C(30)
 ;
BEN ;
 I AGB']"" D  G QTCHK
 . S MSG="Classification/Beneficiary Missing",RESULT=-1,CODE="AGGPTCLB"
 ;
 ;Skip check if classification/beneficiary is not Indian/Alaskan Native
 N CLBEN
 S CLBEN=$O(^AUTTBEN("B","INDIAN/ALASKA NATIVE",""))  ;Get Classification IEN
 I AGB]"",AGB'=CLBEN S RESULT=1 G END
 K CLBEN
 ;
TRIBE ;
 I $L(AGTP),$D(^AUTTTRI(AGTP,0)),($P(^(0),U,4)="N"!($P(^(0),U,4)="")) S AGT=$P(^AUTTTRI(AGTP,0),U,2)
 E  D  G ELIG
 . S AGT=0
 . I $G(AGTP)="" S MSG="Native American requires Valid Indian Tribe",RESULT=-1,CODE="AGGPTTRI" Q
 . S MSG="INVALID old TRIBE",RESULT=-1,CODE="AGGPTTRI"
 S AGT=+AGT
 S AGB=+AGB
 G:+AGB=1 IND                        ;BEN = Indian
 F I=6,18,32,33,8 I +AGB=I G NON
 ;all other BEN and tribe combinations are acceptable
 G ELIG
 ;
IND ;check BEN=1 TR'=000,970
 I AGT>0,AGT'=970 G ELIG
 E  D
 . S MSG="Native American requires Valid Indian Tribe",RESULT=-1,CODE="AGGPTTRI"
 G ELIG
 ;
NON ;BEN - NON INDIAN TR=000,970
 I AGB=8,((AGT=0)!(AGT=999)!(AGT=970)) G ELIG
 E  I AGB=8 D  G ELIG
 . S MSG="'OTHER' Ben/Class requires 'Non-Indian' or 'Unspecified' Tribe",RESULT=-1,CODE="AGGPTTRI"
 I ((AGT=0)!(AGT=970)) G ELIG
 E  D
 . S MSG="'Non-Indian' Ben/Class requires 'Non-Indian' Tribe",RESULT=-1,CODE="AGGPTTRI"
 G ELIG
 ;
ELIG ;Check Eligibility
 I AGEL']"" D  G QTCHK
 . S MSG="Eligibility Missing",RESULT=-1,CODE="AGGPTELG"
 I ((AGB=1)!(AGB=3)!(AGB=4)),AGEL="I" D  G QTCHK
 . S MSG="Ben/Class selected should be Eligible for care",RESULT=-1,CODE="AGGPTCLB"
 ;
TRBQT ; Check Tribe and Indian Quantum consistency
 S AGTF=1
 I ((AGT=0)!(AGT=970)) S AGTF=0
 I AGT=999 F AGZ=6,8,18,32,33 S:AGB=AGZ AGTF=0
 I AGTF,AGEL="I" S MSG="WARNING ... Valid Tribe should be Eligible for Care",RESULT=-1,CODE="AGGPTELG" G QTCHK
 S AGQF=0
 I "UNKNOWN,NONE"'[AGQI S AGQF=1
 I AGTF=AGQF
 E  D
 . S MSG="Tribe Selected and Indian Quantum are Inconsistent",RESULT=-1,CODE="AGGPTTRI"
 ;
QTCHK ;
 ;Check Quantums consistency - Now asked in quantum field validation
 ;I '$G(AGSITE),'$D(^AGFAC(DUZ(2))) Q
 ;I $G(AGSITE),'$D(^AGFAC(AGSITE)) Q
 ;I $P(^AGFAC($S($D(AGSITE):AGSITE,1:DUZ(2)),0),"^",2)'="Y" G END
 ;G:AGQT=AGQI END
 ;I "UNKNOWN,NONE"'[AGQI,"UNKNOWN,NONE"'[AGQT
 ;E  D
 ;. S MSG="Quantums are Inconsistent",RESULT=-1,CODE="AGGPTBLQ"
END ;
 I RESULT'=-1 S RESULT=1,MSG="",CODE=""
 K AGQF,AGT,AGTF,AGZ,CLBEN
 ;S II=II+1,@DATA@(II)=RESULT_U_MSG_$C(30)
 ;S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
