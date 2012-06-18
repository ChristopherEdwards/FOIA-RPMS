A4A7163 ; GLRISC/REL - New Person conversion ;3/12/89  17:50 ;
 ;;1.01
P5 W !!,"There is the possibility of duplicate SSN's in File 16 which"
 W !,"could be moved to File 200. We will check for duplicate"
 W !,"SSN's and list any for you to correct."
 W !!,"Beginning Pass 5 ...",!
 S ERR5=0 K ^UTILITY($J)
 F K=.9:0 S K=$N(^DIC(16,K)) Q:K<1  S SSN=$S($D(^DIC(16,K,0))#2:$P(^(0),"^",9),1:"") I SSN'="" S ^UTILITY($J,SSN,K)=""
 D A5
P6 W !!,"There may be File 6 entries which do not point to a correct"
 W !,"File 16 entry either because that entry is missing or because"
 W !,"the File 16 back-pointer is incorrect. We will list such cases."
 W !!,"Beginning Pass 6 ...",!
 S ERR6=0 K ^UTILITY($J)
 F K=.9:0 S K=$N(^DIC(6,K)) Q:K<1  S P16=$S($D(^(K,0))#2:$P(^(0),"^",1),1:"") D A6
 K ^UTILITY($J)
 I VER="U" S ^VA(200,0)="NEW PERSON^200^"_LAST200_"^"_NUM200 D ^A4A7164
 G E1
A5 S SSN=""
A51 S SSN=$O(^UTILITY($J,SSN)) Q:SSN=""  S K1=$N(^UTILITY($J,SSN,0)) G:K1<1 A51
 I $N(^UTILITY($J,SSN,K1))<1 G A51
 I 'ERR5 W !!?14,"Duplicate SSN's",!,"SSN",?12,"File 16 #",?30,"File 16 Name",!
 W !!,SSN,?12,K1,?30,$P(^DIC(16,K1,0),"^",1)
 F K1=K1:0 S K1=$N(^UTILITY($J,SSN,K1)) Q:K1<1  S ERR5=ERR5+1 W !?12,K1,?30,$P(^DIC(16,K1,0),"^",1)
 G A51
A6 S P6="" G:P16<1 A61 I $D(^DIC(16,P16,0))#2=0 G A61
 S P6=$S($D(^DIC(16,P16,"A6"))#2:^("A6"),1:"") Q:P6=K
 I 'P6 S ^DIC(16,P16,"A6")=K Q
A61 I 'ERR6 W !!,?14,"File 6 Entries with Incorrect File 16 pointer",!,"File 6#     Pointer to 16     File 16 Back-pointer",!
 S ERR6=ERR6+1 W !,K,?12,P16,?31,P6 Q
E1 W !!!?8,"* * * The ",$S(VER="V":"VERIFY",1:"UPDATE")," run is now complete. * * *",!
 G E7:VER="U",E2:'ERR1
 W !!,"During Pass 2 there were ",ERR1," name mis-matches found"
 W !,"between File 3 and File 16. Check them. We will use the"
 W !,"File 3 name during the update pass. If the File 3 name is incorrectly"
 W !,"spelled, edit it. You may ignore incorrect spellings in File 16."
 W !,"if you wish."
E2 G:'ERR2 E3
 W !!,"During Pass 2 there were ",ERR2," duplicates in File 16;"
 W !,"that is, cases where two File 16 entries pointed to the SAME"
 W !,"File 3 entry. If not corrected, during the update run File 200"
 W !,"will use the File 3 name and the SSN of the first File 16 entry."
E3 G:'ERR3 E4
 W !!,"During Pass 3 there were ",ERR3," cases where entries existed"
 W !,"in File 16 but not in File 3. These are providers who are"
 W !,"not users but will be added to File 3 during the update run."
E4 G:'ERR4 E5
 W !!,"During Pass 4 there were ",ERR4," cases where entries existed"
 W !,"in File 3 but not in File 16. This means the File 3-16 linkage"
 W !,"was missing and no SSN was available for transfer to File 200"
 W !,"since the SSN exists only in File 16. If possible, you might wish"
 W !,"to correct these cases by editing Field 100 in File 3;"
 W !,"this will create a File 16 entry with an SSN."
E5 G:'ERR5 E6
 W !!,"During Pass 5 there were ",ERR5," instances of duplicate SSN's"
 W !,"found during verification. These should be corrected."
 W !,"If the two persons are different, edit the SSN in File 16"
 W !,"which is incorrect so as to eliminate the duplicate."
 W !!,"If the two people are the same then the situation is more"
 W !,"difficult. Neither should be deleted at this time."
E6 G:'ERR6 E7
 W !!,"During Pass 6 there were ",ERR6," instances where File 6"
 W !,"pointed to an incorrect File 16 entry. Edit the .01 field"
 W !,"of File 6 to correct this."
E7 W !!?11,"* * * * *     D O N E     * * * * *",! Q
