BCH1I007 ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ; 
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","DATE OF SERVICE",3,3,123,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","EVALUATION",1,1,32,9)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","HLTH PROB",3,3,124,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","INSURER",1,1,32,14)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","NARRATIVE",4,4,125,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","OBJECTIVE",1,1,32,18)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","PLANS/TREATMENTS",1,1,32,19)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","PROGRAM",1,1,32,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","PURPOSE REF",1,1,32,13)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","REF BY CHR TO",1,1,32,8)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","REF TO CHR BY",1,1,32,7)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","SUBJECTIVE",1,1,32,17)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","SUBSTANCE RELATED (Y/N)",4,4,125,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","SVC CODE",3,3,124,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","SVC MINS",3,3,124,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","TEMP RESIDENCE",1,1,32,12)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","CAP","TRAVEL TIME",1,1,32,10)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F0","16,32","L",1,32,16)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.01,"L",1,32,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.01,"L",3,123,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.02,"L",1,32,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.03,"L",1,32,5)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.03,"L",3,123,4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.05,"L",2,110,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.06,"L",1,32,4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.07,"L",1,32,7)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.08,"L",1,32,8)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.09,"L",1,32,9)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.11,"L",1,32,10)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",.12,"L",1,32,11)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",1108,"L",1,32,12)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",2101,"L",1,32,13)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",2102,"L",1,32,14)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",5101,"L",1,32,17)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",6101,"L",1,32,18)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002",7101,"L",1,32,19)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002.01",.01,"L",3,124,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002.01",.04,"L",3,124,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002.01",.05,"L",3,124,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002.01",.06,"L",4,125,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","F90002.01",.07,"L",4,125,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,0,7)
 ;;=**********  E N T E R  C H R  R E C O R D  D A T A  **********
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,1,0)
 ;;=DATE OF SERVICE:                       PROGRAM:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,1,0,"A")
 ;;=1;15;U^40;46;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,2,0)
 ;;=CHR PROVIDER:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,2,0,"A")
 ;;=1;12;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,3,0)
 ;;=-------------------------------------------------------------------------------
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,5,0)
 ;;=ASSESSMENT - PCC PURPOSE OF VISIT (hit return):
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,7,0)
 ;;=ACT LOCATION:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,7,0,"A")
 ;;=1;12;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,8,0)
 ;;=REF TO CHR BY:             REF BY CHR TO:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,9,0)
 ;;=EVALUATION:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,11,0)
 ;;=TRAVEL TIME:         # SERVED:          TEMP RESIDENCE:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,11,0,"A")
 ;;=1;11;U^22;29;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,13,0)
 ;;=SUBJECTIVE:          OBJECTIVE:         PLANS/TREATMENTS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,15,0)
 ;;=PURPOSE REF:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",1,16,0)
 ;;=INSURER:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",2,10,16)
 ;;=Enter the Hospital or Clinic Name
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,0,8)
 ;;=*********  ASSESSMENT - PCC PURPOSE OF VISIT  **********
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,1,26)
 ;;=Enter/Edit Screen
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,2,0)
 ;;=Date of Service:                        CHR:
