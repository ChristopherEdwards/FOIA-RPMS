ABSPOSS8 ; IHS/FCS/DRS - 9002313.99 ;  
 ;;1.0;PHARMACY POINT OF SALE;**19,39**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;IHS/SD/RLT 11/7/06 - Patch 19
 ; Force user to run BAS setup option first.  Running other options
 ; first causes error creating the ^ABSP(9002313.99,1,0) node.
 ; 
 Q
PART1 ;EP - option ABSP SETUP PART 1 - the basic setup
 W !!,"Edit Pharmacy POS configuration",!
 W !!,"Answer with '?' for help at any question.",!
 D NEW99
 N DIE,DA,DR,DIDEL,DTOUT
 S DIE=9002313.99,DA=1
 S DR="943R~How will data be input to Point of Sale?"
 S DR=DR_";440.01R~What is the default dial-out to send claims to?"
 S DR=DR_";1501To get an outside line, what number should be dialed?"
 S DR=DR_";170.01R~What Accounts Receivable system is used?"
 D ^DIE
 ;IHS/OIT/CNI/SCR 042610 patch 39 START changes to add parameter that will keep rejects from passing to IHS 3PB
 S ABSP3PB=$P($G(^ABSP(9002313.99,1,"A/R INTERFACE")),U,1) ;'3' FOR IHS 3RD PARTY BILLING;
 I ABSP3PB=3 D
 .S DIE=9002313.99,DA=1
 .S DR="170.02R~Send POS rejected claims to 3PB/AR?"  ;IHS/OIT/CNI/SCR 042610 patch 39 add paramater to keep rejects from crossing to 3PB
 .D ^DIE
 ;IHS/OIT/CNI/SCR 042610 patch 39 END changes to add parameter that will keep rejects from passing to IHS 3PB
 W !!,"Now set up the STANDARD Pricing Formula.  (Different pricing",!
 W "policies for different insurers can be established later.)",!
 S DIE=9002313.53,DA=1
 S DR=".02R~Where do we find the UNIT PRICE of a drug?"
 S DR=DR_";.04R~Multiply the unit price by what factor (1 = 100%, .95 = 95%, etc.) ?"
 S DR=DR_";.05R~What is the default DISPENSING FEE?"
 D ^DIE
 Q
NEW99 ; create new entry in 9002313.99
 Q:$P($G(^ABSP(9002313.99,1,0)),U)]""  ; already has an entry
 N FDA,IEN,MSG
 S FDA(9002313.99,"+1,",.01)="POINT OF SALE SETUP"
 S FDA(9002313.99,"+1,",951)=30 ; insurance grace period default
N99A D UPDATE^DIE("","FDA","IEN","MSG")
 I '$D(MSG),IEN(1)=1,$D(^ABSP(9002313.99,1,0)) D  Q  ; success
 . ; Insurance base scores - default to Private primary,
 . ; Medicaid secondary, Medicare tertiary, No insurance last
 . S ^ABSP(9002313.99,1,"INS BASE SCORES")="900^300^600^300^100"
 ; Failure:
 D ZWRITE^ABSPOS("FDA","IEN","MSG")
 G N99A:$$IMPOSS^ABSPOSUE("FM","TRI","UPDATE^DIE failed",,"N99A",$T(+0))
 Q
CHK1 ;Set out of order messages on the following options
 ;if ^ABSP(9002313.99,1,0) node doesn't exist.
 ;Force user to run BAS option first.
 ;Once BAS option is run remove out of order message.
 ;Ran from ABSP SETUP MENU and ABSP SETUP PART 1 options.
 ;IHS/SD/RLT - 11/7/06 - Patch 19
 ;
 N OPTNAME,OPTCNT,OPTMSG,OPTMSG2,OPTIEN
 ;
 S OPTNAME(1)="ABSP SETUP ILC AR"
 S OPTNAME(2)="ABSP SETUP DIAL OUT MENU"
 S OPTNAME(3)="ABSP SETUP PHARMACY"
 S OPTNAME(4)="ABSP SETUP INSURANCE MENU"
 S OPTNAME(5)="ABSP SETUP USERS"
 S OPTNAME(6)="ABSP UNBILLABLE MENU"
 S OPTNAME(7)="ABSP SETUP PRICING"
 S OPTNAME(8)="ABSP SETUP MISC."
 S OPTNAME(9)="ABSP PROVIDER #S EDIT"
 ;
 I $D(^ABSP(9002313.99,1,0)) S OPTMSG="@"
 E  S OPTMSG="Basic setup NOT complete - Contact site MGR"
 ;
 F OPTCNT=1:1:9 D
 . D ^XBFMK      ;kill FileMan variables
 . S OPTIEN=0
 . S OPTIEN=$O(^DIC(19,"B",OPTNAME(OPTCNT),OPTIEN))
 . Q:OPTIEN=""
 . S OPTMSG2=$P($G(^DIC(19,OPTIEN,0)),U,3)
 . I OPTMSG'="@"&(OPTMSG2'="") Q
 . I OPTMSG'="@"&(OPTMSG2="Basic setup NOT complete - Contact site MGR") Q
 . I OPTMSG="@"&(OPTMSG2'="Basic setup NOT complete - Contact site MGR") Q
 . S DIE=19,DA=OPTIEN
 . S DR="2///^S X=OPTMSG"
 . D ^DIE
 Q
INS ;EP - option ABSP INSURANCE SEL
 N DIE,DA,DR,DIDEL,DTOUT
 S DIE=9002313.99,DA=1
 W !!,"The insurance selection ""grace period"" means that if the",!
 W "registration data shows that insurance has expired, but the",!
 W "expiration was within N days prior to the prescription fill",!
 W "date, we assume that the coverage was renewed.",!
 W "This is a system-wide default setting; you can override it later",!
 W "on an insurer-by-insurer basis.",!
 S DR="951Grace period default"
 D ^DIE
 ;
 W !!,"Enter the base scores for each insurance type.",!
 W !,"For example, if Private insurance is usually primary,",!
 W ?10,"and Medicaid is secondary and Medicare is tertiary",!
 W "then you might give Private 900 points, Medicaid 600 points,",!
 W "Medicare and Railroad each 300 points and Self pay 100 points.",!
 W !
 S DR="960.01;960.03;960.02;960.04;960.05"
 D ^DIE
 ;
 N ALLRULES,MYRULES
11 S (ALLRULES,MYRULES)=0 ; have we printed them yet?
10 W !!,"Select any additional insurance rules that might",!
 W "be needed for distinguishing among private insurances.",!
 I 'ALLRULES,$$ALLRULES D  G 10
 . D TEMPLATE^ABSPOSS2("ABSP INSURANCE RULES AVAIL",9002313.94)
 . S ALLRULES=1
 I 'MYRULES,$$MYRULES D RPTINUSE S MYRULES=1 G 10
 W !,"Usually, the plus points value for a rule is about 10 or 20",!
 W "and the minus points value is 0."
 W "If you need a new rule which isn't shown in the list,",!
 W "the Point of Sale programmer will have to add it.",!
 W "The INS RULE ORDER tells what order the rules are applied,",!
 W "from low to high.  10, 20, 30, etc. are good choices for ORDER.",!
 S DIE=9002313.99,DR=970.01,DA=1
 D ^DIE
 I $$ANYINUSE I $$MYRULES D RPTINUSE
 I $$MOREEDIT G 11
 ;
 W !!,"This concludes the system-wide insurance setup.",!
 W "Remember, there is another setup program to setup specific",!
 W "insurers with their electronic formats, insurance selection",!
 W "settings, grace period override, etc.",!
 N % R %:10,!
 Q
ANYINUSE() ;EP - ABSPOSS1
 Q $O(^ABSP(9002313.99,1,"INS RULES",0))
RPTINUSE ;EP - ABSPOSS1
 D TEMPLATE^ABSPOSS2("ABSP INSURANCE RULES IN-USE",9002313.99) Q
ALLRULES()         Q $$YESNO("Do you want to see a list of all the AVAILABLE rules")
MYRULES()          Q $$YESNO("Do you want to see a list of the rules that are IN USE now")
MOREEDIT()         Q $$YESNO("Do you want to go back and edit the rules again")
YESNO(TEXT) ;EP - ABSPOSS3
 Q $$YESNO^ABSPOSU3(TEXT,"NO",1,60)=1
