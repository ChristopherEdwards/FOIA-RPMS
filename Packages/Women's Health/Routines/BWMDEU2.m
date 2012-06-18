BWMDEU2 ;IHS/ANMC/MWR - MDE FUNCTIONS. BWMDEU CON'T;29-Oct-2003 21:36;PLS
 ;;2.0;WOMEN'S HEALTH;**8,9**;MAY 16, 1996
 ;
MRESLT() ;EP
 ;---> IF THIS PCD IS NOT MAM:
 ;--->    RETURN 9 IF BR TX NEED=MAM AND DUE DATE IS BEFORE TODAY.
 ;--->    RETURN 8 IF BR TX NEED'=MAM, OR IF BR TX NEED=MAM BUT DUE DATE
 ;--->       IS AFTER TODAY.
 ;--->    BOTH CASES SET BWMABN=0 (ABNORMAL MAM=0).
 ;---> (BWMABN=0 WILL BLANK FILL ALL DATA IN ABNORMAL MAM SECTION.)
 ;
 I 'BWMAM S BWMABN=0 Q " 8"
 ;---> THIS PROCEDURE MUST BE A MAM.
 ;---> IF NO RESULT, RETURN 10 (RESULT PENDING) AND SET BWMABN=0.
 I 'BWRESN S BWMABN=0 Q 10
 ;---> RETURN THE CDC CODE FOR THE RESULT (PC 25).  IF RESULT IS 4,5,
 ;---> OR 6, SET BWMABN=1 TO EXTRACT DATA FOR ABNORMAL MAM SECTION.
 N X S X=$P(^BWDIAG(BWRESN,0),U,25)
 S BWMABN=$S(654[X:1,1:0)
 Q $J(X,2)
 ;
 ;
MWKUP() ;EP
 ;---> RETURN THE DX WORKUP: 1=PLANNED, 2=NOT PLANNED, 3=UNDETERMINED.
 N X
 S X=$P(BW2,U,20)
 Q:X X
 Q 2
 ;
 ;
MPAY() ;EP
 ;---> MAM PAID FOR BY COOP AGREEMENT FUNDS, 3=DON'T KNOW.
 N X
 S X=$$MRESLT
 Q:+X>7 ""
 Q 1
 ;
 ;
BDXPAID() ;EP
 ;---> BREAST DX PAID FOR BY COOP AGREEMENT FUNDS, 3=DON'T KNOW.
 N X S X=$$MRESLT
 Q:+X>7 ""
 Q:BWMAM 1
 Q ""
 ;
 ;
CBEPAID() ;EP
 ;---> CBE PAID FOR BY COOP AGREEMENT FUNDS, 3=DON'T KNOW.
 N X
 S X=$$MRESLT
 Q:+X>7 ""
 Q:BWMAM 1
 Q ""
 ;
 ;
CDXPAID() ;EP
 ;---> CBE PAID FOR BY COOP AGREEMENT FUNDS, 3=DON'T KNOW.
 I '$$CONOBX(),'$$COLPBX() Q ""
 Q 1
 ;
 ;
CONOBX() ; EP
 ; Colposcopy Impression (No Biopsy)
 ; BWC0 holds the zero node of the Colposcopy procedure
 ; Procedure must be a Colposcopy Impression
 ; Return: 1 = Yes, 2 = No
 Q $S(+$P($G(BWC0),U,4)=37:1,1:2)
 ;
 ;
COLPBX() ;EP
 ; Colposcopy w/Biopsy
 ; BWC0 holds the zero node of the Colposcopy procedure
 ; Procedure must be a Colposcopy Biopsy
 ; Return: 1 = Yes, 2 = No
 Q $S(+$P($G(BWC0),U,4)=2:1,1:2)
 ;
 ;
PFNDX() ;EP
 ;---> FINAL DIAGNOSIS FOR ASSOCIATED COLP.
 ;---> FIRST TRY TO GET IT FROM #.33 FIELD; IF NOT, TRY ASSOC'D COLP.
 N X S X=$P(BW0,U,33)
 S:'X X=$P(BWC0,U,5)
 Q:'X ""
 Q:'$D(^BWDIAG(X,0)) ""
 Q $P(^BWDIAG(X,0),U,26)
 ;
 ;
PSTGDX(BWFNDX,BWX) ; EP - Stage at final diagnosis.  GET FROM ASSOC'D COLP.
 ; Call with BWFNDX = final diagnosis
 ;              BWX = zeroth node of assoc'd colp.
 ;
 ; Returns BWSTAGE = CDC stage at diagnosis
 ;
 N BWSTAGE
 S BWSTAGE=""
 I BWFNDX=6 S BWSTAGE=$P(BWX,U,31)
 Q BWSTAGE
 ;
 ;
PFNDXO() ; EP - FREE TEXT DIAGNOSIS OF "OTHER" FOR ASSOC'D COLP.
 Q:$$PFNDX()'=7 ""
 N X
 S X=$P(BW0,U,33)
 S:'X X=$P(BWC0,U,5)
 Q:'X ""
 Q:'$D(^BWDIAG(X,0)) ""
 Q $E($P(^BWDIAG(X,0),U),1,20)
 ;
 ;
CDCDT(BWDT) ; EP: Convert FileMan date to CDC date format
 ; Call with BWDT = FileMan date
 ;
 ; Returns    BWY = date in CDC MMDDYYYY format
 ;
 I BWDT S BWY=$TR($$FMTE^XLFDT(BWDT,"5DZ"),"/")
 E  S BWY=$$REPEAT^XLFSTR(" ",8)
 Q BWY
