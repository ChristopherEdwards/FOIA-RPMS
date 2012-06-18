ACDPCCLC ;IHS/ADC/EDE/KML - ENVIRONMENT CHECK FOR PCC LINK;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 NEW ACDPCCLC,Y,Z
 S ACDPCCLC=0
 D ICDCHK ;                                check for required icd codes
 D LOCCHK ;                                check CDMIS LOCATION file
 D EOJ
 Q
 ;
ICDCHK ; CHECK FOR V65.4 & V70.8 ICD CODE FOR PCC LINK
 S Y=$O(^ICD9("AB","V65.4",0))
 I 'Y S ACDPCCLC=1 D ERROR^ACDPCCL("Cannot find ICD9 code V65.4 - without it you cannot run the PCC link.")
 S Y=$O(^ICD9("AB","V70.8",0))
 I 'Y S ACDPCCLC=1 D ERROR^ACDPCCL("Cannot find ICD9 code V70.8 - without it you cannot run the PCC link.")
 Q
 ;
LOCCHK ; CHECK CDMIS LOCATION FILE FOR PCC LOCATION ENTRIES
 S (Y,Z)=0
 F  S Y=$O(^ACDLOT(Y)) Q:'Y  D:'$P($G(^(Y,0)),U,4)
 . D ERROR^ACDPCCL("No PCC LOCATION for CDMIS LOCATION: "_$P(^ACDLOT(Y,0),U))
 . S Z=1
 . Q
 I Z S ACDPCCLC=1 D ERROR^ACDPCCL("Without PCC LOCATION values you cannot run the PCC link.")
 Q
 ;
EOJ ;
 I ACDPCCLC K X H 3
 Q
