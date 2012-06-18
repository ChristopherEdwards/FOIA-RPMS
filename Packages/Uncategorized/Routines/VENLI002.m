VENLI002 ; ; 28-NOV-2006
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQ(9000010.16)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9000010.16,.041,9.01)
 ;;=80^3;9000010.16^.04
 ;;^DD(9000010.16,.041,9.1)
 ;;=#.04:#3
 ;;^DD(9000010.16,.041,9.2)
 ;;=S Y(9000010.16,.041,80)=$S($D(D0):D0,1:""),Y(9000010.16,.041,1)=$S($D(^AUPNVPED(D0,0)):^(0),1:""),D0=$P(Y(9000010.16,.041,1),U,4) S:'$D(^ICD9(+D0,0)) D0=-1
 ;;^DD(9000010.16,.05,0)
 ;;=PROVIDER^*P200'^VA(200,^0;5^S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y)),$S($D(BVC):1,$P($G(^VA(200,+Y,""PS"")),U,4)="""":1,1:0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.16,.05,12)
 ;;=Must be a provider.
 ;;^DD(9000010.16,.05,12.1)
 ;;=S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y)),$S($D(BVC):1,$P($G(^VA(200,+Y,""PS"")),U,4)="""":1,1:0)"
 ;;^DD(9000010.16,.05,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.05,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTPRO")
 ;;^DD(9000010.16,.05,"DT")
 ;;=3000628
 ;;^DD(9000010.16,.06,0)
 ;;=LEVEL OF UNDERSTANDING^S^1:POOR;2:FAIR;3:GOOD;4:GROUP-NO ASSESSMENT;5:REFUSED;^0;6^Q
 ;;^DD(9000010.16,.06,3)
 ;;=Enter the number which best rates the patient's level of understanding.
 ;;^DD(9000010.16,.06,21,0)
 ;;=^^2^2^2950901^
 ;;^DD(9000010.16,.06,21,1,0)
 ;;=This is the provider's assessment of how well the patient understood the
 ;;^DD(9000010.16,.06,21,2,0)
 ;;=education received.
 ;;^DD(9000010.16,.06,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.06,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTLOU")
 ;;^DD(9000010.16,.06,"DT")
 ;;=2930907
 ;;^DD(9000010.16,.07,0)
 ;;=INDIVIDUAL/GROUP^S^G:GROUP SETTING;I:INDIVIDUAL;^0;7^Q
 ;;^DD(9000010.16,.07,3)
 ;;=WAS THIS PATIENT EDUCATION PROVIDED IN A GROUP SETTING OR PROVIDED TO AN INDIVIDUAL
 ;;^DD(9000010.16,.07,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.07,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTIG")
 ;;^DD(9000010.16,.07,"DT")
 ;;=2960710
 ;;^DD(9000010.16,.08,0)
 ;;=LENGTH OF EDUC (MINUTES)^NJ3,0^^0;8^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(9000010.16,.08,3)
 ;;=ENTER THE NUMBER OF MINUTES THAT THIS PATIENT EDUCATION WAS PROVIDED
 ;;^DD(9000010.16,.08,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.08,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTMIN")
 ;;^DD(9000010.16,.08,"DT")
 ;;=2960924
 ;;^DD(9000010.16,.09,0)
 ;;=CPT CODE^*P81'^ICPT(^0;9^S DIC("S")="D CPT^AUPNSICD" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.16,.09,12)
 ;;=Must be an active CPT code.
 ;;^DD(9000010.16,.09,12.1)
 ;;=S DIC("S")="D CPT^AUPNSICD"
 ;;^DD(9000010.16,.09,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.09,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTCPT")
 ;;^DD(9000010.16,.09,"DT")
 ;;=3030128
 ;;^DD(9000010.16,.11,0)
 ;;=COMMENT^F^^0;11^K:$L(X)>100!($L(X)<2) X
 ;;^DD(9000010.16,.11,3)
 ;;=Answer must be 2-100 characters in length.
 ;;^DD(9000010.16,.11,21,0)
 ;;=^^2^2^2961105^
 ;;^DD(9000010.16,.11,21,1,0)
 ;;=This field is to capture narrative text about the patient education
 ;;^DD(9000010.16,.11,21,2,0)
 ;;=given.  Will display on the health summary if present.
 ;;^DD(9000010.16,.11,"DT")
 ;;=2981009
 ;;^DD(9000010.16,.12,0)
 ;;=TOPIC CATEGORY^P9001002.5'^APCDEDCV(^0;12^Q
 ;;^DD(9000010.16,.12,1,0)
 ;;=^.1^^0
 ;;^DD(9000010.16,.12,"DT")
 ;;=3000601
 ;;^DD(9000010.16,.13,0)
 ;;=BEHAVIOR CODE^S^GS:GOAL SET;GM:GOAL MET;GNM:GOAL NOT MET;^0;13^Q
 ;;^DD(9000010.16,.13,"DT")
 ;;=3030213
 ;;^DD(9000010.16,.14,0)
 ;;=OBJECTIVES MET^F^^0;14^K:$L(X)>20!($L(X)<1) X
 ;;^DD(9000010.16,.14,3)
 ;;=Answer must be 1-20 characters in length.
 ;;^DD(9000010.16,.14,"DT")
 ;;=3030411
 ;;^DD(9000010.16,1,0)
 ;;=SUB-TOPIC^9000010.161^^1;0
 ;;^DD(9000010.16,1101,0)
 ;;=PROVIDER'S NARRATIVE^F^^11;1^K:$L(X)>80!($L(X)<3) X
 ;;^DD(9000010.16,1101,3)
 ;;=Answer must be 3-80 characters in length.
 ;;^DD(9000010.16,1101,"DT")
 ;;=3000621
 ;;^DD(9000010.16,1201,0)
 ;;=EVENT DATE AND TIME^D^^12;1^S %DT="EST" D ^%DT S X=Y K:Y<1 X
 ;;^DD(9000010.16,1201,3)
 ;;=Enter the date and time the patient education was given.
 ;;^DD(9000010.16,1201,21,0)
 ;;=^^9^9^2950901^^^
 ;;^DD(9000010.16,1201,21,1,0)
 ;;=This is the date and time the education was given by the provider.  This
 ;;^DD(9000010.16,1201,21,2,0)
 ;;=date and time may be different from the visit date and time.  For example, for
 ;;^DD(9000010.16,1201,21,3,0)
 ;;=clinic appointment visits, the visit date and time is the date and time of the
 ;;^DD(9000010.16,1201,21,4,0)
 ;;=appointment, not the time the provider performed the clinical event.
 ;;^DD(9000010.16,1201,21,5,0)
 ;;= 
 ;;^DD(9000010.16,1201,21,6,0)
 ;;=The date may be an imprecise date.
 ;;^DD(9000010.16,1201,21,7,0)
 ;;= 
 ;;^DD(9000010.16,1201,21,8,0)
 ;;=Date and time may be within 30 days before or after the visit date, with the
 ;;^DD(9000010.16,1201,21,9,0)
 ;;=restriction the date cannot be a future date.
 ;;^DD(9000010.16,1201,23,0)
 ;;=^^14^14^2960924^
 ;;^DD(9000010.16,1201,23,1,0)
 ;;=The PCE User Interface, which allows manual entry of data, will be the prmary
 ;;^DD(9000010.16,1201,23,2,0)
 ;;=source of the event date and time.  The event date prompt defaults to the visit
 ;;^DD(9000010.16,1201,23,3,0)
 ;;=date and the time is entered to reflect the actual time the exam was given. 
 ;;^DD(9000010.16,1201,23,4,0)
 ;;=The event date does not have to be the visit date, but it must be within 30
 ;;^DD(9000010.16,1201,23,5,0)
 ;;=days before or after the visit, and not be a future date.
 ;;^DD(9000010.16,1201,23,6,0)
 ;;= 
 ;;^DD(9000010.16,1201,23,7,0)
 ;;=If a user wnats to enter an historical measurement, the user should use the
 ;;^DD(9000010.16,1201,23,8,0)
 ;;=Historical Encounter entry action to document the historical measurement. 
 ;;^DD(9000010.16,1201,23,9,0)
 ;;=Historical entries will not be eligible for credit.
 ;;^DD(9000010.16,1201,23,10,0)
 ;;= 
 ;;^DD(9000010.16,1201,23,11,0)
 ;;=PCE data sources for automatic (scanning) data capture will be blank unless the
 ;;^DD(9000010.16,1201,23,12,0)
 ;;=event date and time are passed to PCE for filing. 
 ;;^DD(9000010.16,1201,23,13,0)
 ;;=
 ;;^DD(9000010.16,1201,23,14,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTCDT")
 ;;^DD(9000010.16,1201,"DT")
 ;;=2940401
 ;;^DD(9000010.16,1202,0)
 ;;=ORDERING PROVIDER^*P200'X^VA(200,^12;2^S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U)))",D="AK.PROVIDER" D IX^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.16,1202,3)
 ;;=Enter the provider who ordered the patient education.
 ;;^DD(9000010.16,1202,12)
 ;;=Must be a Provider.
 ;;^DD(9000010.16,1202,12.1)
 ;;=S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U)))"
 ;;^DD(9000010.16,1202,21,0)
 ;;=^^2^2^2950901^^
 ;;^DD(9000010.16,1202,21,1,0)
 ;;=This field can be used to document the provider who ordered the patient
 ;;^DD(9000010.16,1202,21,2,0)
 ;;=education.
 ;;^DD(9000010.16,1202,23,0)
 ;;=^^2^2^2960925^^
 ;;^DD(9000010.16,1202,23,1,0)
 ;;=The person entered here must hold the "AK.PROVIDER" security key.
 ;;^DD(9000010.16,1202,23,2,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTPRV")
 ;;^DD(9000010.16,1202,"DT")
 ;;=2940426
 ;;^DD(9000010.16,1203,0)
 ;;=CLINIC^P40.7'^DIC(40.7,^12;3^Q
 ;;^DD(9000010.16,1203,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,1203,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTCLN")
 ;;^DD(9000010.16,1203,"DT")
 ;;=2960710
 ;;^DD(9000010.16,1204,0)
 ;;=ENCOUNTER PROVIDER^P200'^VA(200,^12;4^Q
 ;;^DD(9000010.16,1204,3)
 ;;=Enter the provider who gave the patient education.
 ;;^DD(9000010.16,1204,21,0)
 ;;=^^1^1^2950901^^^
 ;;^DD(9000010.16,1204,21,1,0)
 ;;=This is the provider who gave the patient education.
 ;;^DD(9000010.16,1204,23,0)
 ;;=^^3^3^2960924^
 ;;^DD(9000010.16,1204,23,1,0)
 ;;=This person can be any person in the new person file.  The person does not have
 ;;^DD(9000010.16,1204,23,2,0)
 ;;=to hold the "AK.PROVIDER" security key.
