APCDPLST ;IHS/CMI/LAB - UPDATE ICD CODE FROM BSTS
 ;;2.0;IHS PCC SUITE;**16**;MAY 14, 2009;Build 9
 ;; ;
 ;
 W !!,"This option is used to update the Status field on Problem List"
 W !,"based on the default status associated with the SNOMED term.",!!
 W !,"You will be given the opportunity to select which status group",!
 W "will be updated."
 W !,"Notes:"
 W !,?2,"- Update all Chronic:  this will loop through the problems on"
 W !?2,"  the IPL and for any problem whose Concept ID is defaulted to Chronic "
 W !?2,"  in DTS, change to Chronic on IPL.  Problems on the IPL with a status "
 W !?2,"  of inactive will be skipped and the status will not be changed."
 ;W !,?2,"- Update all Sub-Acute:  this will loop through the problems on"
 ;W !?2,"  the IPL and for any problem whose Concept ID is defaulted to Sub-Acute "
 ;W !?2,"  in DTS, change to Sub-Acute on IPL.  Problems on the IPL with a status "
 ;W !?2,"  of Inactive or Chronic will be skipped and the status will not be changed."
 W !,?2,"- Update all Social/Environmental:  this will loop through the problems on"
 W !?2,"  the IPL and for any problem whose Concept ID is defaulted to "
 W !?2,"  Social/Environmental in DTS, change to Social/Environmental on IPL.  "
 W !?2,"  Problems on the IPL with a status of Inactive or Chronic will be skipped"
 W !?2,"  and the status will not be changed."
 W !,?2,"- Update all Routine/Admin:  this will loop through the problems on"
 W !?2,"  the IPL and for any problem whose Concept ID is defaulted to Routine/Admin "
 W !?2,"  in DTS, change to Routine/Admin on IPL.  Problems on the IPL with a status "
 W !?2,"  of Inactive will be skipped and the status will not be changed."
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 ;WHICH ONES SHOULD BE UPDATED
 K DIR
 S DIR(0)="S^C:Chronic Status Concept IDs;O:Social/Environmental Concept IDs;R:Routine/Admin Concept IDs;A:All of these Types",DIR("A")="Update which Problem's Status" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I Y="" D XIT Q
 S APCDPLT=Y
 W !!,"Hold on..this may take a few minutes.."
 D QUEUE
 D XIT
 Q
XIT ;
 D EN^XBVK("APCD")
 K ^TMP($J)
 Q
SETSUB ;
 S X=$$SUBLST^BSTSAPI(OUT,IN)
 ;SET UP INDEX
 S Y=0 F  S Y=$O(^TMP($J,APCDS,Y)) Q:Y'=+Y  D
 .S X=$P(^TMP($J,APCDS,Y),U,1)
 .S ^TMP($J,"I",X,APCDS)=""
 .Q
 Q
QUEUE ;EP
 W !!,"Gathering up subsets..."
 ;GATHER UP THE SUBSET LISTS
 NEW OUT,IN,C,J,Y,X,I
 K ^TMP($J)
 I APCDPLT="C"!(APCDPLT="A") S OUT=$NA(^TMP($J,"A")),IN="EHR IPL DEFAULT STATUS CHRONIC",APCDS="A" D SETSUB
 ;I APCDPLT="S"!(APCDPLT="A") S OUT=$NA(^TMP($J,"S")),IN="EHR IPL DEFAULT STATUS SUB",APCDS="S" D SETSUB
 I APCDPLT="O"!(APCDPLT="A") S OUT=$NA(^TMP($J,"O")),IN="EHR IPL DEFAULT STATUS SOCIAL",APCDS="O" D SETSUB
 I APCDPLT="R"!(APCDPLT="A") S OUT=$NA(^TMP($J,"R")),IN="EHR IPL DEFAULT STATUS ADMIN",APCDS="R" D SETSUB
 I '$D(ZTQUEUED) W !!,"Looping through Problem entries....."
 ;
 S APCDX=0,APCDCNT=0
 F  S APCDX=$O(^AUPNPROB(APCDX)) Q:APCDX'=+APCDX  D
 .S APCDCNT=APCDCNT+1
 .W:'(APCDCNT#1000) "."
 .Q:'$D(^AUPNPROB(APCDX,0))
 .S APCDCI=$P($G(^AUPNPROB(APCDX,800)),U)  ;only snomed coded problems
 .Q:APCDCI=""
 .S APCDCS=$P(^AUPNPROB(APCDX,0),U,12) ;current status
 .Q:APCDCS="D"  ;SKIP DELETED PROBLEMS
 .Q:APCDCS="I"  ;SKIP INACTIVE PROBLEMS PER SUSAN
 .;CHECK EACH ONE
 .;get this snomed's default status
 .S APCDDEF=$O(^TMP($J,"I",APCDCI,""))
 .Q:APCDDEF=""  ;NO DEFAULT SO SKIP THIS PROBLEM
 .I APCDCS=APCDDEF Q  ;STATUS IS ALREADY THE DEFAULTED STATUS SO DON'T BOTHER
 .I APCDPLT="C"!(APCDPLT="A"),APCDDEF="A" D CS Q  ;IF WANT TO CHANGE CHRONICS AND THIS IS CHRONIC CHANGE IT
 .;I APCDPLT="S"!(APCDPLT="A"),APCDDEF="S",APCDCS'="A" D CS Q  ;IF WANT TO CHANGE SUBACUTES AND THIS IS SUBACUTE CHANGE IT EXCEPT IF IT IS CHRONIC
 .I APCDPLT="O"!(APCDPLT="A"),APCDDEF="O",APCDCS'="A" D CS Q  ;IF WANT TO CHANGE SOCIAL AND THIS IS SOCIAL CHANGE IT EXCEPT IF IT IS CHRONIC
 .I APCDPLT="R"!(APCDPLT="A"),APCDDEF="R" D CS Q  ;IF WANT TO CHANGE ROUTINE/ADMIN AND THIS IS ROUTINE/ADMIN CHANGE IT EXCEPT IF IT IS CHRONIC
 Q
CS ;update status .12 and update PROBLEM entry and the change log
 S APCDOLDS=APCDCS
 K DIE,DA,DR
 S DIE="^AUPNPROB(",DA=APCDX,DR=".12///"_APCDDEF D ^DIE K DIE,DA,DR
 ;update my log to save my ....
 K DIC,DD,D0,DO,DO
 S DIADD=1,DLAYGO=9001040.1,DIC(0)="L",DIC="^APCDPLMD("
 S X=DT,DIC("DR")=".02////"_APCDX_";.07////9000011;.08////"_APCDCI_";1301///"_APCDCS_";1302///"_APCDDEF
 D FILE^DICN
 K DIC,DIADD,DLAYGO
 S APCDLOGE=+Y
 Q
SETE ;
 S DA=APCDLOGE,DIE="^APCDPLMD(",DR="1///"_ERR("DIERR",1)
 Q
