BDGICE ; IHS/ANMC/LJF - INCOMPLETE CHART EDIT ;  [ 08/20/2004  11:44 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
 ;
PAT ; ask user for patient
 NEW DFN D KILL^AUPNPAT
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select Patient") Q:DFN<1
 ;
 ; find all entries in IC file for patient (except deleted ones)
 NEW BDGN,COUNT,BDGA,I
 S BDGN=0
 F  S BDGN=$O(^BDGIC("B",DFN,BDGN)) Q:'BDGN  D
 . Q:$$GET1^DIQ(9009016.1,BDGN,.17)]""    ;quit if deleted
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=BDGN
 ;
 ; display results of search for patient IC entries
 I '$D(BDGA) D ADD,PAT Q
 ;
 W !!,"Incomplete Chart Entries for "_$$GET1^DIQ(2,DFN,.01)_":"
 F I=1:1 Q:'$D(BDGA(I))  W !,$J(I,3),?6,$$GET1^DIQ(9009016.1,BDGA(I),.02),$$GET1^DIQ(9009016.1,BDGA(I),.05),?30,$$GET1^DIQ(9009016.1,BDGA(I),.0392)
 ;IHS/ITSC/WAR 3/18/03 - Fixed typo(?) P55 WAR14
 ;  The 'FOR' loop Quits if '$D(BDGA(I)) which means 'I' has been incrmt
 ;W !,$J(I+3,3),?6,"ADD NEW ENTRY"
 W !,$J(I,3),?6,"ADD NEW ENTRY"
 S Y=$$READ^BDGF("NO^1:"_(COUNT+1),"Select Discharge Date")
 I Y=(COUNT+1) D ADD,PAT Q
 I Y>0 S BDGN=BDGA(Y) D SCREEN
 D PAT Q
 ;
 ;
SCREEN ; -- call ScreenMan to add/edit parameters
 NEW DDSFILE,DA,DR,TYPE
 S TYPE=$$GET1^DIQ(9009016.1,BDGN,.0392)
 S DDSFILE=9009016.1,DA=BDGN
 ;S DR=$S(TYPE["HOS":"[BDG INCOMPLETE EDIT]",1:"[BDG DAY SURGERY EDIT]"
 S DR=$S(TYPE["DAY":"[BDG DAY SURGERY EDIT]",1:"[BDG INCOMPLETE EDIT]")   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 D ^DDS
 Q
 ;
ADD ; -- add new entry
 S Y=$$READ^BDGF("SO^1:Inpatient;2:Day Surgery","Select TYPE of Visit to Add") Q:Y<1
 NEW DIC,DA,DR,X,DD,DO
 S DIC="^BDGIC(",DIC(0)="L",DLAYGO=9009016.1,X=DFN
 S APCDOVRR=1
 ;I Y=1 S DIC("DR")=".02;.03;.04"   ;inpt
 ;I Y=2 S DIC("DR")=".05;.03;.04"   ;ds
 I Y=1 S DIC("DR")=".02R;.03R;.04R"   ;inpt ;IHS/ITSC/LJF 12/11/2003
 I Y=2 S DIC("DR")=".05R;.03R;.04R"   ;ds   ;IHS/ITSC/LJF 12/11/2003
 D FILE^DICN Q:Y<1
 K APCDOVRR
 ;
 S BDGN=+Y D SCREEN
 Q
 ;
EDIT ;EP; -- edit visit by supervisor
 ;called by BDGIC EDIT VISIT option
 NEW APCDOVRR,DIE,DA,DR
 S DIC="^BDGIC(",DIC(0)="AEMQZ" D ^DIC Q:Y<1
 S APCDOVRR=1
 S DIE="^BDGIC(",DR=".03",DA=+Y
 D ^DIE,EDIT
 Q
