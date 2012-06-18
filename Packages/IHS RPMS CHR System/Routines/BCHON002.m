BCHON002 ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",320,99)
 ;;=56873,29035
 ;;^UTILITY(U,$J,"PRO",321,0)
 ;;=BCH NEXT SCREEN^Next Screen^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",321,1,0)
 ;;=^^2^2^2920519^^^
 ;;^UTILITY(U,$J,"PRO",321,1,1,0)
 ;;=This action will allow the user to view the next screen
 ;;^UTILITY(U,$J,"PRO",321,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",321,2,0)
 ;;=^101.02A^1^1
 ;;^UTILITY(U,$J,"PRO",321,2,1,0)
 ;;=NX
 ;;^UTILITY(U,$J,"PRO",321,2,"B","NX",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",321,20)
 ;;=D NEXT^VALM4
 ;;^UTILITY(U,$J,"PRO",321,99)
 ;;=56873,29035
 ;;^UTILITY(U,$J,"PRO",322,0)
 ;;=BCH PREVIOUS SCREEN^Previous Screen^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",322,1,0)
 ;;=^^2^2^2920113^^
 ;;^UTILITY(U,$J,"PRO",322,1,1,0)
 ;;=This action will allow the user to view the previous screen
 ;;^UTILITY(U,$J,"PRO",322,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",322,2,0)
 ;;=^101.02A^3^3
 ;;^UTILITY(U,$J,"PRO",322,2,1,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",322,2,2,0)
 ;;=BK
 ;;^UTILITY(U,$J,"PRO",322,2,3,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",322,2,"B","BK",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",322,2,"B","PR",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",322,2,"B","PR",3)
 ;;=
 ;;^UTILITY(U,$J,"PRO",322,20)
 ;;=D PREV^VALM4
 ;;^UTILITY(U,$J,"PRO",322,99)
 ;;=56873,29035
 ;;^UTILITY(U,$J,"PRO",323,0)
 ;;=BCH SEARCH LIST^Search List^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",323,1,0)
 ;;=^^1^1^2920303^^
 ;;^UTILITY(U,$J,"PRO",323,1,1,0)
 ;;=Finds text in list of entries.
 ;;^UTILITY(U,$J,"PRO",323,20)
 ;;=D FIND^VALM40
 ;;^UTILITY(U,$J,"PRO",323,99)
 ;;=56873,29035
 ;;^UTILITY(U,$J,"PRO",324,0)
 ;;=BCH PRINT LIST^Print List^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",324,1,0)
 ;;=^^2^2^2920113^
 ;;^UTILITY(U,$J,"PRO",324,1,1,0)
 ;;=This action allws the user to print the entire list of
 ;;^UTILITY(U,$J,"PRO",324,1,2,0)
 ;;=entries currently being displayed.
 ;;^UTILITY(U,$J,"PRO",324,20)
 ;;=D PRTL^VALM1
 ;;^UTILITY(U,$J,"PRO",324,99)
 ;;=56873,29035
 ;;^UTILITY(U,$J,"PRO",342,0)
 ;;=BCH HL7 ORU^CHR Receive HL7 ORU Message^^S^^^^^^^^IHS RPMS CHR SYSTEM
 ;;^UTILITY(U,$J,"PRO",342,4)
 ;;=^^^BCHHL7ORU
 ;;^UTILITY(U,$J,"PRO",342,99)
 ;;=56873,29035
 ;;^UTILITY(U,$J,"PRO",342,770)
 ;;=^1^3^46^i^P^1^^^2^
 ;;^UTILITY(U,$J,"PRO",342,771)
 ;;=D ^BHLBCH
 ;;^UTILITY(U,$J,"PRO",424,0)
 ;;=BCH HL7 SERVER^CHR Penbased HL7 ORU Message^^E^^^^^^^^IHS RPMS CHR SYSTEM
 ;;^UTILITY(U,$J,"PRO",424,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",424,10,1,0)
 ;;=342^^1
 ;;^UTILITY(U,$J,"PRO",424,10,1,"^")
 ;;=BCH HL7 ORU
 ;;^UTILITY(U,$J,"PRO",424,99)
 ;;=56873,29037
 ;;^UTILITY(U,$J,"PRO",424,770)
 ;;=2^^3^46^i^P^^3^3^2
 ;;^UTILITY(U,$J,"PRO",425,0)
 ;;=BCH ANCILLARY VISIT EVENT^CHR/APCD VISIT EVENT^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",425,20)
 ;;=D ^BCHALD
 ;;^UTILITY(U,$J,"PRO",425,99)
 ;;=56873,29037
 ;;^UTILITY(U,$J,"PRO",668,0)
 ;;=BCH PCC VISIT ADDED^CHR - After PCC visit added^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",668,20)
 ;;=D UPDPCC^BCHUTIL
 ;;^UTILITY(U,$J,"PRO",668,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",669,0)
 ;;=BCH COMPLETE VISIT ADDED^PCC VISIT ADDED^^X^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",669,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",669,10,1,0)
 ;;=668^
 ;;^UTILITY(U,$J,"PRO",669,10,1,"^")
 ;;=BCH PCC VISIT ADDED
 ;;^UTILITY(U,$J,"PRO",669,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",670,0)
 ;;=BCH HL7 SERVER CHRPC01^CHR Penbased HL7 ORU Message^^E^^^^^^^^IHS RPMS CHR SYSTEM
 ;;^UTILITY(U,$J,"PRO",670,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",670,10,1,0)
 ;;=342^^1
 ;;^UTILITY(U,$J,"PRO",670,10,1,"^")
 ;;=BCH HL7 ORU
 ;;^UTILITY(U,$J,"PRO",670,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",670,770)
 ;;=6^^3^46^i^P^^3^3^2
 ;;^UTILITY(U,$J,"PRO",671,0)
 ;;=BCH HL7 SERVER CHRPC02^CHR Penbased HL7 ORU Message^^E^^^^^^^^IHS RPMS CHR SYSTEM
 ;;^UTILITY(U,$J,"PRO",671,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",671,10,1,0)
 ;;=342^^1
 ;;^UTILITY(U,$J,"PRO",671,10,1,"^")
 ;;=BCH HL7 ORU
 ;;^UTILITY(U,$J,"PRO",671,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",671,770)
 ;;=7^^3^46^i^P^^3^3^2
 ;;^UTILITY(U,$J,"PRO",672,0)
 ;;=BCH HL7 SERVER CHRPC03^CHR Penbased HL7 ORU Message^^E^^^^^^^^IHS RPMS CHR SYSTEM
 ;;^UTILITY(U,$J,"PRO",672,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",672,10,1,0)
 ;;=342^^1
 ;;^UTILITY(U,$J,"PRO",672,10,1,"^")
 ;;=BCH HL7 ORU
 ;;^UTILITY(U,$J,"PRO",672,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",672,770)
 ;;=8^^3^46^i^P^^3^3^2
 ;;^UTILITY(U,$J,"PRO",673,0)
 ;;=BCH HL7 SERVER CHRPC04^CHR Penbased HL7 ORU Message^^E^^^^^^^^IHS RPMS CHR SYSTEM
 ;;^UTILITY(U,$J,"PRO",673,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",673,10,1,0)
 ;;=342^^1
 ;;^UTILITY(U,$J,"PRO",673,10,1,"^")
 ;;=BCH HL7 ORU
