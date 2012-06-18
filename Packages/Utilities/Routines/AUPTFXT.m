%AUPTFXT ;BRJ/IHS [ 03/09/87  7:32 AM ]
 W !,*7,"%AUPTFXT cannot be executed at this entry point!!"
 Q
EN ;ENTRY FROM %AUPTFX - RUN %AUFXPT THEN ASK FOR FILEMAN AND USER FILE NAMES
 N AUPTPGM S AUPTPGM="<"_$T(+0)_">"
 F AUPTLBL="INFO","ASKARRAY","ASKFILE","ASKDSPLY","GO" D @(AUPTLBL):'AUPTQUIT
 K AUPTANS,AUPTI1,AUPTI2,AUPTPTFL,AUPTPTFD,AUPTDDFL
 Q
INFO ;INFORM USER WHAT'S GOING TO HAPPEN AND CALL %AUFIXPT TO CLEAN UP "PT" NODE
 W !!,AUPTPGM,?11,"This program will exchange old (BAD!) pointer values for new (GOOD?)",!,?11,"pointer values in all FM files that point to a given file."
 W !!,?11,"The new pointer values should already be in a global array."
 Q
ASKARRAY ;ASK FOR USER ARRAY GLOBAL NAME
 W !!,AUPTPGM,?11,"Please enter the name of this global.",!!,?15,*7,"Global name = ^"
 R AUPTANS:DTIME E  D TIMEOUT Q
 I $E(AUPTANS)="?" D HLPARRAY G ASKARRAY
 I $E(AUPTANS=U&($L(AUPTANS)=1)) W !!,AUPTPGM,?11,"G o o d b y e !!" S AUPTQUIT=1 Q
 I AUPTANS="" D NOARRAY Q:AUPTQUIT  G ASKARRAY
 I $E(AUPTANS)'=U S AUPTANS=U_AUPTANS
 S AUPTUFLE=AUPTANS
 I '$D(@AUPTUFLE) D NOARRAY Q:AUPTQUIT  G ASKARRAY
 S AUPTUFLE=AUPTUFLE_"(AUPTOLDX)"
 Q
NOARRAY ;USER ARRAY DOES NOT EXIST OR WASN'T ENTERED BY OPERATOR
 W !!,AUPTPGM,?11,"Your global name was not entered or does not exist!!",!,?15,"Do you want to continue?",!,?15,*7,"[Y]es or [N]o  <N>// "
 R AUPTANS:DTIME E  D TIMEOUT Q
 I $E(AUPTANS)'="Y" W !!,AUPTPGM,?11,"OK - I'm getting out now!!" S AUPTQUIT=1
 Q
HLPARRAY ;HELP USER
 W !!,AUPTPGM,?11,"This program requires the user to have created a global that contains",!,?11,"the old/new pointer values.",!!,?11,"The format for the global is ^gbl(""old"")=new where:"
 W !,?15,"^gbl  is the global name",!,?15,"""old"" is the old (BAD!) entry number",!,?21,"i.e. the value to be corrected",!,?15,"""new"" is the new (GOOD?) entry number",!,?21,"i.e. the correct value."
 Q
ASKFILE ;ASK FILEMAN TO GET FILENAME
 W !!,AUPTPGM,?11,"I'm going to have FileMan ask you to enter the FM name or number of",!,?11,"the 'pointed to' file to be processed.",!,*7
ASKFM S DIC="^DIC(",DIC(0)="MAEQ" D ^DIC S AUPTY=Y,AUPTFILE=+$P(Y,U,1) K DIC,DIC(0),Y
 I AUPTFILE<0 D NOFILE Q:AUPTQUIT  G ASKFM
 S AUPTFSTK(1)=AUPTFILE
 Q
NOFILE ;FILEMAN FILE WAS NOT ENTERED OR NOT FOUND
 W !!,AUPTPGM,?11,"No file was selected."
 W !!,AUPTPGM,?11,"Do you want to select another file?",!!,?15,*7,"[Y]es or [N]o  <N>// "
 R AUPTANS:DTIME E  D TIMEOUT Q
 I $E(AUPTANS)'="Y"  W !!,AUPTPGM,?11,"OKIE DOKE - No action on this run.  B Y E....." S AUPTQUIT=1
 Q
ASKDSPLY ;ASK TO DISPLAY DATA NODES ARE THEY ARE EXCHANGED
 W !!,AUPTPGM,?11,"Do you want me to display the 'before and after' of each global node",!,?11,"when an exchange occurs?",!!,?11,"Answering <Y>es may extend the run time substantially!!",!!,?15,*7,"[Y]es or [N]o?  <N>// "
 R AUPTANS:DTIME  E  D TIMEOUT Q
 S:$E(AUPTANS)="Y" AUPTDSPY=1
 Q
GO ;OFF AND RUNNING
 W !!,AUPTPGM,?11,"O K - I'm set up to go.",!,?11,"Be prepared for this program to take some time."
 W !,AUPTPGM,?11,"I will display which FM file/field is being processed."
 W !!,?11,"Also, if you didn't want to display the 'before and after,",!,?11,"I will display the following characters accordingly:"
 W !,?15,"a ""-"" indicates a data node was found",!,?15,"a ""X"" indicates an exchange occurred.",!,?15,"a ""|"" indicates setting cross references, triggers, etc.",!,?19,"occurred."
 W !!,AUPTPGM,?11,"Press <RETURN> when ready!!   W A I T I N G . . ."
 R AUPTANS:DTIME E  D TIMEOUT Q
 W !!,AUPTPGM,?11,"I'm off and running......"
 Q
TIMEOUT ;QUIT IF TIMEOUT ON READS OCCUR
 S AUPTEC=9,AUPTQUIT=1 D ERR
 Q
ERR ;DISPLAY ERROR MESSAGES FROM ^AUPTFIX
 S AUPTSKIP=1
 W !!,*7,AUPTPGM,?11,$P($T(ERRMSG+(AUPTEC)),";;",2)
 Q:AUPTEC=9
 I AUPTEC=1 W !,?15,"FILE= ",$P(AUPTY,U,1)," - ",$P(AUPTY,U,2)
 E  W !,?15,"FILE= ",AUPTPSFL,"  FIELD= ",AUPTPSFD,!!,AUPTPGM,?11,"Skipping to next ""PT"" node."
 Q
ERRMSG ;;ERROR MESSAGE LIST
1 ;;File did not contain any "PT" nodes. No action.
2 ;;<SNAFU> Missing "0" node at ^DD(fl,fd,0)
3 ;;<SNAFU> Missing "NM" node at ^DD(fl,0,"NM",sflname)
4 ;;<SNAFU> Missing "B" node at ^DD(fl,"B",flname,upsflnbr)
5 ;;<SNAFU> Missing ^(1) or ^(2) node at ^DD(fl,fd,1,xridx,xrnbr)
6 ;;<SNAFU> Missing "GL" node at ^DIC(fl,0,"GL")
7 ;;<SNAFU> Missing "global name" at ^DD(fl,fd,0) for DINUM=X
8 ;;<SNAFU> Missing "0" node at ^DIC(fl,0)
9 ;;<TIME-OUT> Your took too long to respond.  SO SORRY!!  Bye bye!
