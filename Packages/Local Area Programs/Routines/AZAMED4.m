BMEMED4 ; IHS/PHXAO/TMJ - Add Non Auto Eligibles to Medicaid File ; [ 06/11/03  3:29 PM ]
 ;
 ;This Routine is used to Manually Compare and Automatically
 ;update Patient Registration.  The compare of Patients residing
 ;in the Temporary Monthly No Match File against RPMS Patient
 ;Registration allows the User to Update Medicaid Eligibility
 ;File upon comparison.
 ;
 ;
 W @IOF
A ; -- driver
 D LOOK I IEN<1 D END Q
 D DISP,PCHK I DFN<1 G A
 D DISP,DIQ2
 I $$SAME,$$MERGE D UPD
 G A
 ;
LOOK ; -- ask patient to check for eligibility do lookup
 W !! K DIC S DIC="^AZAMED(",DIC(0)="AEMQZ"
 S DIC("A")="Please enter MEDICAID ROSTER Patient Name: "
 D ^DIC S IEN=+Y K DIC Q
 ;
DISP ; -- display all information to the user
 W @IOF,!,"Medicaid Eligibility Roster Data",!
 K DIC S DIC="^AZAMED(",DA=IEN D EN^DIQ K DIC,DA,DR Q
 ;
DIQ2 ; -- display all information to the user
 W !!,"RPMS patient file entry",!
 N N S N=^DPT(DFN,0) W !,$P(N,U),?32,$P(N,U,2),?34,$P(N,U,9)
 ;W ?46,"HRCN: ",$$HRCN^ADGF S Y=$P(N,U,3) X ^DD("DD") W !,"DOB: ",Y
 W ?46,"HRCN: ",$$HRCN^AZAMED S Y=$P(N,U,3) X ^DD("DD") W !,"DOB: ",Y  ;IHS/ANMC/LJF 1/21/99 keep calls within namespace
 S N=$G(^DPT(DFN,.11)) W ?20,$P(N,U,4),"  ",$$ST Q
 ;
ST() ; -- state
 Q $P($G(^DIC(5,+$P(N,U,5),0)),U)
 ;
SAME() ; -- ask user if patient's are the same
 W !! N X,Y,DIR S DIR(0)="Y",DIR("A")="Are these the same patient "
 S DIR("B")="Y" D ^DIR  Q $S($D(DIRUT):0,'Y:0,1:1)
 ;
MERGE() ; -- merge
 W ! N X,Y,DIR S DIR(0)="Y",DIR("A")="Update the RPMS Medicated Eligibility File"
 S DIR("B")="N" D ^DIR  Q $S($D(DIRUT):0,'Y:0,1:1)
 ;
PCHK ; -- look up patient in patient file
 N X,Y K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQZ"
 S DIC("A")="Please enter RPMS Patient Name: " D ^DIC S DFN=+Y K DIC Q
 ;
UPD ; -- update ssn and medicaid eligible
 S N=^AZAMED(IEN,0),SSN=$P(N,U,10) D:SSN
 . ;Q:$O(^DPT("SSN",SSN,0))  
 . ;S DIE="^DPT(",DA=DFN,DR=".09///"_SSN N N,SSN D ^DIE
 D INS
 S EBD=+N,EED=$P(N,U,9),CT=$P(N,U,8),NUM=$P(N,U,6),NAME=$P(N,U,2)
 S MDOB=$P(N,U,4) ; Medicaid Date of Birth 10/12/02
 S SEX=$P(N,U,3),MRATE=$P(N,U,13) W !,"I am updating the Medicaid Eligibility File now. "
 D NEW,UP0,MED
 Q
 ;         
END ; -- cleanup
 K DA,DFN,EBD,EED,CT,SSN,IEN,E,X,Y,N
 Q
 ;
 ;
INS ;GET ARIZONA MEDICAID INTERNAL NUMBER FROM THE INSURER FILE-PHX AREA
 S DIC="^AUTNINS(",DIC(0)="XZIMO",X="ARIZONA MEDICAID" D ^DIC
 I Y'=-1 S INS=$P(Y,"^",1)
 E  U IO(0) W !!,*7,"ERROR IN INSURER FILE..." G END
 Q
 ;
 ;
MED ; -- add eligiblity date(s)/data
 S IEN=$O(^AUPNMCD("B",DFN,0)) Q:'IEN
 Q:$P($G(^AUPNMCD(IEN,11,EBD,0)),U,2)=EED  ;Quit if Both Beg/End Match already
 S:'$D(^AUPNMCD(IEN,11,0)) $P(^(0),U,2)="9000004.11D"
 S LSTEBD=$P($G(^AUPNMCD(IEN,11,0)),U,3) ;Last Beg Date entered
 I LSTEBD="" D
 . S $P(^AUPNMCD(IEN,11,0),U,3)=EBD 
 . S $P(^AUPNMCD(IEN,11,0),U,4)=$P(^(0),U,4)+1
 . S DR=".01///"_EBD_";.03////"_CT ; Add Beginning DT Only
 . S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=EBD D ^DIE K DIE,DR,DA
 . I NEWADD=0 D UPDATES^AZAMSTR ;Update Count-Update Master List
 I LSTEBD'="" D
 . S SENDDT=$P($G(^AUPNMCD(IEN,11,LSTEBD,0)),U,2)
 . I SENDDT'="" S DR=".01///"_EBD_";03////"_CT ; Add Beg DT Only
 . I SENDDT'="" S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=EBD D ^DIE K DIE,DR,DA I NEWADD=0 D UPDATES^AZAMSTR Q
 . D STILLACT^AZAMSTR ;Existing Patient fell through-Still Active Only/no Update
 Q
 ;
NEW ; -- create new entry in medicaid eligible
 S NEWADD=0 ;Set Variable for New Record Add
 Q:$O(^AUPNMCD("B",+DFN,0))  ;Quit if already in Medicaid Eligibility File
 N X,Y S X=DFN,DIC="^AUPNMCD(",DIC(0)="L"
 S DIC("DR")=".02////"_INS_";.03////"_NUM_";.04////3;2101////"_NAME
 S DIC("DR")=DIC("DR")_";.07////"_SEX_";.08////"_DT_";.12////"_MRATE_";2102////"_MDOB
 ;
 K DD,DO
 D FILE^DICN S IEN=+Y K DIC
 D NEW^AZAMSTR
 S NEWADD=1
 Q
 ;
UP0 ; -- update 0th node - Patient Demographics Only
 S IEN=$O(^AUPNMCD("B",DFN,0)) Q:'IEN
 S:'$P(^AUPNMCD(IEN,0),U,2) $P(^AUPNMCD(IEN,0),U,2)=INS
 S:'$P(^AUPNMCD(IEN,0),U,3) $P(^AUPNMCD(IEN,0),U,3)=NUM
 S:'$P(^AUPNMCD(IEN,0),U,4) $P(^AUPNMCD(IEN,0),U,4)=3
 S DIE="^AUPNMCD(",DA=IEN,DR="2101////"_NAME_";.08////"_DT_";.12////"_MRATE_";2102////"_MDOB
 D ^DIE K DIE,DR,DA
 Q
 ;
