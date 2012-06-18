BCH1I00C ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ; 
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,28,0)
 ;;=21^Result^3
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,28,1)
 ;;=1306
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,28,2)
 ;;=10,65^8^10,57
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",1,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",2,11)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",3,12)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",4,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",5,16)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",6,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",7,4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",8,17)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",9,18)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",10,19)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",11,5)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",12,20)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",13,23)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",14,26)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",15,21)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",16,24)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",17,27)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",18,6)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",19,22)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",20,25)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",21,28)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",22,7)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",23,8)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",24,13)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",25,9)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",26,10)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",27,14)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"B",28,15)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","** MEASUREMENTS **",11)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","** REPRODUCTIVE FACTORS **",13)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","** TESTS **",12)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","******* EDIT MEASUREMENTS/TEST/REPRODUCTIVE FACTORS *******",1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","BLOOD SUGAR",17)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","BP",2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","DATE",18)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","DATE",23)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","DATE",24)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","DATE",25)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","FP METHOD",15)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","HC",5)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","HCT",21)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","HT",4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","LMP",14)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","PPD",16)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","PULSE",9)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","RESP",10)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","RESULT",19)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","RESULT",26)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","RESULT",27)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","RESULT",28)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","TEMP",8)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","THRT CULT",20)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","UA",22)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","VC",7)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","VU",6)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",113,40,"C","WT",3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",123,0)
 ;;=BCH POV HEADER BLOCK^90002
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,0)
 ;;=^.4044I^6^6
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,1,0)
 ;;=1^*********  ASSESSMENT - PCC PURPOSE OF VISIT  **********^1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,1,2)
 ;;=^^1,9
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,2,0)
 ;;=2^Enter/Edit Screen^1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,2,2)
 ;;=^^2,27
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,3,0)
 ;;=3^Date of Service^3
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,3,1)
 ;;=.01
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,3,2)
 ;;=3,18^20^3,1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,3,4)
 ;;=^^^1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,4,0)
 ;;=4^CHR^3
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,4,1)
 ;;=.03
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,4,2)
 ;;=3,46^25^3,41
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,4,4)
 ;;=^^^1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,5,0)
 ;;=5^---------------------------------------------------------------------------^1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,5,2)
 ;;=^^5,1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,6,0)
 ;;=6^<<to edit the narrative/sub related data, hit return at svc mins>>^1
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,6,2)
 ;;=^^4,6
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,"B",1,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.404,",123,40,"B",2,2)
 ;;=
