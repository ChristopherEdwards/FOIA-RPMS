BQITDVAL ;APTIV/HC/ALA-Dx Tag Validation Program ; 09 Apr 2008  6:58 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
VAL(DATA,DFN,TAG,STAT) ;EP -- BQI DX TAG VALIDATION
 ; Input
 ;    DFN  - Patient internal entry number
 ;    TAG  - the diagnosis tag internal entry number for which is being updated
 ;    STAT - status of the tag management
 ;
 ; Output
 ;    RESULT  - 1 is okay to proceed, -1 cannot proceed 
 ;    HANDLER - 'W' is a warning message to be displayed, 'O' is an override
 ;    MSG     - Message to display for either a 'W' or an 'O'
 ; 
 NEW UID,II
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITDVAL",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITDVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TAG=$G(TAG,"") I TAG="" S BMXSEC="No Diagnosis Category identified" Q
 S STAT=$G(STAT,"") I STAT="" S BMXSEC="No status identified" Q
 S DFN=$G(DFN,"") I DFN="" S BMXSEC="No patient identified" Q
 ;
 NEW THCFL,RESULT,SEX,AGE,HIEN,HORD,ACT
 S @DATA@(II)="I00010RESULT^T00001HANDLER^T01024MSG"_$C(30)
 S THCFL=+$P(^BQI(90506.2,TAG,0),U,10)
 ; If there is no hierachy, then no further checks need to be performed
 ; Status can change to any other status
 I 'THCFL S RESULT="1^^" G DONE
 ; If it's 'CVD At Risk', need to check whether DOB falls within the criteria or not
 I $$GET1^DIQ(90506.2,TAG_",",.01,"E")="CVD At Risk" D  I $P(RESULT,U,1,2)="-1^W" G DONE
 . S SEX=$$GET1^DIQ(2,DFN,.02,"I")
 . S AGE=$$AGE^BQIAGE(DFN)
 . I SEX="M"&(AGE'<45)&(STAT="A") S RESULT="1^^" Q
 . I SEX="F"&(AGE'<55)&(STAT="A") S RESULT="1^^" Q
 . ;I SEX="M"&(AGE'<45)&((STAT="N")!(STAT="A")) S RESULT="1^^" Q
 . ;I SEX="F"&(AGE'<55)&((STAT="N")!(STAT="A")) S RESULT="1^^" Q
 . I SEX="M"&(AGE<45)&((STAT="N")!(STAT="A")) S RESULT="-1^O^Patient is under the CVD At Risk target DOB" Q
 . I SEX="F"&(AGE<55)&((STAT="N")!(STAT="A")) S RESULT="-1^O^Patient is under the CVD At Risk target DOB" Q
 . I SEX="M"&(AGE<45)&(STAT="P") S RESULT="-1^W^Patient is under the CVD At Risk target DOB. Only valid statuses are 'Accepted' and 'Not Accepted'" Q
 . I SEX="F"&(AGE<55)&(STAT="P") S RESULT="-1^W^Patient is under the CVD At Risk target DOB. Only valid statuses are 'Accepted' and 'Not Accepted'" Q
 . I SEX="M"&(AGE'<45)&(STAT'="A") S RESULT="-1^W^Patient meets CVD At Risk target DOB. Only valid status is 'Accepted'."
 . I SEX="F"&(AGE'<55)&(STAT'="A") S RESULT="-1^W^Patient meets CVD At Risk target DOB. Only valid status is 'Accepted'."
 ; Check status of hierarchy
 S HIEN=$O(^BQI(90506.2,TAG,4,"B",TAG,""))
 S HORD=$P(^BQI(90506.2,TAG,4,HIEN,0),U,2),ORD=HORD,ACT=0
 ; if nothing after this order, then check for higher
 I $O(^BQI(90506.2,TAG,4,"AC",ORD),-1)'="" D HG
 ;I $O(^BQI(90506.2,TAG,4,"AC",ORD))="" D HG
 I ACT G DONE
 S ORD=HORD
 I $O(^BQI(90506.2,TAG,4,"AC",ORD))'="" D LW
 ;
DONE ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
LW ; Check for an active lower hierarchy
 NEW ACT,HCIEN,HCTAG,RIEN,CSTAT ;,ORD
 S ACT=0
 F  S ORD=$O(^BQI(90506.2,TAG,4,"AC",ORD)) Q:ORD=""  D  Q:ACT
 . S HCIEN=$O(^BQI(90506.2,TAG,4,"AC",ORD,""))
 . S HCTAG=$P(^BQI(90506.2,TAG,4,HCIEN,0),U,1)
 . S RIEN=$O(^BQIREG("C",DFN,HCTAG,"")) I RIEN="" Q
 . S CSTAT=$P(^BQIREG(RIEN,0),U,3)
 . I CSTAT="A"!(CSTAT="P") S ACT=1
 I 'ACT,$P($G(RESULT),U)'<0 S RESULT="1^^"
 I ACT S RESULT="-1^O^Patient already has "_$$GET1^DIQ(90509,RIEN_",",.01,"E")_" with a status of "_$$GET1^DIQ(90509,RIEN_",",.03,"E")_"."
 Q
 ;
HG ; Check for an active higher hierarchy
 NEW ACT,HCIEN,HCTAG,RIEN,CSTAT ;,ORD
 S ACT=0
 F  S ORD=$O(^BQI(90506.2,TAG,4,"AC",ORD),-1) Q:ORD=""  D  Q:ACT
 . S HCIEN=$O(^BQI(90506.2,TAG,4,"AC",ORD,""))
 . S HCTAG=$P(^BQI(90506.2,TAG,4,HCIEN,0),U,1)
 . S RIEN=$O(^BQIREG("C",DFN,HCTAG,"")) I RIEN="" Q
 . S CSTAT=$P(^BQIREG(RIEN,0),U,3)
 . S ACT=$$ACST^BQITDUTL(CSTAT)
 I 'ACT,$P($G(RESULT),U)'<0 S RESULT="1^^"
 I ACT S RESULT="-1^W^Patient already has "_$$GET1^DIQ(90509,RIEN_",",.01,"E")_" with a status of "_$$GET1^DIQ(90509,RIEN_",",.03,"E")_".  You must first change its status to 'NOT ACCEPTED'."
 Q
