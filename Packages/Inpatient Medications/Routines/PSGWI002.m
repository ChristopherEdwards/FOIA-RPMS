PSGWI002 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(50)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(50,.01,1,3,2.3)
 ;;=S X=Y(0) S Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$S('$D(^PS(50.5,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) S XMB(3)=X
 ;;^DD(50,.01,1,3,2.4)
 ;;=S X=Y(0) S Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$P(Y(1),U,10) S XMB(4)=X
 ;;^DD(50,.01,1,3,3)
 ;;=Used by the Inpatient Medications init process.
 ;;^DD(50,.01,1,3,"%D",0)
 ;;=^^5^5^2920518^^
 ;;^DD(50,.01,1,3,"%D",1,0)
 ;;=  This cross reference is used by the Inpatient Medications post-init
 ;;^DD(50,.01,1,3,"%D",2,0)
 ;;=process.  If this cross reference is not found when the inits are run, all
 ;;^DD(50,.01,1,3,"%D",3,0)
 ;;=of the entries in this file are marked for use by the Unit Dose Medications
 ;;^DD(50,.01,1,3,"%D",4,0)
 ;;=package by updating the APPLICATION PACKAGES USE field for each entry.
 ;;^DD(50,.01,1,3,"%D",5,0)
 ;;=(Routine used is PSGPOST).
 ;;^DD(50,.01,1,3,"CREATE PARAMETER #1")
 ;;=GENERIC NAME
 ;;^DD(50,.01,1,3,"CREATE PARAMETER #2")
 ;;=NON-FORMULARY
 ;;^DD(50,.01,1,3,"CREATE PARAMETER #3")
 ;;=CLASSIFICATION
 ;;^DD(50,.01,1,3,"CREATE PARAMETER #4")
 ;;=MESSAGE
 ;;^DD(50,.01,1,3,"CREATE VALUE")
 ;;=PSZDRUGCHANGE
 ;;^DD(50,.01,1,3,"DELETE PARAMETER #1")
 ;;=OLD GENERIC NAME
 ;;^DD(50,.01,1,3,"DELETE PARAMETER #2")
 ;;=NON-FORMULARY
 ;;^DD(50,.01,1,3,"DELETE PARAMETER #3")
 ;;=CLASSIFICATION
 ;;^DD(50,.01,1,3,"DELETE PARAMETER #4")
 ;;=MESSAGE
 ;;^DD(50,.01,1,3,"DELETE VALUE")
 ;;=PSZDRUGCHANGE
 ;;^DD(50,.01,1,4,0)
 ;;=50^AIUU^MUMPS
 ;;^DD(50,.01,1,4,1)
 ;;=Q
 ;;^DD(50,.01,1,4,2)
 ;;=Q
 ;;^DD(50,.01,1,4,"%D",0)
 ;;=^^1^1^2930113^
 ;;^DD(50,.01,1,4,"%D",1,0)
 ;;=This cross reference is used to force data into the file.
 ;;^DD(50,.01,3)
 ;;=Answer must be 1-40 characters in length.
 ;;^DD(50,.01,20,0)
 ;;=^.3LA^2^1
 ;;^DD(50,.01,20,1,0)
 ;;=PH
 ;;^DD(50,.01,20,2,0)
 ;;=PS
 ;;^DD(50,.01,21,0)
 ;;=^^1^1^2920518^^
 ;;^DD(50,.01,21,1,0)
 ;;=This is the generic name of the drug.
 ;;^DD(50,.01,22)
 ;;=
 ;;^DD(50,.01,"DEL",.01,0)
 ;;=I 1 W !?10,"DELETIONS ARE NOT ALLOWED"
 ;;^DD(50,.01,"DEL",100,0)
 ;;=I 1 W !,?10,"DELETIONS ARE NOT ALLOWED"
 ;;^DD(50,.01,"DT")
 ;;=2940104
 ;;^DD(50,63,0)
 ;;=APPLICATION PACKAGES' USE^FI^^2;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>90!($L(X)<1) X
 ;;^DD(50,63,1,0)
 ;;=^.1
 ;;^DD(50,63,1,1,0)
 ;;=50^IU
 ;;^DD(50,63,1,1,1)
 ;;=S ^PSDRUG("IU",X,DA)=""
 ;;^DD(50,63,1,1,2)
 ;;=K ^PSDRUG("IU",X,DA)
 ;;^DD(50,63,1,2,0)
 ;;=50^AIU^MUMPS
 ;;^DD(50,63,1,2,1)
 ;;=S Y(1)=$P(^PSDRUG(DA,0),"^") I Y(1)]"" F Y(2)=1:1:$L(X) S ^PSDRUG("AIU"_$E(X,Y(2)),Y(1),DA)=""
 ;;^DD(50,63,1,2,2)
 ;;=S Y(1)=$P(^PSDRUG(DA,0),"^") I Y(1)]"" F Y(2)=1:1:$L(X) K ^PSDRUG("AIU"_$E(X,Y(2)),Y(1),DA)
 ;;^DD(50,63,1,2,"%D",0)
 ;;=^^1^1^2920831^
 ;;^DD(50,63,1,2,"%D",1,0)
 ;;=Sets application package use field (63) cross-ref.
 ;;^DD(50,63,3)
 ;;=Answer must be 1-90 characters in length.
 ;;^DD(50,63,8.5)
 ;;=^
 ;;^DD(50,63,9)
 ;;=^
 ;;^DD(50,63,20,0)
 ;;=^.3LA^1^1
 ;;^DD(50,63,20,1,0)
 ;;=PS
 ;;^DD(50,63,21,0)
 ;;=^^3^3^2910221^^^^
 ;;^DD(50,63,21,1,0)
 ;;=This field is free text, but contains the codes of the DHCP packages
 ;;^DD(50,63,21,2,0)
 ;;=that consider this drug part of its formulary.  This field is set through
 ;;^DD(50,63,21,3,0)
 ;;=the routine ^PSGIU, and NOT through VA FileMan.
 ;;^DD(50,63,21,4,0)
 ;;= 
 ;;^DD(50,63,21,5,0)
 ;;=NOTES: Uneditable through VA FileMan.
 ;;^DD(50,63,"DT")
 ;;=2901221
 ;;^DD(50,300,0)
 ;;=INPATIENT PHARMACY LOCATION^F^^PSG;1^K:$L(X)>12!($L(X)<1) X
 ;;^DD(50,300,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(50,300,20,0)
 ;;=^.3LA^2^2
 ;;^DD(50,300,20,1,0)
 ;;=PSGW
 ;;^DD(50,300,21,0)
 ;;=^^3^3^2901030^^^^
 ;;^DD(50,300,21,1,0)
 ;;=Enter from 1 to 3 location codes, each separated by commas, that define the
 ;;^DD(50,300,21,2,0)
 ;;=location of this item in the inpatient pharmacy storage.  This will be used
 ;;^DD(50,300,21,3,0)
 ;;=to sort Automatic Replenishment reports for easier location of items.
 ;;^DD(50,300,"DT")
 ;;=2840621
 ;;^DD(50,301,0)
 ;;=AR/WS AMIS CATEGORY^S^0:Field 03 or 04 - Doses by Type;1:Field 06 or 07 - Units of Issue;2:Field 17 - Fluids and Admin Sets;3:Field 22 - Blood Products;^PSG;2^Q
