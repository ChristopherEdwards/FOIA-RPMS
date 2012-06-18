BCH1I005 ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ; 
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,0,8)
 ;;=*********  ASSESSMENT - PCC PURPOSE OF VISIT  **********
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,1,26)
 ;;=Enter/Edit Screen
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,2,0)
 ;;=Date of Service:                        CHR:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,2,0,"A")
 ;;=1;15;U^41;43;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,3,5)
 ;;=<<to edit the narrative/sub related data, hit return at svc mins>>
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,4,0)
 ;;=---------------------------------------------------------------------------
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,6,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,6,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,7,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,7,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,8,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,8,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,9,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,9,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,10,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,10,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,11,0)
 ;;=HLTH PROB:                      SVC CODE:                   SVC MINS:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",3,11,0,"A")
 ;;=1;9;U^33;40;U^61;68;U
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",4,6,1)
 ;;=NARRATIVE:
 ;;^UTILITY(U,$J,"DIST(.403,",11,"AZ","X",4,7,1)
 ;;=SUBSTANCE RELATED (Y/N):
 ;;^UTILITY(U,$J,"DIST(.403,",12,0)
 ;;=BCH ENTER CHRIS II DATA^^^^2941117^^^90002^0^0^1
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,0)
 ;;=^.4031I^4^4
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,1,0)
 ;;=1^^1,1^^^0
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,1,1)
 ;;=ENTER CHRISS II DATA
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,1,40,0)
 ;;=^.4032PI^32^1
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,1,40,32,0)
 ;;=BCH ENTER CHRIS II RECORD DATA^1^1,1^e
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,1,40,"AC",1,32)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,1,40,"B",32,32)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,2,0)
 ;;=1.2^^9,14^^^1^14,54
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,2,1)
 ;;=Page 1.2
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,2,40,0)
 ;;=^.4032IP^110^1
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,2,40,110,0)
 ;;=BCH HOSP NAME^1^2,2^e
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,2,40,"AC",1,110)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,2,40,"B",110,110)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,0)
 ;;=1.4^^1,1
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,1)
 ;;=Page 1.4
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,11)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,12)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,0)
 ;;=^.4032IP^124^2
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,123,0)
 ;;=BCH POV HEADER BLOCK^1^1,1^e
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,124,0)
 ;;=BCH POV EDIT BLK^2^6,1^e
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,124,2)
 ;;=6^AD^n^0
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,124,11)
 ;;=S BCHLOOK=""
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,124,12)
 ;;=K BCHLOOK
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,"AC",1,123)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,"AC",2,124)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,"B",123,123)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,3,40,"B",124,124)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,4,0)
 ;;=1.6^^9,1^^^1^13,76
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,4,1)
 ;;=Page 1.6
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,4,40,0)
 ;;=^.4032IP^125^1
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,4,40,125,0)
 ;;=BCH POV PROV NARR^1^2,2^e
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,4,40,"AC",1,125)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,4,40,"B",125,125)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"B",1,1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"B",1.2,2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"B",1.4,3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"B",1.6,4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"C","ENTER CHRISS II DATA",1)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"C","PAGE 1.2",2)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"C","PAGE 1.4",3)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,40,"C","PAGE 1.6",4)
 ;;=
 ;;^UTILITY(U,$J,"DIST(.403,",12,"AZ",1,0,0,"N")
 ;;=14,32^2,32^2,32^14,32^2,32
