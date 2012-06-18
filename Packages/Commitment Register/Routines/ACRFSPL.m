ACRFSPL ;IHS/OIRM/DSD/AEF - DHR-SPLITOUT [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
EN(ACRCTR,ACRDTM,ACRPKG)     ;EP
 ;----- MAIN ENTRY POINT
 ;
 ;      ACRCTR  = TYPE OF TRANSACTIONS
 ;                ARM = ARMS
 ;                BCS = CHS
 ;                PCC = MANUALLY ENTERED
 ;      ACRDTNM = DATA TYPE NAME
 ;                DHRP
 ;                dhc
 ;      ACRPKG  = PACKAGE
 ;                AFSH = ARMS
 ;                ACHS = CHS
 ;
 N ACRD0,ACROUT
 ;
 ;Get which color batch to export
 D EN^ACRFSPL1(ACRCTR,ACRDTM,ACRPKG)
 Q:'$G(ACRD0)
 ;
 ;Do the export
 D EN^ACRFSPL2(ACRD0)
 ;
 ;Print report
 D EN^ACRFSPL3(ACRD0)
 Q
