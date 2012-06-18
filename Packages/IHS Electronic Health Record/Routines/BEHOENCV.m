BEHOENCV ;MSC/IND/DKM - Cover Sheet: Visits ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**037001**;Mar 20, 2007
 ;=================================================================
 ; Return list of visits
LIST(DATA,DFN) ;
 D VISITLST^BEHOENCX(.DATA,.DFN,,,-1)
 Q
 ; Return detail view of visit
DETAIL(DATA,DFN,VST) ;
 D GETRPT^BEHOENPS(.DATA,+$$VSTR2VIS^BEHOENCX(DFN,VST))
 Q
