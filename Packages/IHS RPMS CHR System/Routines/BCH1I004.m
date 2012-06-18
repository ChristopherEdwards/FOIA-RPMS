BCH1I004 ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ; 
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1201,"L",2,113,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1202,"L",2,113,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1203,"L",2,113,4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1204,"L",2,113,5)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1205,"L",2,113,6)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1206,"L",2,113,7)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1207,"L",2,113,8)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1208,"L",2,113,9)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1209,"L",2,113,10)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1210,"L",2,113,16)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1301,"L",2,113,18)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1302,"L",2,113,19)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1303,"L",2,113,23)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1304,"L",2,113,26)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1305,"L",2,113,25)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1306,"L",2,113,28)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1307,"L",2,113,24)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",1308,"L",2,113,27)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",2101,"L",1,31,13)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",2102,"L",1,31,14)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",5101,"L",1,31,17)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",6101,"L",1,31,18)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002",7101,"L",1,31,19)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002.01",.01,"L",3,124,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002.01",.04,"L",3,124,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002.01",.05,"L",3,124,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002.01",.06,"L",4,125,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","F90002.01",.07,"L",4,125,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,0,6)
 ;;=**********   E D I T   C H R   R E C O R D  D A T A   **********
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,2,0)
 ;;=Date of Service:                         Program:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,2,0,"A")
 ;;=1;15;U^42;48;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,3,1)
 ;;=Temp Residence:                         Provider:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,3,1,"A")
 ;;=41;48;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,5,12)
 ;;=Edit Assessments/POVs?:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,7,17)
 ;;=Activity Location:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,7,17,"A")
 ;;=1;17;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,8,14)
 ;;=Hospital/Clinic Name:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,9,16)
 ;;=Referred to CHR by:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,10,16)
 ;;=Referred by CHR to:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,11,24)
 ;;=Evaluation:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,12,23)
 ;;=Travel Time:           # Served:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,12,23,"A")
 ;;=1;11;U^24;31;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,13,15)
 ;;=Purpose of Referral:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,14,27)
 ;;=Insurer:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,15,3)
 ;;=Subjective::         Objective:        Plans/Treatments:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",1,16,3)
 ;;=Edit Measurements/Tests/Reprod?:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,1,10)
 ;;=******* EDIT MEASUREMENTS/TEST/REPRODUCTIVE FACTORS *******
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,3,3)
 ;;=** MEASUREMENTS **                   ** TESTS **
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,5,3)
 ;;=BP:                    PPD:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,6,3)
 ;;=WT:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,7,3)
 ;;=HT:                    BLOOD SUGAR  Date:              Result:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,8,3)
 ;;=HC:                    THRT CULT    Date:              Result:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,9,26)
 ;;=HCT          Date:              Result:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,10,3)
 ;;=VU:                    UA           Date:              Result:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,11,3)
 ;;=VC:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,13,3)
 ;;=TEMP:                          ** REPRODUCTIVE FACTORS **
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,14,3)
 ;;=PULSE:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",2,15,3)
 ;;=RESP:                     LMP:               FP METHOD:
