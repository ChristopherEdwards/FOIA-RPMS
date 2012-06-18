ABSPOSR2 ; IHS/FCS/DRS - silent claim submitter ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; SHOWQ subroutine - continuation of ABSPOSRX
 Q
SHOWQ ;EP - ABSPOSRX ;  ^ABSPECP("ABSPOSRX",type,RXI,RXR)
 N ROOT S ROOT="^ABSPECP(""ABSPOSRX"")"
 N COUNT S COUNT=0
 I '$O(@ROOT@(""))="" W "None",! Q
 N TYPE,RXI,RXR
 F TYPE="CLAIM","UNCLAIM" D
 . W TYPE
 . I '$D(@ROOT@(TYPE)) W " - none",! Q
 . W ":",!
 . S RXI="" F  S RXI=$O(@ROOT@(TYPE,RXI)) Q:RXI=""  D
 . . S RXR="" F  S RXR=$O(@ROOT@(TYPE,RXI,RXR)) Q:RXR=""  D
 . . . W RXI,",",RXR
 . . . ; details like patient, drug could go here
 . . . W !
 . . . S COUNT=COUNT+1
 . W "Total ",COUNT," ",TYPE W:COUNT'=1 "s"
 . W !
 Q
