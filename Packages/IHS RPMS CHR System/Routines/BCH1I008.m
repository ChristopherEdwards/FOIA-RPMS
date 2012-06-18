BCH1I008 ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ; 
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,2,0,"A")
 ;;=1;15;U^41;43;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,3,5)
 ;;=<<to edit the narrative/sub related data, hit return at svc mins>>
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,4,0)
 ;;=---------------------------------------------------------------------------
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,5,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,5,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,6,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,6,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,7,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,7,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,8,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,8,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,9,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,9,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,10,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",3,10,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",4,10,2)
 ;;=NARRATIVE:
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ","X",4,11,2)
 ;;=SUBSTANCE RELATED (Y/N):
 ;;^UTILITY(U,$J,"DIST(.404,",31,0)
 ;;=BCH EDIT RECORD DATA^90002
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,0)
 ;;=^.4044I^19^19
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,1,0)
 ;;=1^**********   E D I T   C H R   R E C O R D  D A T A   **********^1^
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,1,2)
 ;;=^^1,7
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,2,0)
 ;;=2^Date of Service^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,2,1)
 ;;=.01
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,2,2)
 ;;=3,19^20^3,1
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,3,0)
 ;;=3^Program^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,3,1)
 ;;=.02
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,3,2)
 ;;=3,53^20^3,42
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,4,0)
 ;;=7^Activity Location^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,4,1)
 ;;=.06
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,4,2)
 ;;=8,38^20^8,18
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,4,4)
 ;;=1
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,5,0)
 ;;=5^Provider^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,5,1)
 ;;=.03
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,5,2)
 ;;=4,53^20^4,42
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,6,0)
 ;;=8^Hospital/Clinic Name^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,6,1)
 ;;=.05
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,6,2)
 ;;=9,38^20^9,15
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,6,4)
 ;;=0
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,7,0)
 ;;=9^Referred to CHR by^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,7,1)
 ;;=.07
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,7,2)
 ;;=10,38^20^10,17
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,8,0)
 ;;=11^Evaluation^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,8,1)
 ;;=.09
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,8,2)
 ;;=12,38^40^12,25
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,9,0)
 ;;=10^Referred by CHR to^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,9,1)
 ;;=.08
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,9,2)
 ;;=11,38^20^11,17
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,10,0)
 ;;=12^Travel Time^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,10,1)
 ;;=.11
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,10,2)
 ;;=13,38^6^13,24
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,11,0)
 ;;=13^# Served^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,11,1)
 ;;=.12
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,11,2)
 ;;=13,58^5^13,47
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,11,4)
 ;;=1
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,12,0)
 ;;=4^Temp Residence^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,12,1)
 ;;=1108
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,12,2)
 ;;=4,19^20^4,2
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,13,0)
 ;;=14^Purpose of Referral^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,13,1)
 ;;=2101
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,13,2)
 ;;=14,38^40^14,16
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,14,0)
 ;;=15^Insurer^3
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,14,1)
 ;;=2102
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,14,2)
 ;;=15,38^40^15,28
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,15,0)
 ;;=19^Edit Measurements/Tests/Reprod?^2
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,15,2)
 ;;=17,38^1^17,4
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,15,3)
 ;;=N
 ;;^UTILITY(U,$J,"DIST(.404,",31,40,15,10)
 ;;=I X="Y" S DDSSTACK="Page 1.2"
