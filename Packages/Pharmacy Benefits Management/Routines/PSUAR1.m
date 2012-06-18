PSUAR1 ;BIR/PDW - Start AR/WS Extract ;11 AUG 1999
 ;;3.0;PHARMACY BENEFITS MANAGMENT;**1,8,10**;Oct 15, 1998
 ;;
 ;PSUDTDA - IEN FOR DATE
 ;PSUSDA - IEN FOR INPATIENT SITE
 ;PSUDRDA - IEN FOR DRUG
 ;PSUCDA - IEN FOR CATEGORY
 ;PSUDIV - IEN FOR DIVISION OR "NONE"
 ;
 ;DBIAs
 ; Reference to file #58.5  supported by DBIA 456
 ; Reference to file #58.1  supported by DBIA 2515
 ; Reference to file #59.4  supported by DBIA 2498
 ; Reference to file #44    supported by DBIA 2439
 ; Reference to file #40.8  supported by DBIA 2438
 ;
EN ;EP MAIN ENTRY POINT
 ;
 ;
START ;Start date scan thru stats file
 S PSUSDT=PSUSDT-.1
 S PSUDT=PSUSDT
 S PSUEDT=PSUEDT\1+.24
Q F  S PSUDT=$O(^PSI(58.5,"B",PSUDT)) Q:'PSUDT  Q:PSUDT>PSUEDT  D DATE Q:$G(PSUQUIT)
 Q
DATE ;PROCESS ONE DATE - Loop through inpatient sites
 S PSUDTDA=$O(^PSI(58.5,"B",PSUDT,0))
 K PSUSITE
 D GETM^PSUTL(58.5,PSUDTDA,"1*^.01","PSUSITE")
 S PSUSDA=0
 F  S PSUSDA=$O(PSUSITE(PSUSDA)) Q:PSUSDA'>0  D SITE Q:$G(PSUQUIT)
 K PSUSITE
 Q
 ;
SITE ;Process one site for one date
 ; Find division for site for loading drug stats
 S PSUDIV=$$DIV(PSUSDA,PSUDTDA)
 ;
 I PSUDIV="NULL" S PSUDIV=PSUSNDR
 ;
 ;    Process individual Drug information from 58.52
 ;    Drug multiple loaded into PSUDRUG
 K PSUDRUG
 D GETM^PSUTL(58.501,"PSUDTDA,PSUSDA","2*^.01","PSUDRUG")
 S PSUDRDA=0
 F  S PSUDRDA=$O(PSUDRUG(PSUDRDA)) Q:PSUDRDA'>0  D DRUG Q:$G(PSUQUIT)
 K PSUDRUG
 ;
 ;    Process Amis categories from 58.501
 ;    Category multiple loaded into PSUCAT
 K PSUCAT
CATEGORY ;EP Pull Categories
 K PSUAMCAT
 D GETM^PSUTL(58.501,"PSUDTDA,PSUSDA","1*^.01;1;2;3;4","PSUAMCAT","I")
 ;
 ;    Move (da,Fld,"I") values to (da,Fld) nodes
 D MOVEMI^PSUTL("PSUAMCAT")
 ;
 ;   Gather totals for categories and accumulate in
 ;   ^XTMP(PSUARSUB,"DIV_CAT",PSUDIV,PSUAMCAT,"DISP":COST")
 N PSUDISP,PSUCOST
 S PSUCDA=0 F  S PSUCDA=$O(PSUAMCAT(PSUCDA)) Q:PSUCDA'>0  D
 . S PSUDISP=PSUAMCAT(PSUCDA,1)-PSUAMCAT(PSUCDA,3)
 . S PSUCOST=PSUAMCAT(PSUCDA,2)-PSUAMCAT(PSUCDA,4)
 . S PSUAMCAT=PSUAMCAT(PSUCDA,.01) ; "03"-"04"-"06" etc
 . S X=$G(^XTMP(PSUARSUB,"DIV_CAT",PSUDIV,PSUAMCAT,"DISP"))
 . S ^XTMP(PSUARSUB,"DIV_CAT",PSUDIV,PSUAMCAT,"DISP")=X+PSUDISP
 . S X=$G(^XTMP(PSUARSUB,"DIV_CAT",PSUDIV,PSUAMCAT,"COST"))
 . S ^XTMP(PSUARSUB,"DIV_CAT",PSUDIV,PSUAMCAT,"COST")=X+PSUCOST
 ;
 Q
 ;
DRUG ;  Process one drug for one site for one day
 ;  Load & loop categories within Drug
 ;  total dispense & returns
 ;  Category multiple loaded into PSUCAT
 ;
 S PSUDRIEN=$$VALI^PSUTL(58.52,"PSUDTDA,PSUSDA,PSUDRDA",.01)
 K PSUCAT
 D GETM^PSUTL(58.52,"PSUDTDA,PSUSDA,PSUDRDA","1*^.01;1","PSUCAT","I")
 ;
 S PSUCDA=0,PSUDISP=0
 F  S PSUCDA=$O(PSUCAT(PSUCDA)) Q:PSUCDA'>0  Q:$G(PSUQUIT)  D
 . S X=PSUCAT(PSUCDA,.01,"I")
 . S Y=PSUCAT(PSUCDA,1,"I")
 . I (X="A")!(X="W") S PSUDISP=PSUDISP+Y
 . I (X="RA")!(X="RW") S PSUDISP=PSUDISP-Y
 ;  Adjust accumulative dispenses
 ;
 S X=$G(^XTMP(PSUARSUB,"DIV_DRUG",PSUDIV,PSUDRIEN))
 S ^XTMP(PSUARSUB,"DIV_DRUG",PSUDIV,PSUDRIEN)=X+PSUDISP
 K PSUCAT
 Q
DIV(PSUSDA,PSUDTDA) ;EP process for a site the associated divisions by date.
 ; uses PSUSDA as entry for site ien in file 59.4 : returns division
 ; as of 2/99 date is no longer used as a parameter
 N PSUDIV,PSUDT
 I '$D(^XTMP(PSUARSUB,"DIVLK",PSUSDA)) D AOU
 ; ^XTMP(PSUARSUB,"DIVlk",Site IEN, AOU Inactive Date -1)=Division IEN
 ;
 ; if AOU did not set division then return null 
 I '$D(^XTMP(PSUARSUB,"DIVLK",PSUSDA)) S PSUDIV="NULL" Q PSUDIV
 ;
 S PSUDIV=$O(^XTMP(PSUARSUB,"DIVLK",PSUSDA,""))
 Q PSUDIV
 ;
AOU ;EP map divisions by dates for  inpatient sites from the AOU file
 ;PSUADA - ien for AOU Stock file
 ;
 N PSUSDA,PSUADA,PSUDIV,PSUINACT,PSUDIV,PSUSLOC
 ;
 K ^XTMP(PSUARSUB,"DIVLK")
 S PSUADA=0
 F  S PSUADA=$O(^PSI(58.1,PSUADA)) Q:PSUADA'>0  D
 . S PSUSDA=$$VALI^PSUTL(58.1,PSUADA,4)
 . S PSUSLOC=$$VALI^PSUTL(59.4,PSUSDA,.01)
 . S PSUINACT=$$VALI^PSUTL(58.1,PSUADA,3)
 . I PSUINACT Q  ; inactivated sites are to be ignored regardles of date
 . S:'PSUINACT PSUINACT=DT+1
 . ; look into the multiple for links to get to division
 . N PSUDIV S PSUDIV=""
 . S PSUDIVX=0 F  S PSUDIVX=$O(^PSI(58.1,PSUADA,2,PSUDIVX)) Q:'PSUDIVX  Q:+$G(PSUDIV)  D
 .. S PSUDIV=$$VALI^PSUTL(58.14,"PSUADA,PSUDIVX",.01)
 .. S PSUDIV=$$VALI^PSUTL(44,PSUDIV,3.5)
 .. S PSUDIV=$$VALI^PSUTL(40.8,PSUDIV,1)
 . S:$G(PSUDIV) ^XTMP(PSUARSUB,"DIVLK",PSUSDA,PSUDIV)=""  ;  set ^TMP NODE
 ; Clear out node if multiple divisions exist for a single 
 ; inpatient site but leave a footprint so a recalc at every 
 ; record wont have to be done.
 S PSUSDA=0
 F  S PSUSDA=$O(^TMP(PSUARSUB,$J,"DIVLK",PSUSDA)) Q:PSUSDA'>0  D
 . S PSUDIV="",PSUDIVC=0
 . F  S PSUDIV=$O(^TMP(PSUARSUB,$J,"DIVLK",PSUSDA,PSUDIV)) Q:'$L(PSUDIV)  S PSUDIVC=$G(PSUDIVC)+1
 . ; if counter '=1 notate DIV=NULL
 . I PSUDIVC'=1 D
 .. K ^TMP(PSUARSUB,$J,"DIVLK",PSUSDA)
 .. S ^TMP(PSUARSUB,$J,"DIVLK",PSUSDA,"NULL")=""
 Q
 ;
CLEAR ;EP Clear ^XTMP("PSUAR*")
 S X="PSUAR",Y=X
 F  S Y=$O(^XTMP(Y)) Q:($E(Y,1,5)'=X)  W !,Y K ^XTMP(Y)
 Q
