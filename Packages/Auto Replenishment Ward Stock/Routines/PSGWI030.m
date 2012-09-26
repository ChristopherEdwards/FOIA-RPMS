PSGWI030 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"DIPT",56,"F",1)
 ;;=
 ;;^UTILITY(U,$J,"DIPT",56,"F",2)
 ;;=1,2,X $P(^DD(58.12,5,0),U,5,99) S DIP(1)=X S X=DIP(1),DIP(2)=X S X=6,DIP(3)=X S X=2,X=$J(DIP(2),DIP(3),X) W X K DIP;C6;"STOCK ON HAND";Z;"$J(PERCENTAGE OF STOCK ON HAND,6,2)"~
 ;;^UTILITY(U,$J,"DIPT",56,"F",3)
 ;;=1,2,"%";C12;""~1,2,1;C18;"STOCK LEVEL"~1,2,.01;C28~1,.01~.01~
 ;;^UTILITY(U,$J,"DIPT",56,"H")
 ;;=PERCENTAGE OF STOCK ON HAND
 ;;^UTILITY(U,$J,"DIPT",68,0)
 ;;=PSGW SHOW AREA OF USE^2890627.1447^^58.1^^^^
 ;;^UTILITY(U,$J,"DIPT",68,"F",2)
 ;;=.01;S1~2,.01~2,1~2,2,.01~2,2,1~
 ;;^UTILITY(U,$J,"DIPT",68,"H")
 ;;=AREA OF USE / WARDS AND SERVICES
 ;;^UTILITY(U,$J,"FUN",107,0)
 ;;=PSGW BO LOCATION
 ;;^UTILITY(U,$J,"FUN",107,1)
 ;;=S X=$P(^PSI(58.3,D0,0),"^",1),DIC(0)="N",DIC="^PSI(58.1,D1,1," D ^DIC Q:Y<0  S X=$S($D(^PSI(58.1,D1,1,+Y,0)):$P(^(0),"^",8),1:"")
 ;;^UTILITY(U,$J,"FUN",107,3)
 ;;=0
 ;;^UTILITY(U,$J,"FUN",107,9)
 ;;=Lookup and then print the AOU item location for a backordered item
 ;;^UTILITY(U,$J,"KEY",6,0)
 ;;=PSGW PURGE
 ;;^UTILITY(U,$J,"KEY",6,1,0)
 ;;=^^2^2^2930323^^^^
 ;;^UTILITY(U,$J,"KEY",6,1,1,0)
 ;;=This key should be given to the Inpatient Pharmacy Package Coordinator 
 ;;^UTILITY(U,$J,"KEY",6,1,2,0)
 ;;=or designee who is allowed to purge data from the AR/WS files.
 ;;^UTILITY(U,$J,"KEY",7,0)
 ;;=PSGWMGR
 ;;^UTILITY(U,$J,"KEY",7,1,0)
 ;;=^^5^5^2930505^^^^
 ;;^UTILITY(U,$J,"KEY",7,1,1,0)
 ;;=This key locks the "Supervisor's" portion of the AR/WS package.  
 ;;^UTILITY(U,$J,"KEY",7,1,2,0)
 ;;=The key should be given to the Inpatient Pharmacy Package Coordinator 
 ;;^UTILITY(U,$J,"KEY",7,1,3,0)
 ;;=or his/her designee.  Also, any Pharmacist who is allowed to build, 
 ;;^UTILITY(U,$J,"KEY",7,1,4,0)
 ;;=enter, or edit AR/WS files should be given the key.  The lock also controls 
 ;;^UTILITY(U,$J,"KEY",7,1,5,0)
 ;;=preparation and printing of the AMIS report.
 ;;^UTILITY(U,$J,"KEY",8,0)
 ;;=PSGW PARAM
 ;;^UTILITY(U,$J,"KEY",8,1,0)
 ;;=^^3^3^2930505^^^^
 ;;^UTILITY(U,$J,"KEY",8,1,1,0)
 ;;=This key should be given ONLY to the Inpatient Pharmacy Package Coordinator.
 ;;^UTILITY(U,$J,"KEY",8,1,2,0)
 ;;=The key locks the AR/WS Site Parameters.  One of these parameters controls 
 ;;^UTILITY(U,$J,"KEY",8,1,3,0)
 ;;=WHEN the collection of AMIS data begins - thus the need for security.
 ;;^UTILITY(U,$J,"KEY",9,0)
 ;;=PSGW TRAN
 ;;^UTILITY(U,$J,"KEY",9,1,0)
 ;;=^^5^5^2930323^^^^
 ;;^UTILITY(U,$J,"KEY",9,1,1,0)
 ;;=This key should be given ONLY to the Inpatient Pharmacy Package
 ;;^UTILITY(U,$J,"KEY",9,1,2,0)
 ;;=Coordinator or his/her designee.  The key controls access to the
 ;;^UTILITY(U,$J,"KEY",9,1,3,0)
 ;;="Transfer AOU Stock Entries" option.  Using the Transfer option,
 ;;^UTILITY(U,$J,"KEY",9,1,4,0)
 ;;=users may "copy" the stock entries from one Area of Use into
 ;;^UTILITY(U,$J,"KEY",9,1,5,0)
 ;;=other Areas.
 ;;^UTILITY(U,$J,"OPT",151,0)
 ;;=PSGW EDIT AOU STOCK^Stock Items - Enter/Edit^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",151,1,0)
 ;;=^^2^2^2930301^^^^
 ;;^UTILITY(U,$J,"OPT",151,1,1,0)
 ;;=Provides access to enter or edit items stocked in an Area of Use.  This is
 ;;^UTILITY(U,$J,"OPT",151,1,2,0)
 ;;=how the list of items an AOU stocks is created or changed.
 ;;^UTILITY(U,$J,"OPT",151,25)
 ;;=PSGWSTKI
 ;;^UTILITY(U,$J,"OPT",151,"U")
 ;;=STOCK ITEMS - ENTER/EDIT
 ;;^UTILITY(U,$J,"OPT",152,0)
 ;;=PSGW INACTIVATE AOU STOCK ITEM^Inactivate AOU Stock Item^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",152,1,0)
 ;;=^^2^2^2930518^^^^
 ;;^UTILITY(U,$J,"OPT",152,1,1,0)
 ;;=Use this option to inactivate an item that is currently on an AOU's
 ;;^UTILITY(U,$J,"OPT",152,1,2,0)
 ;;=stock list.  Items should not be deleted, but simply made inactive.
 ;;^UTILITY(U,$J,"OPT",152,25)
 ;;=PSGWBGIN
 ;;^UTILITY(U,$J,"OPT",152,"U")
 ;;=INACTIVATE AOU STOCK ITEM
 ;;^UTILITY(U,$J,"OPT",153,0)
 ;;=PSGW WARD STOCK MAINT^Supervisor's Menu^^M^^PSGWMGR^^^^^^
 ;;^UTILITY(U,$J,"OPT",153,1,0)
 ;;=^^5^5^2930603^^^^
 ;;^UTILITY(U,$J,"OPT",153,1,1,0)
 ;;=This option supports activities to build and maintain the files needed to
 ;;^UTILITY(U,$J,"OPT",153,1,2,0)
 ;;=operate Automatic Replenishment/Ward Stock.  It also contains the necessary
