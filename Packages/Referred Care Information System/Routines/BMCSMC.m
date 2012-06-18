BMCSMC ; IHS/PHXAO/TMJ - calls from screenman screens ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;Routine controls the data entry field deletions & required field
 ;controls - POSTCTR - Add Referral & POSTCTRM - Modify Referral
 ;
POSTCTR ;EP called from post action on change of type of referral
 NEW BMCI,BMCV
 S BMCV=X
 I BMCV="I" F BMCI=.07,.09,.23 D PUT^DDSVAL(90001,DA,BMCI,"")
 I BMCV="N" F BMCI=.07,.08 D PUT^DDSVAL(90001,DA,BMCI,"")
 I BMCV="C" F BMCI=.08,.23 D PUT^DDSVAL(90001,DA,BMCI,"")
 I BMCV="O" F BMCI=.08,.23 D PUT^DDSVAL(90001,DA,BMCI,"")
 D REQ^DDSUTL(1,1,1.2,0)
 D REQ^DDSUTL(2,1,1.2,0)
 D REQ^DDSUTL(1,1,1.3,0)
 D REQ^DDSUTL(1,1,1.4,0)
 D REQ^DDSUTL("PRIORITY",3,1,0)
 I BMCV="C" D REQ^DDSUTL(1,1,1.2,1)
 I BMCV="I" D REQ^DDSUTL(1,1,1.4,1)
 I BMCV="N" D REQ^DDSUTL(1,1,1.3,1)
 ;I BMCV="O" D REQ^DDSUTL(2,1,1.2,1)
 I BMCV="C"!($G(BMCPRIO)) D REQ^DDSUTL("PRIORITY",3,1,1)
 Q
POSTCTRM ;EP called from post action on modify type of referral
 NEW BMCV
 S BMCV=X
 I BMCV="I" F BMCI=.07,.09,.23 D PUT^DDSVAL(90001,DA,BMCI,"")
 I BMCV="N" F BMCI=.07,.08 D PUT^DDSVAL(90001,DA,BMCI,"")
 I BMCV="C" F BMCI=.08,.23 D PUT^DDSVAL(90001,DA,BMCI,"")
 I BMCV="O" F BMCI=.08,.23 D PUT^DDSVAL(90001,DA,BMCI,"")
 D REQ^DDSUTL(1,1,1.2,0)
 D REQ^DDSUTL(2,1,1.2,0)
 D REQ^DDSUTL(1,1,1.3,0)
 D REQ^DDSUTL(1,1,1.4,0)
 D REQ^DDSUTL("PRIORITY",2,1,0)
 I BMCV="C" D REQ^DDSUTL(1,1,1.2,1)
 I BMCV="I" D REQ^DDSUTL(1,1,1.4,1)
 I BMCV="N" D REQ^DDSUTL(1,1,1.3,1)
 ;I BMCV="O" D REQ^DDSUTL(2,1,1.2,1)
 I BMCV="C"!($G(BMCPRIO)) D REQ^DDSUTL("PRIORITY",2,1,1)
 Q
FACREF ;EP - called to set caption for prov ref to
 S Y=$S($$GET^DDSVAL(90001,.DA,.09,"","I"):$$GET^DDSVAL(90001,.DA,.09,"","E"),$$GET^DDSVAL(90001,.DA,.07,"","I"):$$GET^DDSVAL(90001,.DA,.07,"","E"),$$GET^DDSVAL(90001,.DA,.08,"","I"):$$GET^DDSVAL(90001,.DA,.08,"","E"),1:"")
 Q:Y]""
 S Y=$$GET^DDSVAL(90001,.DA,.23,"","E")
 Q
 N X
PRECTRM ; EP called from pre action on BMC REFERRAL EDIT BLK 1
 ;
 ; determine whether REFERRAL TYPE field can be edited or not.
 ; if referral type is CHS and CHS authorizations exist, it cannot
 ; be modified.
 ;
 S X=BMCRTYPE
 D UNED^DDSUTL("REFERRAL TYPE",2,1,0)
 I X="C"&(BMCCHSCT>0) D UNED^DDSUTL("REFERRAL TYPE",2,1,2)
 Q
