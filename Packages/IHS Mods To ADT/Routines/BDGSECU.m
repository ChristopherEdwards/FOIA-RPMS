BDGSECU ; IHS/ANMC/LJF - UPDATE SECURITY PARAMETERS ; 
 ;;5.3;PIMS;**1004**;MAY 28, 2004
 ;IHS/OIT/LJF 11/03/2005 PATCH 1004 moved message subroutine to IHS routine
 ;
CHOOSE ; ask user to choose function to perform
 NEW BDGA,Y
 S BDGA(1)=$$SP(10)_"1. Edit Security Parameters"
 S BDGA(2)=$$SP(10)_"2. Edit Mail Group Members"
 S BDGA(3)=$$SP(10)_"3. List Security Key Holders"
 S BDGA(4)=""
 S Y=$$READ^BDGF("NO^1:3","  Select Action","","","",.BDGA)
 Q:'Y  D @Y
 Q
 ;
1 ; -- call screenman to edit parameters
 NEW DA,DIC,DDR,DLAYGO,BDGERR
 ;
 ;  if no entry in MAS Parameters file, add one
 I '$D(^DG(43,1,0)) D  I $G(BDGERR) D MSG^BDGF(BDGERR) Q
 . K DD,DO S (DIC,DLAYGO)=43,DIC(0)="L"
 . S (X,DINUM)=1 D FILE^DICN
 . I Y=-1 S BDGERR="Adding to MAS Parameter file failed; contact supervisor."
 ;
 ; -- call ScreenMan to add/edit parameters
 S DDSFILE=43,DA=1,DR="[BDG SECURITY PARAMETERS]" D ^DDS
 K DDSFILE,DR
 Q
 ;
 ;
2 ; -- call screenman to edit mail group members
 ;NEW DA,DIC,DDR,DLAYGO
 ;
 S X=$O(^XMB(3.8,"B","DG MISSING NEW PERSON SSN",0))  ;mailgroup ien
 I 'X D  Q   ;mail group gone
 . D MSG^BDGF("Mail Group DG MISSING NEW PERSON SSN not in file",2,0)
 . D MSG^BDGF("Contact ITSC Help Desk for assistance",1,1)
 . D PAUSE^BDGF
 ;
 I '$O(^XMB(3.8,X,1,0)) D  ;no members in mail group
 . D MSG^BDGF("Don't forget to add members to DG MISSING NEW PERSON SSN mail group",2,0)
 ;
 ; ask user to select a mail group; screen by coordinator
 S (DIC,DLAYGO)=3.8,DIC(0)="AEMQZL"
 S DIC("S")="I ($D(^XUSEC(""XMMGR"",DUZ)))!($P($G(^XMB(3.8,+Y,0)),U,7)=DUZ)"
 S DIC("DR")="4///PU;10///0;7///n"
 W !! D ^DIC Q:Y<1
 ;
 ; -- call ScreenMan to add/edit parameters
 S DDSFILE=3.8,DA=+Y,DR="[BDG SECURITY MAIL GROUP EDIT]" D ^DDS
 K DDSFILE,DR
 Q
 ;
3 ; -- list holders of module's security keys
 D ^BDGSECU1
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;
 ;IHS/OIT/LJF 11/03/2005 PATCH 1004 added new subroutine
MSG ;EP - Warning message on sensitive patients
 ; called by PRIV^DGSEC4
 S DGSENS(5)="* This record is protected by the Privacy Act of 1974 & Health Insurance*"
 S DGSENS(6)="* Portability & Accountability Act of 1996. If you elect to proceed, you*"
 S DGSENS(7)="* must prove you have a need to know.  Access to this patient is tracked*"
 S DGSENS(8)="* and your Security Officer will contact you for your justification.    *"
 Q
