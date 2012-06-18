IBINI021	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.7,0,"GL")
	;;=^IBE(350.7,
	;;^DIC("B","AMBULATORY CHECK-OFF SHEET",350.7)
	;;=
	;;^DIC(350.7,"%D",0)
	;;=^^5^5^2940214^^^^
	;;^DIC(350.7,"%D",1,0)
	;;=This file contains the details of the line format
	;;^DIC(350.7,"%D",2,0)
	;;=for the Ambulatory Surgries Check-off Sheets.
	;;^DIC(350.7,"%D",3,0)
	;;=Each sheet in this file can be associated with multiple clinics.
	;;^DIC(350.7,"%D",4,0)
	;;= 
	;;^DIC(350.7,"%D",5,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.7,0)
	;;=FIELD^^.01^4
	;;^DD(350.7,0,"DDA")
	;;=N
	;;^DD(350.7,0,"DT")
	;;=2911119
	;;^DD(350.7,0,"IX","B",350.7,.01)
	;;=
	;;^DD(350.7,0,"NM","AMBULATORY CHECK-OFF SHEET")
	;;=
	;;^DD(350.7,0,"PT",44,25)
	;;=
	;;^DD(350.7,0,"PT",350.71,.04)
	;;=
	;;^DD(350.7,.01,0)
	;;=NAME^RFX^^0;1^S IBGRPX=$G(DA) D FFMT^IBEFUNC2 S IBLNGX=$S($P(IBLNGX,U,2):$P(IBLNGX,U,2),1:59) K:$L(X)<3!'(X'?1P.E)!($L(X)>IBLNGX) X K IBLNGX,IBGRPX
	;;^DD(350.7,.01,1,0)
	;;=^.1
	;;^DD(350.7,.01,1,1,0)
	;;=350.7^B
	;;^DD(350.7,.01,1,1,1)
	;;=S ^IBE(350.7,"B",$E(X,1,30),DA)=""
	;;^DD(350.7,.01,1,1,2)
	;;=K ^IBE(350.7,"B",$E(X,1,30),DA)
	;;^DD(350.7,.01,3)
	;;=Enter the title to be printed on the CPT list for this sheet.  PLEASE NOTE THAT DELETING A SHEET ALSO DELETES ALL THE SHEET'S SUB-HEADERS AND PROCEDURES.Maximum length depends on number of columns.  
	;;^DD(350.7,.01,4)
	;;=S IBGRPX=$G(DA) D FFMT^IBEFUNC2 W !,?5,"Maximum length for this SHEET is now ",$S($P(IBLNGX,U,2):$P(IBLNGX,U,2),1:59)," characters.",! K IBLNGX,IBGRPX
	;;^DD(350.7,.01,21,0)
	;;=^^3^3^2920512^^^^
	;;^DD(350.7,.01,21,1,0)
	;;=Title for this sheet (group), printed on the CPT list for the associated
	;;^DD(350.7,.01,21,2,0)
	;;=clinics.  Maximum length allowed is calculated because it will change
	;;^DD(350.7,.01,21,3,0)
	;;=depending on the line format for the sheet.
	;;^DD(350.7,.01,"DEL",1,0)
	;;=I '$D(IBERSCE)
	;;^DD(350.7,.01,"DT")
	;;=2940317
	;;^DD(350.7,.02,0)
	;;=DISPLAY CHARGE^RS^0:NO;1:YES;^0;2^Q
	;;^DD(350.7,.02,3)
	;;=Enter 'Y' if you want the CPT charge to be printed on the check-off sheet, along with NAME and CODE.  Printing the charge decreases the number of characters available for the procedure name, by 10.
	;;^DD(350.7,.02,21,0)
	;;=^^3^3^2920220^^^^
	;;^DD(350.7,.02,21,1,0)
	;;=Indicates if the charge should be displayed on this check-off sheet.
	;;^DD(350.7,.02,21,2,0)
	;;=If charge is displayed, then the number of characters available for the
	;;^DD(350.7,.02,21,3,0)
	;;=procedure name is decreased.
	;;^DD(350.7,.02,"DT")
	;;=2911119
	;;^DD(350.7,.03,0)
	;;=COLUMNS^RS^2:TWO VERTICAL;3:THREE VERTICAL;^0;3^Q
	;;^DD(350.7,.03,3)
	;;=Enter the number of vertical columns of CPT codes printed on each page for this check-off sheet.  Number of characters for name (w/ w/o $): 2 columns=36/46, 3 columns=14/24.
	;;^DD(350.7,.03,21,0)
	;;=^^3^3^2920409^^^^
	;;^DD(350.7,.03,21,1,0)
	;;=The number of vertical columns used when printing this check-off sheet.
	;;^DD(350.7,.03,21,2,0)
	;;=The number of columns on a page determines the column width and the
	;;^DD(350.7,.03,21,3,0)
	;;=number of characters available for the procedure/subheader name.
	;;^DD(350.7,.03,"DT")
	;;=2911119
	;;^DD(350.7,.04,0)
	;;=LINE FORMAT^RS^1:CODE/NAME/$;2:NAME/CODE/$;^0;4^Q
	;;^DD(350.7,.04,3)
	;;=Enter the code corresponding to the positioning of data elements within a vertical column on the check-off sheet.  (Ignore the $ if charge is not to be printed.)
	;;^DD(350.7,.04,21,0)
	;;=^^1^1^2920220^^^^
	;;^DD(350.7,.04,21,1,0)
	;;=Position of data elements within a column.
