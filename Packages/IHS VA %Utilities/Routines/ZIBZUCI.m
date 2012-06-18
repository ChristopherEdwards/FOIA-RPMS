%ZUCI ; IHS/ADC/GTH - SWAP UCI BETWEEN VOLUME SETS FOR MSM-UNIX ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; SAVE THIS ROUTINE AS %ZUCI IN THE MGR UCI
 ;
 ; This utility permits switching between UCIs and Volume
 ; Groups when run in programmer mode.  D ^%ZUCI
 ;
 ; If switching to a UCI in a Volume Group other than the
 ; System Volume Group (0), you must enter either the Volume
 ; Group Number or Volume Group Name along with the UCI Number
 ; or Name.  A 'help' display identifies all UCIs and Volume
 ; Groups that are currently mounted.  Use a '?' for 'help'.
 ;
 ; A routine may be tied to the UCI,VOL switch.  This routine
 ; will be called immediately after the UCI,VOL switch occurs.
 I $$VERSION^%ZOSV(1)["Cache" D ^%CD Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 ;
EN ; ENTRY - Ask for [UCI,VOL]
 W !,"SWITCH TO NEW UCI",!
 S $P(%ZIB("DASHES"),"-",81)=""
ASK ; Get new UCI name or number.
 F %ZIB("ASK")=0:0:0 D
 . S %ZIB("ZT")=0 ; Set DSM error flag for <NOUCI> or <NOSYS>
 . S %ZIB("VERIFY UCI")=0 ; Verify UCI flag set to NO.
 . W !,"You are now in ",$ZU(0)
 . W !!,"Enter new UCI: "
 . ; If read timesout or a "^" or <RET> is entered then set the
 . ; loop at ASK+1 to quit
 . R %ZIB("%"):45 E  W *7,"**Timeout**",!!,"You are still in ",$ZU(0) S %ZIB("ASK")=1 Q
 . I "^"[%ZIB("%") W *7,"  No action taken!",!!,"You are still in ",$ZU(0) S %ZIB("ASK")=1 Q
 . S %ZIB("VERIFY UCI")=1 ; Verify UCI flag set to YES.
ED . ; Edit input from user.
 . D  ; Edit input.
 .. S %ZIB("ASK")=1 ; Set loop at ASK+1 to QUIT.
 .. Q:%ZIB("%")?3A
 .. Q:%ZIB("%")?3A1":"1.17E
 .. Q:%ZIB("%")?3A1","3A
 .. Q:%ZIB("%")?3A1","3A1":"1.17E
 .. Q:%ZIB("%")?2N
 .. Q:%ZIB("%")?2N1":"1.17E
 .. Q:%ZIB("%")?2N1","1N
 .. Q:%ZIB("%")?2N1","1N1":"1.17E
 .. Q:%ZIB("%")?1N
 .. Q:%ZIB("%")?1N1":"1.17E
 .. Q:%ZIB("%")?1N1","1N
 .. Q:%ZIB("%")?1N1","1N1":"1.17E
 .. I %ZIB("%")'["?" D
 ... W "  ??   **Incorrect input**",*7
 ... W !,%ZIB("DASHES")
 ... W !,"Enter ""?"" to get help or"
 ... W !,"Enter {UCI} {UCI:ROUTINE} {UCI,VOL} {UCI,VOL:ROUTINE}"
 ... W !,%ZIB("DASHES")
 .. S %ZIB("ASK")=0 ; Continue the loop at ASK+1.
 .. S %ZIB("VERIFY UCI")=0 ; Set verify UCI flag to NO.
HLP .. ; Display UCI list.
 .. I %ZIB("%")?1"?" D
 ... W !,%ZIB("DASHES")
 ... W !,"UCIs and VOLume groups are identified by either a name or number."
 ... W !,"Use the name or number identification when selecting a UCI."
 ... W !!,"Enter ""??"" to get a list of UCIs and VOLume sets."
 ... W !,"      ""???"" to get examples."
 ... W !!,"Enter {UCI} {UCI,VOL} {UCI:ROUTINE} {UCI,VOL:ROUTINE}."
 ... W !,%ZIB("DASHES")
 .. I %ZIB("%")?1"??" D
 ... W !!,"Select from any UCI,VOL from this list:"
 ... S %ZIB("NO SYS")=0 ; Set no more VOLUME SETs for MSM.
 ... F %ZIB("VOL NBR")=0:1 D  Q:%ZIB("NO SYS")
 .... S $ZT="ZT^%ZIBZUCI" ; Set DSM error trap for <NOSYS>.
 .... I $ZU(1,%ZIB("VOL NBR"))="" S %ZIB("NO SYS")=1 Q  ; DSM gets a <NOSYS> error if end of VOLUME SETs.
 .... W !,%ZIB("DASHES")
 .... W !,"UCIs in Volume Group Number ",%ZIB("VOL NBR")," . . . Volume Group Name is ",$P($ZU(1,%ZIB("VOL NBR")),",",2),!
 .... S %ZIB("NO UCI")=0 ; Set no more UCI flag for MSM.
 .... F %ZIB("UCI NBR")=1:1 D  Q:%ZIB("NO UCI")
 ..... S $ZT="ZT^%ZIBZUCI" ; Set DSM error trap for <NOUCI> error.
 ..... I $ZU(%ZIB("UCI NBR"),(%ZIB("VOL NBR")))="" S %ZIB("NO UCI")=1 Q  ; End of UCIs for this VOLUME SET.
 ..... S %ZIB("UCI,VOL","NAME")=$ZU(%ZIB("UCI NBR"),%ZIB("VOL NBR"))
 ..... S %ZIB("UCI,VOL","NBR")=%ZIB("UCI NBR")_","_%ZIB("VOL NBR")
 ..... W:'((%ZIB("UCI NBR")-1)#3) !
 ..... W "UCI ",%ZIB("UCI,VOL","NBR")," is ",%ZIB("UCI,VOL","NAME")
 ..... W $J("",25-($L(%ZIB("UCI,VOL","NBR"))+$L(%ZIB("UCI,VOL","NAME"))+8))
 ... W !,%ZIB("DASHES")
EXAMP .. ;
 .. I %ZIB("%")?1"???" D
 ... W !!,"Examples for switching UCIs",?53,"NAME SYNTAX",?67,"NUMBER SYNTAX"
 ... W !,%ZIB("DASHES")
 ... W !," Switch to DEV on default volume group (0)",?55,"DEV",?72,"3"
 ... W !," Switch to DEV on the volume group AAA (1)",?55,"DEV,AAA",?72,"3,1"
 ... W !,%ZIB("DASHES")
 ... W !,"Examples of switching UCIs and running a routine"
 ... W ?55,"DEV:%SY",?72,"3:%SY"
 ... W !?55,"DEV,AAA:%SY",?72,"3,1:%SY"
 ... W !?55,"DEV:P^DI",?72,"3:P^DI"
 ... W !,%ZIB("DASHES")
 ... W !,"NOTE: Name,Number combinations for UCI,VOL syntax are mutually exclusive."
 ... W !,"If you select a UCI in a Volume Group greater than 0 -"
 ... W !,"Then you must enter the Volume Group Name or Number!"
 ... W !,%ZIB("DASHES")
VER .. ; Verify if UCI,VOL exists.
 . Q:'%ZIB("VERIFY UCI")  ; Stop if verify UCI flag set to NO.
 . S %ZIB("NEW UCI")=$P($P(%ZIB("%"),","),":")
 . S %ZIB("NEW VOL")=$P($P(%ZIB("%"),",",2),":")
 . I %ZIB("NEW VOL")="" D
 .. I %ZIB("NEW UCI")?1N.E F %=0:1:20 I $P($ZU(0),",",2)=$P($ZU(1,%),",",2) S %ZIB("NEW VOL")=% I 1 Q
 .. E  S %ZIB("NEW VOL")=$P($ZU(0),",",2)
 . S $ZT="ZT^%ZIBZUCI" ; Set DSM error trap for <NOSYS> or <NOUCI>
 . I $ZU(%ZIB("NEW UCI"),%ZIB("NEW VOL"))="" S %ZIB("ZT")=1 Q
SW . ; SWITCH TO NEW UCI
 . I %ZIB("NEW UCI")?3A S %ZIB("UCI,VOL")=$ZU(%ZIB("NEW UCI"),%ZIB("NEW VOL"))
 . E  S %ZIB("UCI,VOL")=%ZIB("NEW UCI")_","_%ZIB("NEW VOL")
 . I $ZV["DSM" V 148:$J:$V(148,$J)#256+($P(%ZIB("UCI,VOL"),",",2)*32+$P(%ZIB("UCI,VOL"),",")*256)
 . E  V 2:$J:$P(%ZIB("UCI,VOL"),",",2)*32+$P(%ZIB("UCI,VOL"),","):2
 . W !!,*7,"You have switched to ",$ZU(0),"  {",%ZIB("UCI,VOL"),"}"
 . S %ZIB("ASK")=1 ; Set loop at ASK+1 to QUIT.
 I %ZIB("ZT") W !!,*7,"Sorry - ",%ZIB("NEW UCI"),",",%ZIB("NEW VOL")," does not exist!",!,"** NO ACTION TAKEN**!",! G ASK
EX ; EXIT
 KILL % ; Remove the call routine variable.
 I ""'[$P(%ZIB("%"),":",2) D
 . S %=$P(%ZIB("%"),":",2)
 . I $E(%)="^" S %=$E(%,1,9)
 . E  I %["^"
 . E  S %="^"_$E(%,1,8)
 KILL %ZIB ; Remove symbol table entries.
 S $ZT="ZT^%ZIBZUCI" ; Set error trap for <NOPGM> or <LINER>
 G:$D(%) @% ; GO TO routine if requested.
 Q  ; UCI switch completed
 ;
ZT ; Error trap for DSM.
 I $ZE?1"<NOSY".E!($ZE?1"<NOUC".E) D  Q
 . S %ZIB("ZT")=1 ; Set for UCI,VOL does not exist.
 . S %ZIB("VERIFY UCI")=0 ; Set verify UCI flag to NO.
 . I $ZE?1"<NOSY".E S %ZIB("NO SYS")=1 ; Set for VOL loop to QUIT.
 . E  S %ZIB("NO UCI")=1 ; Set for UCI loop to QUIT.
 I $ZE?1"<NOPGM".E D  Q
 . W *7,!!,"Routine ",$P(%,"^",2)," is not in ",$ZU(0),"'s ",$S(%["%":"Library or MGR UCI ",1:""),"routine directory!!",!
 . KILL %
 I $ZE?1"<LINER".E D  Q
 . W *7,!!,"Label ",$P(%,"^")," is missing in routine ",$P(%,"^",2),"!!",!
 . KILL %
 ZQ
 ;
