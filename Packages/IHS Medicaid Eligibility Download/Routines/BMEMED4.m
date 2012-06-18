BMEMED4 ; IHS/PHXAO/TMJ - Add Non Auto Eligibles to Medicaid File ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
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
 D LOOK I BMEIEN<1 D END Q
 D DISP,PCHK I DFN<1 G A
 D DISP,DIQ2
 I $$SAME,$$MERGE D UPD
 G A
 ;
LOOK ; -- ask patient to check for eligibility do lookup
 W !! K DIC S DIC="^BMETMED(",DIC(0)="AEMQZ"
 S DIC("A")="Please enter MEDICAID ROSTER Patient Name: "
 D ^DIC S BMEIEN=+Y K DIC Q
 ;
DISP ; -- display all information to the user
 W @IOF,!,"Medicaid Eligibility Roster Data",!
 K DIC S DIC="^BMETMED(",DA=BMEIEN D EN^DIQ K DIC,DA,DR Q
 ;
DIQ2 ; -- display all information to the user
 W !!,"RPMS patient file entry",!
 N BMEREC S BMEREC=^DPT(DFN,0) W !,$P(BMEREC,U),?32,$P(BMEREC,U,2),?34,$P(BMEREC,U,9)
 W ?46,"HRCN: ",$$HRCN^BMEMED S Y=$P(BMEREC,U,3) X ^DD("DD") W !,"DOB: ",Y
         S BMEREC=$G(^DPT(DFN,.11)) W ?20,$P(BMEREC,U,4),"  ",$$ST Q
 ;
ST() ; -- state
 Q $P($G(^DIC(5,+$P(BMEREC,U,5),0)),U)
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
 S BMEREC=^BMETMED(BMEIEN,0),SSN=$P(BMEREC,U,10) D:SSN
 . ;Q:$O(^DPT("SSN",SSN,0))  
 . ;S DIE="^DPT(",DA=DFN,DR=".09///"_SSN N N,SSN D ^DIE
 D INS
 S BMEMEBD=+BMEREC,BMEMEED=$P($G(BMEREC),U,9),BMECOVTP=$P(BMEREC,U,8),BMENUM=$P(BMEREC,U,6),BMENAME=$P(BMEREC,U,2)
 S BMEMDOB=$P(BMEREC,U,4) ; Medicaid Date of Birth 10/12/02
 S BMESEX=$P(BMEREC,U,3),BMEMRATE=$P(BMEREC,U,13) W !,"I am updating the Medicaid Eligibility File now. "
 D NEW,UP0,MED
 Q
 ;         
END ; -- cleanup
 K DA,DFN,BMEMEBD,BMEMEED,BMECOVTP,SSN,BMEIEN,E,X,Y,N
 Q
 ;
 ;
INS ;GET ARIZONA MEDICAID INTERNAL NUMBER FROM THE INSURER FILE-PHX AREA
 S DIC="^AUTNINS(",DIC(0)="XZIMO",X="MEDICAID" D ^DIC
 I Y'=-1 S BMEINS=$P(Y,"^",1)
 E  U IO(0) W !!,*7,"ERROR IN INSURER FILE..." G END
 Q
 ;
 ;
MED ; -- add eligiblity date(s)/data
 S BMEIEN=$O(^AUPNMCD("B",DFN,0)) Q:'BMEIEN
 ;Q:$P($G(^AUPNMCD(BMEIEN,11,BMEMEBD,0)),U,2)=BMEMEED  ;Quit if Both Beg/End Match already - 834 No longer has Ending Date
 S:'$D(^AUPNMCD(BMEIEN,11,0)) $P(^(0),U,2)="9000004.11D"
 S BMELEBD=$P($G(^AUPNMCD(BMEIEN,11,0)),U,3) ;Last Beg Date entered
 I BMELEBD="" D
 . S $P(^AUPNMCD(BMEIEN,11,0),U,3)=BMEMEBD
 .       . S $P(^AUPNMCD(BMEIEN,11,0),U,4)=$P(^(0),U,4)+1
 . S DR=".01///"_BMEMEBD_";.03////"_BMECOVTP ; Add Beginning DT Only
 . S DIE="^AUPNMCD("_BMEIEN_",11,",DA(1)=BMEIEN,DA=BMEMEBD D ^DIE K DIE,DR,DA
 . I BMENEW=0 D UPDATES^BMEMSTR ;Update Count-Update Master List
 I BMELEBD'="" D
 . S BMELEED=$P($G(^AUPNMCD(BMEIEN,11,BMELEBD,0)),U,2)
 . I BMELEED'="" S DR=".01///"_BMEMEBD_";03////"_BMECOVTP ; Add Beg DT Only
 . I BMELEED'="" S DIE="^AUPNMCD("_BMEIEN_",11,",DA(1)=BMEIEN,DA=BMEMEBD D ^DIE K DIE,DR,DA I BMENEW=0 D UPDATES^BMEMSTR Q
 . D STILLACT^BMEMSTR ;Existing Patient fell through-Still Active Only/no Update
 Q
 ;
NEW ; -- create new entry in medicaid eligible
 D ^XBFMK K DIADD,DINUM
 S BMENEW=0 ;Set Variable for New Record Add
 Q:$O(^AUPNMCD("B",+DFN,0))  ;Quit if already in Medicaid Eligibility File
 N X,Y S X=DFN,DIC="^AUPNMCD(",DIC(0)="L"
 S DIC("DR")=".02////"_BMEINS_";.03////"_BMENUM_";.04////"_3_";2101////"_BMENAME
 S DIC("DR")=DIC("DR")_";.07////"_BMESEX_";.08////"_DT_";.12////"_BMEMRATE_";2102////"_BMEMDOB
 ;
 K DD,DO
 D FILE^DICN S BMEIEN=+Y K DIC
 D NEW^BMEMSTR
 S BMENEW=1
 Q
 ;
UP0 ; -- update 0th node - Patient Demographics Only
 S BMEIEN=$O(^AUPNMCD("B",DFN,0)) Q:'BMEIEN
 S:'$P(^AUPNMCD(BMEIEN,0),U,2) $P(^AUPNMCD(BMEIEN,0),U,2)=BMEINS
 S:'$P(^AUPNMCD(BMEIEN,0),U,3) $P(^AUPNMCD(BMEIEN,0),U,3)=BMENUM
 S:'$P(^AUPNMCD(BMEIEN,0),U,4) $P(^AUPNMCD(BMEIEN,0),U,4)=3
 S DIE="^AUPNMCD(",DA=BMEIEN,DR="2101////"_BMENAME_";.08////"_DT_";.12////"_BMEMRATE_";2102////"_BMEMDOB
 D ^DIE K DIE,DR,DA
 Q
 ;
