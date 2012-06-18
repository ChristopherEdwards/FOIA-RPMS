BILETPR ;IHS/CMI/MWR - PRINT PATIENT LETTERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRINT PATIENT LETTERS.
 ;
 ;
 ;----------
START ; EP
 ;---> Print letters for individual patients (loop).
 ;---> Allows selection of patient and letter.
 ;
 D SETVARS^BIUTL5 S (BIPOP1,BIPOP)=0
 N BILET,BITITLE
 F  S BIPOP=0 D  Q:BIPOP1
 .D PATIENT(.BIDFN,.BIPOP1) Q:BIPOP1
 .D ASKLET(.BILET,.BIDLOC,.BIPOP) Q:BIPOP
 .D DEVICE Q:BIPOP
 .D PRINT(BIDFN,BILET,$G(BIDLOC),ION)
 D ^%ZISC
 D EXIT
 Q
 ;
 ;
 ;----------
PATIENT(BIDFN,BIPOP) ;EP
 ;---> Select Patient.
 ;---> Parameters:
 ;     1 - BIDFN  (ret) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIPOP  (ret) BIPOP=1 if selection failed.
 ;
 S BIPOP=0
 D TITLE^BIUTL5("PRINT INDIVIDUAL LETTERS")
 D PATLKUP^BIUTL8(.BIDFN)
 S:BIDFN<1 BIPOP=1
 Q
 ;
 ;
 ;----------
ASKLET(BILET,BIDLOC,BIPOP,BIDFLT) ;EP
 ;---> Select Form Letter.
 ;---> Parameters:
 ;     1 - BILET  (ret) IEN of Form Letter.
 ;     2 - BIDLOC (ret) Text of Date/Location line.
 ;     3 - BIPOP  (ret) BIPOP=1 if selection failed.
 ;     3 - BIDFLT (opt) IEN of default letter.
 ;
 N X,Y S BIPOP=0
 ;
 D
 .I $G(BIDFLT) I $D(^BILET(BIDFLT,0)) S BIDFLT=$P(^(0),U) Q
 .S BIDFLT=""
 ;
 ;---> Select Form Letter.
 W !!?3,"Please select the Form Letter you wish to use."
 W !?3,"Type ""?"" (no quotes) to see a list of available letters.",!!
 D DIC^BIFMAN(9002084.4,"QEMA",.Y,"   Select Form Letter: ",BIDFLT)
 I Y<1 S BIPOP=1 Q
 S BILET=+Y
 ;
 ;---> If this letter prints a Date/Location line, prompt for it.
 D ASKDLOC(BILET,.BIDLOC,.BIPOP)
 Q
 ;
 ;
 ;----------
ASKDLOC(BILET,BIDLOC,BIPOP) ;EP
 ;---> Ask for Date/Location line (up to 70 characters).
 ;---> Parameters:
 ;     1 - BILET  (req) IEN of Form Letter.
 ;     2 - BIDLOC (ret) Text of Date/Location line.
 ;     3 - BIPOP  (ret) BIPOP=1 if selection failed.
 ;
 Q:'$G(BILET)  Q:'$D(^BILET(BILET,0))
 ;---> Quit if this letter does not print a Date/Location line.
 Q:'$P(^BILET(BILET,0),U,4)
 D TITLE^BIUTL5("DATE/LOCATION LINE"),TEXT1
 N DIR,DIRUT S BIPOP=0
 S DIR("?")="     Enter the text of the Date/Location Line (up to 70 "
 S DIR("?")=DIR("?")_"characters long)"
 S DIR(0)="FA^1:70",DIR("A")="        "
 S:$D(^BIDLOC(DUZ,0)) DIR("B")=$P(^(0),U,2)
 D ^DIR
 I $D(DIRUT) S BIPOP=1 Q
 S BIDLOC=Y
 ;
 ;---> Now store user's Date-Loc Line.
 Q:BIDLOC=""
 Q:DUZ=0
 ;---> Clear any previous Date-Loc Line for this user.
 K ^BIDLOC(DUZ),^BIDLOC("B",DUZ)
 ;---> Store this Date-Loc Line for this user.
 S ^BIDLOC(DUZ,0)=DUZ_U_BIDLOC,^BIDLOC("B",DUZ,DUZ)=""
 Q
 ;
 ;
 ;----------
PRINT(BIDFN,BILET,BIDLOC,IOP,BIFDT,BIPOP) ;EP
 ;---> Print a letter for a  patient.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BILET  (req) IEN of Letter in BI LETTER File.
 ;     3 - BIDLOC (opt) Text of Date/Location line.
 ;     4 - IOP    (req) Output Device Name. (Will inhibit ^DIWF from
 ;                      prompting for Device. Should be equal to ION.)
 ;     5 - BIFDT  (opt) Forecast Date (=Today if not given).
 ;     6 - BIPOP  (ret) If BIPOP=1, output was to screen and user
 ;                      entered "^".
 ;
 ;---> CodeChange for v7.1 - IHS/CMI/MWR 12/01/2000:
 ;---> Next line, if IOP not passed, set to ION.
 ;S:'$D(IOP) IOP="HOME"
 S:'$D(IOP) IOP=$G(ION) S:IOP="" IOP="HOME"
 S BIPOP=0
 ;
 ;---> If this is not a printer, set BICRT=1
 N BICRT
 S BICRT=$S(($E(IOST)="C")!(IOST["BROWSER"):1,1:0)
 ;
 U IO
 N BIERR
 I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) Q
 I '$D(^DPT(BIDFN,0)) D ERRCD^BIUTL2(203,,1) Q
 I '$G(BILET) D ERRCD^BIUTL2(609,,1) Q
 I '$D(^BILET(BILET,0)) D ERRCD^BIUTL2(610,,1) Q
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;
 ;---> Quit if Patient is locked.
 L +^BIP(BIDFN):1 I '$T U IO D  Q
 .W !!?5,"The selected Patient is being edited by another user."
 .W !?5,"Please try printing this letter later."
 .W:'BICRT @IOF D:BICRT DIRZ^BIUTL3()
 ;
 ;---> If patient is deceased, don't print letter; print explanation.
 I $$DECEASED^BIUTL1(BIDFN) D  Q
 .D DECEASED(BIDFN,BICRT),UNLOCK^BIPATUP(BIDFN)
 ;
 ;---> Build temporary global of populated letter in ^TMP("BILET",$J).
 D BUILD^BILETPR1(BIDFN,BILET,$G(BIDLOC),$G(BIFDT))
 ;
 ;---> Now print.
 ;
 ;---> Unsuccessful use of ^DIWF.
 ;S DIWF="^TMP(""BILET"","_$J_","
 ;S DIWF(1)=2
 ;---> This method takes too long too find patient (up to 40 minutes!).
 ;S BY="INTERNAL(#.01)="_BIDFN
 ;---> This method finds the patient quickly but reprints the letter
 ;---> in an unending loop.
 ;S BY="",BY(0)="^DPT(",L(0)=1,FR(0,1)=BIDFN,TO(0,1)=BIDFN
 ;S:'BICRT DIOEND="W @IOF"
 ;---> Print it to IOP.
 ;D EN2^DIWF
 ;D:BICRT DIRZ^BIUTL3(.BIPOP)
 ;
 ;---> Call homegrown letter printer.
 D PRINT^BILETPR4(BIDFN,IO,IOST,.BIERR)
 ;
 ;---> If error printing, display/write and quit.
 I $G(BIERR) D  Q
 .D ERRCD^BIUTL2(BIERR,,1),UNLOCK^BIPATUP(BIDFN),^%ZISC
 ;
 ;---> If this was to the screen, don't store "DATE OF LAST LETTER".
 D:BICRT
 .W !!?3,"NOTE: Because this letter was only displayed on a screen and"
 .W !?9,"not printed on a printer, it will NOT yet be logged by the"
 .W !?9,"program as having been printed and sent to the patient.",!
 .D DIRZ^BIUTL3(.BIPOP)
 ;
 ;---> Close Device.
 D ^%ZISC
 ;
 ;---> Store the date of this letter in the DATE OF LAST LETTER
 ;---> field of the BI PATIENT File.
 I 'BICRT,$D(^BIP(BIDFN,0)) D DIE^BIFMAN(9002084,".14////"_DT,BIDFN)
 ;
 D UNLOCK^BIPATUP(BIDFN)
 Q
 ;
 ;
 ;----------
DEVICE ;EP
 ;---> Get Device and possibly queue to Taskman.
 K %ZIS,IOP
 S ZTRTN="PRINT^BILETPR(BIDFN,BILET,$G(BIDLOC),,$G(BIFDT))"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DECEASED(BIDFN,BICRT) ;EP
 ;---> If the patient is deceased, display message.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BICRT  (req) BICRT=1 if output is to screen or Browser.
 ;
 W !!?3,"NOTE: Because this patient"
 I $G(BIDFN) I $D(^DPT(BIDFN,0)) D
 .W ", ",$$NAME^BIUTL1(BIDFN)," #",$$HRCN^BIUTL1(BIDFN),","
 W " is now"
 W !?9,"registered as deceased, the letter will NOT be printed."
 W !?9,"This patient should be inactivated in the Immunization "
 W "Register."
 D:BICRT DIRZ^BIUTL3() W:'BICRT @IOF
 Q
 ;
 ;
 ;----------
EXIT ;EP
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;The letter you have selected prints a Date/Location line between
 ;;between the Bottom Section and the Closing Section of the letter.
 ;;An example would be:
 ;;
 ;;   5-May-1998 at the Children's Clinic, Alaska Native Medical Center
 ;;
 ;;This line may be up to 70 characters long.
 ;;Please enter/edit the Date/Location line now.
 ;;
 ;;Line:
 ;;
 D PRINTX("TEXT1",5)
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 N BITEXT,I,T,X S T="" F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 D EN^DDIOL(.BITEXT)
 Q
