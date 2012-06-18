PXRMBMI ; SLC/PKR - This is an example of a computed finding. ;05/18/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;=======================================================================
BMI(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return the BMI.
 N BMI,DATA,HDATE,GMRVSTR,IEN,INVDATE,WDATA,WDATE
 ;Get the height and weight.
 S GMRVSTR="HT;WT;"
 S GMRVSTR(0)=U_U_1_U_0
 K ^UTILITY($J,"GMRVD")
 D EN1^GMRVUT0
 ;Find the most recent entry for height.
 I $D(^UTILITY($J,"GMRVD","HT")) D
 . S INVDATE=$O(^UTILITY($J,"GMRVD","HT",""))
 . S HDATE=$$FMDFINVL^PXRMDATE(INVDATE,0)
 E  D
 . S HDATE=0
 ;Find the most recent entry for weight.
 I $D(^UTILITY($J,"GMRVD","WT")) D
 . S INVDATE=$O(^UTILITY($J,"GMRVD","WT",""))
 . S WDATE=$$FMDFINVL^PXRMDATE(INVDATE,0)
 . S IEN=$O(^UTILITY($J,"GMRVD","WT",INVDATE,""))
 . S WDATA=$G(^UTILITY($J,"GMRVD","WT",INVDATE,IEN))
 E  D
 . S WDATE=0
 . S WDATA=""
 ;Use the oldest date of the two.
 S DATE=$$MIN^XLFMTH(HDATE,WDATE)
 S BMI=$P(WDATA,U,14)
 S TEST=1
 I BMI="" S VALUE="?"
 E  S VALUE=BMI
 K ^UTILITY($J,"GMRVD")
 Q
 ;
