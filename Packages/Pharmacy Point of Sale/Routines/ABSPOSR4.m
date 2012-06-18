ABSPOSR4 ; IHS/FCS/DRS - back billing ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; Back billing - similar to ABSPOSR3
 ; and in fact, it uses ABSPOSR3 subroutines to do much of its work.
 ; It depends very much on the ABSPOSR3 flag to DO NOT RESUMBIT.
 ; (We want to backbill, not rebill!)
 ;
 ; Might be programmer mode only, though an option could certainly
 ; point here.
 Q  ;
BACKBILL ;EP -
 N RANGE,X
 S X=$$DTR^ABSPOSU1("Backbill starting at date@time: ","Backbill thru what date@time: ",,,"T")
 Q:'X
 N BEGINDT,ENDDT S BEGINDT=$P(X,U),ENDDT=$P(X,U,2)
 I $P(ENDDT,".",2)="" S $P(ENDDT,".",2)=24 ; assume entire day
 D INIT^ABSPOSL(DT+.6,1)
 D LOG("Back billing with range "_BEGINDT_"-"_ENDDT)
 D LOG(" (from "_$$CVTDATE(BEGINDT)_" thru "_$$CVTDATE(ENDDT)_")")
 N THELIST S THELIST=$$THELIST D KILLLIST
 ;
 I 1'=$$YESNO^ABSPOSU3("Backbill for "_$$CVTDATE(BEGINDT)_" thru "_$$CVTDATE(ENDDT)_"; are you sure","N",0) D  Q
 . W !,"Okay, nothing is done.",!
 ;
 W !!,"Processing...",! H 1
 ;
 ; Gather list of prescriptions that need to be back billed.
 ;
 D LOG("Building the list of prescriptions to back bill for...")
 D WORKLIST^ABSPOSR3(BEGINDT,ENDDT,THELIST)
 N COUNT S COUNT=$$DUMPLIST(THELIST)
 W !!,"Count of transactions in the work list: ",COUNT,!!
 I 'COUNT G EXIT
 H 3
 ;
 ; We now have  @THELIST@(time,type,rxi,rxr)
 ;  time = date/time of pharmacy activity
 ;  type = 1 for claim, 2 for returned to stock
 ;  rxi,rxr points to prescription, refill
 ;
 ; And now bill them all
 ;
 D LOG("Submitting all the claims...")
 I 0 D
 . D LOG("Short-circuit - not just yet") D
 . D DUMPLIST
 E  D
 . D PROCESS^ABSPOSR3(THELIST)
 ;
 W !,"Done! There may still be processing going on in the background.",!
 W "The usual Point of Sale programs can be used to examine",!
 W "any ongoing progress on these claims.",!
 W "The usual Point of Sale reports can be run; you should wait",!
 W "until all the background processing of the back billing has finished.",!
 W !
 W "Also note that before trying to run reports, you should",!
 W "run URM (on the CLA reports menu) for the date range.",!
 H 5
EXIT D LOG("Complete.")
 D RELSLOT^ABSPOSL
 Q
 ;
LOGFILE D LOGFILE1^ABSPOSR1(.6) Q
DUMPLIST(X) ; $G(X)=0 to count and return total
 ; X=1 to dump contents to log file
 N TIME,TYPE,RXI,RXR,COUNT S COUNT=0
 D LOG("Contents of THELIST:")
 S TIME="" F  S TIME=$O(@THELIST@(TIME)) Q:TIME=""  D
 . S TYPE="" F  S TYPE=$O(@THELIST@(TIME,TYPE)) Q:TYPE=""  D
 . . S RXI="" F  S RXI=$O(@THELIST@(TIME,TYPE,RXI)) Q:RXI=""  D
 . . . S RXR="" F  S RXR=$O(@THELIST@(TIME,TYPE,RXI,RXR)) Q:RXR=""  D
 . . . . D LOG(TIME_" "_TYPE_" "_RXI_" "_RXR)
 . . . . S COUNT=COUNT+1
 Q:$Q COUNT Q
LOG(X) D LOG^ABSPOSL(X) Q
 ; Keep THELIST and KILLLIST in agreement!
THELIST() Q "^ABSPECP("""_$T(+0)_""","_$J_","_BEGINDT_")"
KILLLIST K ^ABSPECP($T(+0),$J,BEGINDT) Q  ; safer than K @
CVTDATE(Y) X ^DD("DD") Q Y
