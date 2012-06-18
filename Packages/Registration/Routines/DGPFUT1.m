DGPFUT1 ;ALB/RBS - PRF UTILITIES CONTINUED ; 7/21/03 12:29pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 Q  ;no direct entry
 ;
DISPACT(DGPFAPI) ;Display all ACTIVE Patient Record Flag's for a patient
 ; Input:   DGPFAPI() = Array of patients active flags
 ;                      (passed by reference)
 ;                      See $$GETACT^DGPFAPI for array format.
 ; Output:  None
 ;
 I '$G(DGPFAPI) Q  ;no flags
 ;
 N DGPF,DGPFIEN,DGPFFLAG,DGPFCAT,IORVON,IORVOFF
 W !!,">>> Active Patient Record Flag(s):"
 ;
 ; setup for reverse video display
 ;
 S (IORVON,IORVOFF)=""
 D:$D(IOST(0))
 . N X S X="IORVON;IORVOFF" D ENDR^%ZISS
 ;
 ; loop all returned Active Record Flag Assignment ien's
 S DGPFIEN="" F  S DGPFIEN=$O(DGPFAPI(DGPFIEN)) Q:DGPFIEN=""  D
 . S DGPFFLAG=$P($G(DGPFAPI(DGPFIEN,"FLAG")),U,2)
 . Q:(DGPFFLAG'["")
 . S DGPFCAT=$P($P($G(DGPFAPI(DGPFIEN,"CATEGORY")),U,2)," ")
 . W !?5,IORVON,"<"_DGPFFLAG_">",IORVOFF,?45,"CATEGORY ",DGPFCAT
 W !
 Q
 ;
ASKDET(DGPFOUT) ; Prompt to ask User for Displaying Flag Details
 ; Input:   None
 ; Output:  1 = Yes, view flag details
 ;          0 = No, quit
 ;    DGPFOUT = [Optional] Returns 1 if Timeout or Up-arrow
 ;
 N DIR,X,Y,DIRUT,DTOUT,DUOUT,DIROUT
 S DIR(0)="Y",DIR("B")="YES"
 S DIR("A")="Do you wish to view active patient record flag details"
 D ^DIR
 S DGPFOUT=$S(+$G(DIRUT):1,1:0)  ;timeout or up-arrow
 W:(+Y'=1) !
 Q $S(+Y'=1:0,1:1)
 ;
DISPDET(DGPFAPI) ; Display the details of patients Active record flags
 ;
 ; Input:   DGPFAPI() = Array of patients active flags
 ;                      (passed by reference)
 ;                      See $$GETACT^DGPFAPI for array format.
 ; Output:  None
 ;
 I '$G(DGPFAPI) Q  ;no flags
 ;
 N DGPFI,DGPFQ,DGPFIEN,DGPFFLAG,IORVON,IORVOFF,DIRUT,DUOUT,DTOUT,X
 ;
 S (IORVON,IORVOFF)=""
 D:$D(IOST(0))
 . N X S X="IORVON;IORVOFF" D ENDR^%ZISS
 ;
 ; loop all returned Active Record Flag Assignment ien's
 S (DGPFIEN,DGPFQ)=""
 F  S DGPFIEN=$O(DGPFAPI(DGPFIEN)) Q:DGPFIEN=""  D  Q:DGPFQ
 . S DGPFFLAG=$P($G(DGPFAPI(DGPFIEN,"FLAG")),U,2)
 . Q:(DGPFFLAG'["")
 . I $G(DGPFQ)=0 W ! S DGPFQ='$$CONTINUE^DGPFUT() Q:DGPFQ
 . S DGPFQ=0
 . W:$E(IOST,1,2)="C-" @IOF
 . W !?11,"Flag Name: ",IORVON,"<"_DGPFFLAG_">",IORVOFF
 . W !?11,"Flag Type: ",$P($G(DGPFAPI(DGPFIEN,"FLAGTYPE")),U,2)
 . W !?7,"Flag Category: ",$P($G(DGPFAPI(DGPFIEN,"CATEGORY")),U,2)
 . W !?3,"Assignment Status: ACTIVE"
 . W !?2,"Initial Assignment: ",$P($G(DGPFAPI(DGPFIEN,"ASSIGNDT")),U,2)
 . W !?9,"Approved By: ",$P($G(DGPFAPI(DGPFIEN,"APPRVBY")),U,2)
 . W !?4,"Next Review Date: ",$P($G(DGPFAPI(DGPFIEN,"REVIEWDT")),U,2)
 . W !?10,"Owner Site: ",$P($G(DGPFAPI(DGPFIEN,"OWNER")),U,2)
 . W !?4,"Originating Site: ",$P($G(DGPFAPI(DGPFIEN,"ORIGSITE")),U,2)
 . W !,"Assignment Narrative:",!,"---------------------"
 . I $D(DGPFAPI(DGPFIEN,"NARR",1,0)) D
 . . S DGPFI=""
 . . F  S DGPFI=$O(DGPFAPI(DGPFIEN,"NARR",DGPFI)) Q:DGPFI=""  D  Q:DGPFQ
 . . . I $Y>(IOSL-3) S DGPFQ='$$CONTINUE^DGPFUT() Q:DGPFQ  S $Y=2
 . . . W !,$G(DGPFAPI(DGPFIEN,"NARR",DGPFI,0))
 ;
 W !!,IORVON,"<END OF RECORD FLAG DISPLAY>",IORVOFF,!
 N DIR,X,Y,DIRUT,DTOUT,DUOUT,DIROUT
 S DIR("A")="Enter RETURN to continue",DIR(0)="E"
 D ^DIR K DIR
 W !
 Q
 ;
DISPPRF(DGDFN) ; Patient Record Flags screen Display
 ;
 ; Input:  
 ;   DGDFN - pointer to patient in PATIENT (#2) file
 ;
 ; Output:
 ;   none
 ;
 ; patient ien not setup
 S DGDFN=+$G(DGDFN)
 Q:'DGDFN
 ;
 N DGPFAPI
 ;
 ; call API to get the display array for ALL Active Assignments
 S DGPFAPI=$$GETACT^DGPFAPI(DGDFN,"DGPFAPI")  ;DBIA #3860
 ;
 ; quit if no Active Record Flags to display
 Q:'+DGPFAPI
 ;
 ; call api to display Active Record Flags
 D DISPACT(.DGPFAPI)
 ;
 ; prompt to ask User for Displaying Flag Details
 Q:'$$ASKDET()
 ;
 ; display the details of patients Active record flags
 ;D DISPDET(.DGPFAPI)  ;roll-and-scroll
 D EN^DGPFLMD(DGDFN,.DGPFAPI)  ;ListMan
 Q
 ;
SELPAT(DGPAT) ;This procedure is used to perform a patient lookup for an existing patient in the PATIENT (#2) file.
 ;
 ;  Input: None
 ;
 ; Output:
 ;   DGPAT - result array containing the patient selection on success,
 ;           pass by reference. Array will have same structure as the Y
 ;           variable returned by the ^DIC call.
 ;            Array Format:
 ;            -------------
 ;                 DGPAT = IEN of patient in PATIENT (#2) file on
 ;                         success, -1 on failure
 ;              DGPAT(0) = zero node of entry selected
 ;            DGPAT(0,0) = external form of the .01 field of the entry
 ;
 ;- int input vars for ^DIC call
 N DIC,DTOUT,DUPOT,X,Y
 S DIC="^DPT(",DIC(0)="AEMQZV"
 ;
 ;- lookup patient
 D ^DIC K DIC
 ;
 ;- result of lookup
 S DGPAT=Y
 ;
 ;- if success, setup return array using output vars from ^DIC call
 I (+DGPAT>0) D
 . S DGPAT=+Y              ;patient ien
 . S DGPAT(0)=$G(Y(0))     ;zero node of patient in (#2) file
 . S DGPAT(0,0)=$G(Y(0,0)) ;external form of the .01 field
 ;
 Q
 ;
 ;
GETFLAG(DGPFPTR,DGPFLAG) ;retrieve a single FLAG record
 ;  This function acts as a wrapper around the $$GETLF and $$GETNF
 ;  API's. Function will be used to obtain a single flag record from
 ;  either the PRF LOCAL FLAG (#26.11) file or the PRF NATIONAL FLAG
 ;  (#26.15) file depending on the value of the DGPFPTR input parameter.
 ;
 ;  Input:
 ;   DGPFPTR - (required) IEN of patient record flag in PRF NATIONAL
 ;             FLAG (#26.15) file or PRF LOCAL FLAG (#26.11) file.
 ;             [ex: "1;DGPF(26.15,"]
 ;
 ; Output:
 ;  Function Value - returns 1 on success, 0 on failure
 ;         DGPFLAG - (required) result array passed by reference. See the
 ;                   $$GETLF and $$GETNF for the result array structure.
 ;
 N RESULT   ;returned function value
 N DGPFIEN  ;ien of PRF local or national flag file
 N DGPFILE  ;file # of PRF local or national flag file
 ;
 S RESULT=0
 ;
 D
 . ;-- quit if pointer is not valid
 . Q:$G(DGPFPTR)']""
 . Q:'$$TESTVAL^DGPFUT(26.13,.02,DGPFPTR)
 . ;
 . ;-- get ien and file from pointer value
 . S DGPFIEN=+$G(DGPFPTR)
 . S DGPFILE=$P($G(DGPFPTR),";",2)
 . ;
 . ;-- if local flag file, get local flag into DGPFLAG array
 . I DGPFILE["26.11" D
 . . Q:'$$GETLF^DGPFALF(+DGPFIEN,.DGPFLAG)
 . . S RESULT=1  ;success
 . ;
 . ;-- if national flag file, get national flag into DGPFLAG array
 . I DGPFILE["26.15" D
 . . Q:'$$GETNF^DGPFANF(+DGPFIEN,.DGPFLAG)
 . . S RESULT=1  ;success
 ;
 Q RESULT
