VENMI002 ; ; 28-NOV-2006
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQ(9000010.46)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9000010.46,3.04,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(9000010.46,3.04,"DT")
 ;;=3051227
 ;;^DD(9000010.46,4,0)
 ;;=SPECIAL RISK SCREEN^9000010.464^^4;0
 ;;^DD(9000010.46,4,21,0)
 ;;=^^1^1^3051227^
 ;;^DD(9000010.46,4,21,1,0)
 ;;=NATL STDS FOR SPECIAL RISK SCREENING - ONLY USED WITH HIGH RISK CHILDREN
 ;;^DD(9000010.46,4,"DT")
 ;;=3051226
 ;;^DD(9000010.46,5,0)
 ;;=NUTRITION TOPICS^9000010.465^^5;0
 ;;^DD(9000010.46,6,0)
 ;;=AGE SPECIFIC PHYSICAL EXAM^9000010.466^^6;0
 ;;^DD(9000010.46,6,"DT")
 ;;=3051226
 ;;^DD(9000010.46,7,0)
 ;;=BEHAVIORAL HEALTH SCREEN^9000010.467^^7;0
 ;;^DD(9000010.46,8,0)
 ;;=GENERAL HEALTH SCREEN^9000010.468^^8;0
 ;;^DD(9000010.46,9.01,0)
 ;;=AUTISM SCREENING COMMENTS^F^^9;1^K:$L(X)>60!($L(X)<1) X
 ;;^DD(9000010.46,9.01,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(9000010.46,9.01,"DT")
 ;;=3060217
 ;;^DD(9000010.46,1201,0)
 ;;=EVENT DATE AND TIME^D^^12;1^S %DT="EST" D ^%DT S X=Y K:Y<1 X
 ;;^DD(9000010.46,1201,3)
 ;;=Enter the date and time the exam was given.
 ;;^DD(9000010.46,1201,21,0)
 ;;=^^9^9^2950901^^^^
 ;;^DD(9000010.46,1201,21,1,0)
 ;;=This is the date and time the exam was given by the provider.  This date
 ;;^DD(9000010.46,1201,21,2,0)
 ;;=and time may be different from the visit date and time.  For example, for
 ;;^DD(9000010.46,1201,21,3,0)
 ;;=clinic appointment visits, the visit date and time is the date and time of the
 ;;^DD(9000010.46,1201,21,4,0)
 ;;=appointment, not the time the provider performed the clinical event.
 ;;^DD(9000010.46,1201,21,5,0)
 ;;= 
 ;;^DD(9000010.46,1201,21,6,0)
 ;;=The date may be an imprecise date.
 ;;^DD(9000010.46,1201,21,7,0)
 ;;= 
 ;;^DD(9000010.46,1201,21,8,0)
 ;;=Date and time may be within 30 days before or after the visit date, with the
 ;;^DD(9000010.46,1201,21,9,0)
 ;;=restriction the date cannot be a future date.
 ;;^DD(9000010.46,1201,23,0)
 ;;=^^14^14^2960924^
 ;;^DD(9000010.46,1201,23,1,0)
 ;;=The PCE User Interface, which allows manual entry of data, will be the
 ;;^DD(9000010.46,1201,23,2,0)
 ;;=primary source of the event date and time.  The event date prompt defaults
 ;;^DD(9000010.46,1201,23,3,0)
 ;;=to the visit date, and the time is entered to reflect the actual time the
 ;;^DD(9000010.46,1201,23,4,0)
 ;;=measurement was done.  The event date does not have to be the visit date,
 ;;^DD(9000010.46,1201,23,5,0)
 ;;=but it must be within 30 days before or after the visit, and not be a
 ;;^DD(9000010.46,1201,23,6,0)
 ;;=future date.
 ;;^DD(9000010.46,1201,23,7,0)
 ;;= 
 ;;^DD(9000010.46,1201,23,8,0)
 ;;=If a user wants to enter a historical measurement, the user should use the
 ;;^DD(9000010.46,1201,23,9,0)
 ;;=Historical Encounter entry action to document the historical measurement.
 ;;^DD(9000010.46,1201,23,10,0)
 ;;=Historical entries will not be eligible for credit.
 ;;^DD(9000010.46,1201,23,11,0)
 ;;= 
 ;;^DD(9000010.46,1201,23,12,0)
 ;;=PCE Data Sources for automatic (scanning) data capture will be blank
 ;;^DD(9000010.46,1201,23,13,0)
 ;;=unless the event date and time are passed to PCE for filing. 
 ;;^DD(9000010.46,1201,23,14,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTCDT")
 ;;^DD(9000010.46,1201,"DT")
 ;;=2940608
 ;;^DD(9000010.46,1202,0)
 ;;=ORDERING PROVIDER^*P200'X^VA(200,^12;2^S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U)))",D="AK.PROVIDER" D IX^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.46,1202,3)
 ;;=Enter the provider who ordered this exam.
 ;;^DD(9000010.46,1202,12)
 ;;=Select ordering provider
 ;;^DD(9000010.46,1202,12.1)
 ;;=S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U)))"
 ;;^DD(9000010.46,1202,21,0)
 ;;=^^1^1^2950901^^
 ;;^DD(9000010.46,1202,21,1,0)
 ;;=This field can be used to document the provider who ordered the exam.
 ;;^DD(9000010.46,1202,23,0)
 ;;=^^2^2^2960924^
 ;;^DD(9000010.46,1202,23,1,0)
 ;;=The person entered here must hold the "AK.PROVIDER" security key.
 ;;^DD(9000010.46,1202,23,2,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTPRV")
 ;;^DD(9000010.46,1202,"DT")
 ;;=2940608
 ;;^DD(9000010.46,1203,0)
 ;;=CLINIC^P40.7'^DIC(40.7,^12;3^Q
 ;;^DD(9000010.46,1203,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,1203,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTCLN")
 ;;^DD(9000010.46,1203,"DT")
 ;;=2960709
 ;;^DD(9000010.46,1204,0)
 ;;=ENCOUNTER PROVIDER^P200'^VA(200,^12;4^Q
 ;;^DD(9000010.46,1204,3)
 ;;=Enter the provider who gave the exam.
 ;;^DD(9000010.46,1204,21,0)
 ;;=^^1^1^2950901^^^
 ;;^DD(9000010.46,1204,21,1,0)
 ;;=This is the provider who gave the exam.
 ;;^DD(9000010.46,1204,23,0)
 ;;=^^3^3^2960924^
 ;;^DD(9000010.46,1204,23,1,0)
 ;;=This person can be any person in the new person file.  The person does not have
 ;;^DD(9000010.46,1204,23,2,0)
 ;;=to hold the "AK.PROVIDER" security key.
 ;;^DD(9000010.46,1204,23,3,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTEPR")
 ;;^DD(9000010.46,1204,"DT")
 ;;=2941219
 ;;^DD(9000010.46,1208,0)
 ;;=PARENT^P9000010.46'^AUPNVWC(^12;8^Q
 ;;^DD(9000010.46,1208,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,1208,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTPNT")
 ;;^DD(9000010.46,1208,"DT")
 ;;=2960709
 ;;^DD(9000010.46,1209,0)
 ;;=EXTERNAL KEY^F^^12;9^K:$L(X)>20!($L(X)<1) X
 ;;^DD(9000010.46,1209,3)
 ;;=Answer must be 1-20 characters in length.
 ;;^DD(9000010.46,1209,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,1209,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTEXK")
 ;;^DD(9000010.46,1209,"DT")
 ;;=2960925
 ;;^DD(9000010.46,1210,0)
 ;;=OUTSIDE PROVIDER NAME^F^^12;10^K:$L(X)>30!($L(X)<1) X
 ;;^DD(9000010.46,1210,3)
 ;;=Answer must be 1-30 characters in length.
 ;;^DD(9000010.46,1210,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,1210,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTOPR")
 ;;^DD(9000010.46,1210,"DT")
 ;;=2960925
 ;;^DD(9000010.46,1213,0)
 ;;=ANCILLARY POV^P80'^ICD9(^12;13^Q
 ;;^DD(9000010.46,1213,"DT")
 ;;=3030919
 ;;^DD(9000010.46,80101,0)
 ;;=EDITED FLAG^S^1:EDITED;^801;1^Q
 ;;^DD(9000010.46,80101,3)
 ;;=Answer is automatically entered by PCE filing logic.
 ;;^DD(9000010.46,80101,21,0)
 ;;=^^2^2^2950901^
 ;;^DD(9000010.46,80101,21,1,0)
 ;;=This field is automatically set to 1 if PCE detects that any original
 ;;^DD(9000010.46,80101,21,2,0)
 ;;=exam data is being edited.
 ;;^DD(9000010.46,80101,23,0)
 ;;=^^2^2^2950901^
 ;;^DD(9000010.46,80101,23,1,0)
 ;;=PCE filing logic automatically compares the before and after pictures of the
 ;;^DD(9000010.46,80101,23,2,0)
 ;;=record to determine if the edited flag should be set to "1".
 ;;^DD(9000010.46,80101,"DT")
 ;;=2940608
 ;;^DD(9000010.46,80102,0)
 ;;=AUDIT TRAIL^F^^801;2^K:$L(X)>85!($L(X)<2) X
 ;;^DD(9000010.46,80102,3)
 ;;=Answer is automatically entered by the PCE filing logic.
 ;;^DD(9000010.46,80102,21,0)
 ;;=^^3^3^2950901^
 ;;^DD(9000010.46,80102,21,1,0)
 ;;=This field is populated automatically by the PCE filing logic.  The format of
 ;;^DD(9000010.46,80102,21,2,0)
 ;;=the field is as follows:  Pointer to PCE data source file_"-"_A for Add or E
 ;;^DD(9000010.46,80102,21,3,0)
 ;;=for Edit_" "_DUZ of the person who entered the data_";"...
 ;;^DD(9000010.46,80102,23,0)
 ;;=^^15^15^2950901^
 ;;^DD(9000010.46,80102,23,1,0)
 ;;=The PCE filing logic requires a pointer to the PCE Data Source file.
 ;;^DD(9000010.46,80102,23,2,0)
 ;;=If this is not passed, then PCE filing logic will not process the data.
 ;;^DD(9000010.46,80102,23,3,0)
 ;;=  
 ;;^DD(9000010.46,80102,23,4,0)
 ;;=If the record is a new record, then an "A" is used to specify the source
 ;;^DD(9000010.46,80102,23,5,0)
 ;;=that added the data.  If the record existed previously, PCE filing logic
 ;;^DD(9000010.46,80102,23,6,0)
 ;;=compares the old and new records of information.  An "E" will be
