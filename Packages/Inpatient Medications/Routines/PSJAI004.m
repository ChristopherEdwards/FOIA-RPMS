PSJAI004 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 Q:'DIFQ(59.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.5,9,21,2,0)
 ;;=If you do not enter data into this field, the system will use '30' as
 ;;^DD(59.5,9,21,3,0)
 ;;=the default.  If a line of print cannot fit within the width you define 
 ;;^DD(59.5,9,21,4,0)
 ;;=here, it will continue on the next line of the label.
 ;;^DD(59.5,9,"DT")
 ;;=2850827
 ;;^DD(59.5,10,0)
 ;;=STOP TIME FOR ORDER^NJ4,0X^^1;14^K:X>2400!($L(X)<4)!(X<1)!(X?.E1"."1N.N) X I $D(X) S PSIVX=X,PSIVY=$G(Y) S %DT="T",Y=DT_"."_X X ^DD("DD") S X=Y D ^%DT S X=PSIVX K:Y<0 X S Y=PSIVY K PSIVX,PSIVY
 ;;^DD(59.5,10,3)
 ;;=Type a whole number between 0001 and 2400.
 ;;^DD(59.5,10,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,10,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,10,21,0)
 ;;=^^4^4^2910306^^^^
 ;;^DD(59.5,10,21,1,0)
 ;;=  Enter the TIME of the day that orders should end.  For example
 ;;^DD(59.5,10,21,2,0)
 ;;=if IV's are good for 14 days and an order's start date/time is 
 ;;^DD(59.5,10,21,3,0)
 ;;=MAY 01 1985@1200 and 2200 is entered at this prompt,
 ;;^DD(59.5,10,21,4,0)
 ;;=then the default stop date/time will be MAY 14 1985@22:00.
 ;;^DD(59.5,10,"DT")
 ;;=2860128
 ;;^DD(59.5,11,0)
 ;;=*DC ORDERS ON SERVICE TRANSFER^S^0:NO;1:YES;^1;15^Q
 ;;^DD(59.5,11,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,11,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,11,21,0)
 ;;=^^4^4^2910306^^^
 ;;^DD(59.5,11,21,1,0)
 ;;=If you want all IV ORDERS to be dc'd automatically when a patient
 ;;^DD(59.5,11,21,2,0)
 ;;=transfers between SERVICE, enter a '1' or 'YES'.  If a '0' or 'NO'
 ;;^DD(59.5,11,21,3,0)
 ;;=is entered in this site parameter, no orders will be automatically
 ;;^DD(59.5,11,21,4,0)
 ;;=dc'd due to service transfer.
 ;;^DD(59.5,11,"DT")
 ;;=2850907
 ;;^DD(59.5,12,0)
 ;;=LINE FEEDS BETWEEN LABELS^NJ1,0^^1;16^K:+X'=X!(X>6)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(59.5,12,3)
 ;;=Type a whole number between 0 and 6.
 ;;^DD(59.5,12,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,12,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,12,21,0)
 ;;=^^4^4^2910306^^^^
 ;;^DD(59.5,12,21,1,0)
 ;;=  Type the number of line feeds between each IV label.  Ex. If
 ;;^DD(59.5,12,21,2,0)
 ;;=you type '1', there will be one line feed between each IV label.
 ;;^DD(59.5,12,21,3,0)
 ;;=This parameter makes it possible to have a top and bottom margin
 ;;^DD(59.5,12,21,4,0)
 ;;=on your IV LABELS.
 ;;^DD(59.5,12,"DT")
 ;;=2851218
 ;;^DD(59.5,13,0)
 ;;=LABEL DEVICE^FX^^0;2^K:$L(X)>20!($L(X)<1) X I $D(X),X]"" D ENDLP^PSGSET K:X="" X
 ;;^DD(59.5,13,3)
 ;;=Enter a device on which labels may be printed.
 ;;^DD(59.5,13,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,13,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,13,21,0)
 ;;=^^4^4^2910313^^^^
 ;;^DD(59.5,13,21,1,0)
 ;;=  Enter the device number or name that will be used most frequently
 ;;^DD(59.5,13,21,2,0)
 ;;=as the LABEL device for this IV ROOM.  This field will be shown as
 ;;^DD(59.5,13,21,3,0)
 ;;=the default for the 'Printer label device: ' prompt when signing
 ;;^DD(59.5,13,21,4,0)
 ;;=into the IV PACKAGE.
 ;;^DD(59.5,13,"DT")
 ;;=2910313
 ;;^DD(59.5,14,0)
 ;;=REPORT DEVICE^FX^^0;3^K:$L(X)>20!($L(X)<1) X I $D(X),X]"" D ENDLP^PSGSET K:X="" X
 ;;^DD(59.5,14,3)
 ;;=Enter a device on which reports may be printed.
 ;;^DD(59.5,14,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,14,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,14,21,0)
 ;;=^^4^4^2940714^^^^
 ;;^DD(59.5,14,21,1,0)
 ;;= Enter the PROFILE device number or name that will be used most frequently
 ;;^DD(59.5,14,21,2,0)
 ;;=by this IV ROOM.  This field will be shown as the default for the 'Printer
 ;;^DD(59.5,14,21,3,0)
 ;;=profile device: ' prompt when signing into the IV PACKAGE.
 ;;^DD(59.5,14,21,4,0)
 ;;= 
 ;;^DD(59.5,14,"DT")
 ;;=2910313
 ;;^DD(59.5,15,0)
 ;;=END OF LABEL TEXT^F^^4;E1,245^K:$L(X)>245!($L(X)<1) X
 ;;^DD(59.5,15,3)
 ;;=Answer must be 1-245 characters in length.
 ;;^DD(59.5,15,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,15,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,15,21,0)
 ;;=^^7^7^2910306^^^^
 ;;^DD(59.5,15,21,1,0)
 ;;=  Enter any END OF LABEL TEXT, separated by '^', that you wish to print
 ;;^DD(59.5,15,21,2,0)
 ;;=at the bottom of every IV LABEL.  For example:
 ;;^DD(59.5,15,21,3,0)
 ;;=  To have 'RETURN TO IV ROOM IN 24-HOURS'
 ;;^DD(59.5,15,21,4,0)
 ;;=          'FILLED BY: ____  CHECKED BY: ____'
 ;;^DD(59.5,15,21,5,0)
 ;;=printed at the bottom of your IV LABELS, enter:
 ;;^DD(59.5,15,21,6,0)
 ;;=  'RETURN TO IV ROOM IN 24-HOURS^FILLED BY: ____  CHECKED BY: ____' in
 ;;^DD(59.5,15,21,7,0)
 ;;=this field.
 ;;^DD(59.5,15,"DT")
 ;;=2860519
 ;;^DD(59.5,17,0)
 ;;=SYRN'S GOOD FOR HOW MANY DAYS^NJ5,2^^5;1^K:+X'=X!(X>31)!(X<1)!(X?.E1"."3N.N) X
 ;;^DD(59.5,17,3)
 ;;=Type a Number between 1 and 31, 2 Decimal Digits
 ;;^DD(59.5,17,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,17,20,1,0)
 ;;=PSJI
